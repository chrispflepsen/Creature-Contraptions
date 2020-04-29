//
//  Button.swift
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

public enum TypeOfButton: String {
    case bordered
    case clear
    case normal
}

public class Button: UIButton {
    
    private let defaultStyle = Style(primaryColor: .systemBlue,
                                     secondaryColor: nil,
                                     tertiaryColor: nil,
                                     errorColor: nil,
                                     font: nil,
                                     secondaryFont: nil,
                                     primaryStringStyle: nil,
                                     secondaryStringStyle: nil)
 
    public var typeOfButton: TypeOfButton = .normal {
        didSet {
            updateTheme()
        }
    }
    
    private(set) var style: Style? {
        didSet {
            updateTheme()
        }
    }

    @IBInspectable private var type: String {
        set {
            typeOfButton = TypeOfButton(rawValue: newValue) ?? .normal
            updateTheme()
        }
        get {
            return typeOfButton.rawValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCommon()
    }
    
    private func initCommon() {
        if let style = StyleRegistry.standard.style(forStylable: .button) {
            apply(style: style)
        }
        
        updateTheme()
        clipsToBounds = true
    }
    
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        if let stringStyle = style?.primaryStringStyle {
            super.setAttributedTitle(title?.styled(stringStyle), for: state)
        } else {
            super.setTitle(title, for: state)
        }
    }
    
    // MARK: - Public Functions
    
    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        setBackgroundImage(color?.toImage(), for: state)
    }
    
    ///Convenience call for setTitle(title, for: .normal)
    func setTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
    
    // MARK: - Private
    
    private func updateTheme() {
        let backgroundColor: UIColor
        var borderColor: UIColor?
        var highlightColor: UIColor?
        let titleColor: UIColor
        var highlightedTitleColor: UIColor?
        
        let primaryColor = style?.primaryColor ?? defaultStyle.primaryColor
        
        switch typeOfButton {
        case .normal:
            backgroundColor = primaryColor
            highlightColor = primaryColor.darker()
            titleColor = .white
        case .clear:
            backgroundColor = .clear
            titleColor = primaryColor
        case .bordered:
            backgroundColor = .white
            borderColor = primaryColor
            highlightColor = primaryColor
            titleColor = primaryColor
            highlightedTitleColor = .white
        }
        
        if let borderColor = borderColor {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = 2.0
        }
        
        setBackgroundColor(backgroundColor, for: .normal)
        setBackgroundColor(highlightColor, for: .highlighted)
        
        setTitleColor(titleColor, for: .normal)
        setTitleColor(highlightedTitleColor, for: .highlighted)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let radius = ceil(bounds.height / 2.0)
        layer.cornerRadius = radius
    }
}

extension Button: Stylable {
    func apply(style: ContraptionStyle) {
        guard let style = style as? Style else { return }
        self.style = style
    }
}
