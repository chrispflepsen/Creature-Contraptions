//
//  PasswordTextField.swift
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

public class PasswordTextField: TextField {
    
    private let eyeOpenImage = UIImage(systemName: "eye")
    private let eyeClosedImage = UIImage(systemName: "eye.slash")
    
    let showButton = UIButton()
    
    public override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }
    
    public override func becomeFirstResponder() -> Bool {

        let success = super.becomeFirstResponder()
        if isSecureTextEntry,
            let text = self.text,
            !text.isEmpty {
            self.text?.removeAll()
            insertText("\(text)+")
            deleteBackward()
        }
        return success
    }
    
    override func setupViews() {
        super.setupViews()
        tintColor = .black
        
        isSecureTextEntry = true
        
        addShowButton()
    }
    
    private func addShowButton() {
        showButton.setImage(eyeClosedImage, for: .normal)
        showButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        rightView = showButton
        rightViewMode = .always
    }
    
    override func bindUI() {
        super.bindUI()
        
        showButton.rx.tap.bind { [weak self] in
            self?.isSecureTextEntry.toggle()
            self?.updateIcon()
        }
        .disposed(by: bag)
    }
    
    @objc private func eyeTapped() {
        isSecureTextEntry.toggle()
        updateIcon()
    }
    
    private func updateIcon() {
        let image = isSecureTextEntry ? eyeClosedImage : eyeOpenImage
        showButton.setImage(image, for: .normal)
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 47))
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 47))
    }
    
    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 10
        return rect
    }
}
