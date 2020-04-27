//
//  TextField.swift
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
import RxSwift

public class TextField: FloatingPlaceholderTextField {
    
    private let dividerView = UIView()
    
    private var maxLengthValue = 0
    
    @IBInspectable var maxLength: Int {
        get {
            return maxLengthValue
        }
        set {
            maxLengthValue = newValue
        }
    }
    
    private var selectedBottomLineHeightValue: Double = 2.0
    
    @IBInspectable var selectedBottomLineHeight: Double {
        get {
            return selectedBottomLineHeightValue
        }
        set {
            selectedBottomLineHeightValue = newValue
        }
    }
    
    private var bottomLineHeightValue: Double = 1.0
    
    @IBInspectable var bottomLineHeight: Double {
        get {
            return bottomLineHeightValue
        }
        set {
            bottomLineHeightValue = newValue
        }
    }
    
    private var shouldTrimWhitespaceAndNewlinesValue = false
    private var endEditingDisposable: Disposable?
    
    @IBInspectable var shouldTrimWhitespaceAndNewlines: Bool {
        get {
            return shouldTrimWhitespaceAndNewlinesValue
        }
        set {
            shouldTrimWhitespaceAndNewlinesValue = newValue
            endEditingDisposable?.dispose()
            
            if newValue {
                endEditingDisposable = rx
                    .controlEvent(.editingDidEnd)
                    .asObservable()
                    .subscribe(onNext: { [weak self] (_) in
                        self?.trimText()
                    })
            }
        }
    }
    
    private var hasErrorValue = false
    var hasError: Bool {
        get { return hasErrorValue }
        set {
            hasErrorValue = newValue
            if hasErrorValue {
                let errorColor = self.style?.errorColor ?? UIColor.systemRed
                dividerView.backgroundColor = errorColor
                textColor = errorColor
            } else {
                dividerView.backgroundColor = .black
                textColor = .black
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    deinit {
        endEditingDisposable?.dispose()
    }
    
    func setupViews() {
        bindUI()
        setupDividerView()
    }
    
    func bindUI() {
        rx.controlEvent([.allEditingEvents])
            .asObservable()
            .subscribe(onNext: { [weak self] (_) in
                self?.checkMaxLength()
            })
            .disposed(by: bag)
    }
    
    public override func becomeFirstResponder() -> Bool {
        let isFirstResponder = super.becomeFirstResponder()
        if isFirstResponder {
            let dividerColor = self.style?.primaryColor ?? UIColor.black
            dividerView.backgroundColor = dividerColor
            updateDividerHeight(selectedBottomLineHeightValue)
        } else {
            dividerView.backgroundColor = .black
            updateDividerHeight(bottomLineHeightValue)
        }
        return isFirstResponder
    }
    
    public override func resignFirstResponder() -> Bool {
        let isResigned = super.resignFirstResponder()
        if isResigned {
            dividerView.backgroundColor = .black
            updateDividerHeight(bottomLineHeightValue)
        } else {
            let dividerColor = self.style?.primaryColor ?? UIColor.black
            dividerView.backgroundColor = dividerColor
            updateDividerHeight(selectedBottomLineHeightValue)
        }
        return isResigned
    }
}

extension TextField {
    
    private func checkMaxLength() {
        guard maxLengthValue > 0,
            let text = self.text,
            text.count > maxLengthValue else { return }

            let substring = text.substring(toIndex: maxLengthValue)
            self.text = substring
    }
    
    private func trimText() {
         self.text = self.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func setupDividerView() {
        dividerView.backgroundColor = .black
        addSubview(dividerView)
        
        updateDividerHeight(bottomLineHeightValue)
    }
    
    private func updateDividerHeight(_ height: Double) {
        dividerView.snp.remakeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(height)
        }
    }
}
