//
//  FloatingPlaceholderTextField.swift
//
//  Copyright (c) 2020 Chris Pflepsen
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

enum PlaceholderStyle {
    case normal
    case floating
}

struct TextFieldStyle {
    let placeHolderStringStyle: StringStyle
    let floatingPlaceholderStringStyle: StringStyle
}

public class FloatingPlaceholderTextField: UITextField {
    
    let bag = DisposeBag()
    let floatingPlaceholder = UILabel()
    var placeholderState: PlaceholderStyle = .normal
    
    private var startTime: TimeInterval?, endTime: TimeInterval?
    private var displayLink: CADisplayLink?
    private let animationDuration = 0.3
    private let floatingHeight: CGFloat = 10.0
    private let floatingY: CGFloat = -5.0
    
    private var isAnimating = false

    private let calculationQueue = DispatchQueue(label: "FloatingPlaceholderCalculations", attributes: .concurrent)
    
    private(set) var style: Style?
    
    var interceptedPlaceholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    public override var placeholder: String? {
        set {
            interceptedPlaceholder = newValue
            super.placeholder = nil
        }
        get {
            return interceptedPlaceholder
        }
    }
    
    public override var attributedPlaceholder: NSAttributedString? {
        set {
            interceptedPlaceholder = newValue?.string
            super.attributedPlaceholder = nil
        }
        get {
            guard let currentPlaceholder = interceptedPlaceholder else { return nil }
            return NSAttributedString(string: currentPlaceholder)
        }
    }
    
    public override var text: String? {
        set {
            super.text = newValue
            if isEditing {
                placeholderState = .floating
            } else {
                placeholderState = (newValue?.isEmpty ?? true) ? .normal : .floating
            }
            //Do not update the frame during an animation
            if !isAnimating {
                finishAnimation()
            }
        }
        get {
            return super.text
        }
    }
    
    public override var attributedText: NSAttributedString? {
        set {
            super.attributedText = newValue
            if isEditing {
                placeholderState = .floating
            } else {
                placeholderState = (newValue?.string.isEmpty ?? true) ? .normal : .floating
            }
            finishAnimation()
        }
        get {
            return super.attributedText
        }
    }
    
    public override func insertText(_ text: String) {
        super.insertText(text)

        //This fixes a bug when a PasswordTextField was first responder on a screen and the screen re-appears
        placeholderState = .floating
        finishAnimation()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        if let style = StyleRegistry.standard.style(forStylable: .textField) {
            apply(style: style)
        }
        
        setupViews()
        bindUI()
    }
    
    private func setupViews() {
        clipsToBounds = false
        borderStyle = .none
        
        addSubview(floatingPlaceholder)
        
        floatingPlaceholder.frame = self.bounds
        floatingPlaceholder.clipsToBounds = false
    }
    
    private func bindUI() {
        
        rx
            .controlEvent(.editingDidBegin)
            .bind { [weak self] (_) in
                self?.setupFloatingAnimation()
            }
            .disposed(by: bag)
        
        rx
            .controlEvent(.editingDidEnd)
            .bind { [weak self] (_) in
                if let text = self?.text,
                    text.isEmpty {
                    self?.setupPlaceholderAnimation()
                }
            }
            .disposed(by: bag)
        
    }
    
    private func setupFloatingAnimation() {
        guard placeholderState != .floating else {
            return
        }
        
        placeholderState = .floating
        setupAnimation()
    }
    
    private func setupPlaceholderAnimation() {
        guard placeholderState != .normal else {
            return
        }
        
        placeholderState = .normal
        
        setupAnimation()
    }
    
    private func placeholderStyle() -> StringStyle {
        return style?.primaryStringStyle ?? StringStyle(font: UIFont.systemFont(ofSize: 14.0),
                                                        textColor: .lightGray,
                                                        characterSpacing: 1,
                                                        lineHeight: nil)
    }
    
    private func floatingPlaceholderStyle() -> StringStyle {
        return style?.secondaryStringStyle ?? StringStyle(font: UIFont.systemFont(ofSize: 10.0),
                                                        textColor: .darkGray,
                                                        characterSpacing: 0.5,
                                                        lineHeight: nil)
    }
    
    private func setupAnimation() {
        let begin = CACurrentMediaTime()
        startTime = begin
        endTime = animationDuration + begin
        isAnimating = true
        
        if placeholderState == .normal {
            displayLink = CADisplayLink(target: self,
                                        selector: #selector(placeholderAnimation))
        } else {
            displayLink = CADisplayLink(target: self,
                                        selector: #selector(floatAnimation))
        }
        
        displayLink?.add(to: RunLoop.main, forMode: .common)
    }
    
    @objc private func floatAnimation() {
        animateTo(startStyle: .normal, endStyle: .floating)
    }
    
    @objc private func placeholderAnimation() {
        animateTo(startStyle: .floating, endStyle: .normal)
    }
    
    private func animateTo(startStyle: PlaceholderStyle, endStyle: PlaceholderStyle) {
        guard let endTime = endTime,
            let startTime = startTime else {
                return
        }
        
        let current = CACurrentMediaTime()
        
        guard current < endTime else {
            displayLink?.isPaused = true
            displayLink?.invalidate()
            finishAnimation()
            return
        }
        
        let percentage = CGFloat(current - startTime) / CGFloat(animationDuration)
        updatePlaceholder(startStyle: startStyle, endStyle: endStyle, percentage: percentage)
    }
    
    private func updatePlaceholder(startStyle: PlaceholderStyle, endStyle: PlaceholderStyle, percentage: CGFloat) {
        calculationQueue.async { [weak self] in
            guard let self = self else { return }
            
            let startStringStyle: StringStyle
            let endStringStyle: StringStyle
            
            switch startStyle {
            case .floating:
                startStringStyle = self.floatingPlaceholderStyle()
            case .normal:
                startStringStyle = self.placeholderStyle()
            }
            
            switch endStyle {
            case .floating:
                endStringStyle = self.floatingPlaceholderStyle()
            case .normal:
                endStringStyle = self.placeholderStyle()
            }

            guard let startSpacing = startStringStyle.characterSpacing,
                let endSpacing = endStringStyle.characterSpacing,
                let startFontSize = startStringStyle.fontSize,
                let endFontSize = endStringStyle.fontSize,
                let startColor = startStringStyle.textColor,
                let endColor = endStringStyle.textColor else { return }

            let currentSpacing = Math.calcCurrentValue(startValue: startSpacing, endValue: endSpacing, percentage: percentage)
            let currentSize = Math.calcCurrentValue(startValue: startFontSize, endValue: endFontSize, percentage: percentage)
            let currentColor = UIColor.transition(startColor: startColor, endColor: endColor, percentage: percentage)

            DispatchQueue.main.async {
                let startHeight: CGFloat
                let endHeight: CGFloat
                let startY: CGFloat
                let endY: CGFloat

                if self.placeholderState == .normal {
                    startHeight = self.floatingHeight
                    endHeight = self.bounds.size.height
                    startY = self.floatingY
                    endY = 0
                } else {
                    startHeight = self.bounds.size.height
                    endHeight = self.floatingHeight
                    startY = 0
                    endY = self.floatingY
                }

                let currentHeight = Math.calcCurrentValue(startValue: startHeight, endValue: endHeight, percentage: percentage)
                let currentY = Math.calcCurrentValue(startValue: startY, endValue: endY, percentage: percentage)
                
                //Resize the primary font otherwise use the system
                let font = self.style?.font?.withSize(currentSize) ?? UIFont.systemFont(ofSize: currentSize)

                self.floatingPlaceholder.attributedText = self.interceptedPlaceholder?.styled(font: font,
                                                                                              textColor: currentColor,
                                                                                              lineSpacing: nil,
                                                                                              characterSpacing: currentSpacing)

                self.floatingPlaceholder.frame = CGRect(x: 0, y: currentY, width: self.bounds.size.width, height: currentHeight)
            }
        }
    }
    
    private func finishAnimation() {
        updatePlaceholder()
        layoutPlaceholder()
        isAnimating = false
    }
    
    private func updatePlaceholder() {
        let stringStyle: StringStyle
        
        switch placeholderState {
        case .normal:
            stringStyle = placeholderStyle()
        case .floating:
            stringStyle = floatingPlaceholderStyle()
        }
        
        floatingPlaceholder.attributedText = interceptedPlaceholder?.styled(stringStyle)
    }
    
    private func layoutPlaceholder() {
        floatingPlaceholder.frame = CGRect(x: 0,
                                           y: (placeholderState == .normal) ? 0 : floatingY,
                                           width: bounds.size.width,
                                           height: (placeholderState == .normal) ? bounds.size.height : floatingHeight)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if isAnimating == false {
            layoutPlaceholder()
        }
    }

}

extension FloatingPlaceholderTextField: Stylable {
    func apply(style: Style) {
        self.style = style
    }
}
