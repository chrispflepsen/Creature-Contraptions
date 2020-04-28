//
//  DateTextField.swift
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

public struct DateTextFieldStyle: ContraptionStyle {
    
    public let primaryColor: UIColor
    public let secondaryColor: UIColor?
    public let tertiaryColor: UIColor?
    public let errorColor: UIColor?
    public let font: UIFont?
    public let secondaryFont: UIFont?
    public let primaryStringStyle: StringStyle?
    public let secondaryStringStyle: StringStyle?
    public let calendarImage: UIImage?
    
    public init(baseStyle: ContraptionStyle, calendarImage: UIImage?) {
        self.primaryColor = baseStyle.primaryColor
        self.secondaryColor = baseStyle.secondaryColor
        self.tertiaryColor = baseStyle.tertiaryColor
        self.errorColor = baseStyle.errorColor
        self.font = baseStyle.font
        self.secondaryFont = baseStyle.secondaryFont
        self.primaryStringStyle = baseStyle.primaryStringStyle
        self.secondaryStringStyle = baseStyle.secondaryStringStyle
        self.calendarImage = calendarImage
    }
}

public class DateTextField: TextField {

    //Bind to me :)
    public let datePicker = UIDatePicker()

    private let calendarImageView = UIImageView(image: UIImage())
    private let toolbar = UIToolbar()
    private let doneButton = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
    private var doneButtonAction: (() -> Void)?
    
    var dateTextFieldStyle: DateTextFieldStyle? {
        guard let style = super.style as? DateTextFieldStyle else { return nil }
        return style
    }
    
    public override func setupViews() {
        super.setupViews()
        
        datePicker.datePickerMode = .date
        datePicker.setDate(Date(timeIntervalSinceReferenceDate: 0), animated: false)
        datePicker.maximumDate = Date()
        
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton], animated: false)
        toolbar.barTintColor = style?.primaryColor
        toolbar.isTranslucent = false
        toolbar.tintColor = .white
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
        self.inputView = datePicker

        calendarImageView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        rightView = calendarImageView
        rightViewMode = .always
        calendarImageView.tintColor = .black
        calendarImageView.image = dateTextFieldStyle?.calendarImage
        tintColor = .clear
        
        doneButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.doneButtonAction?()
        })
        .disposed(by: bag)
    }
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    public override func bindUI() {
        super.bindUI()
    }
    
    public func setToolbarButtonTitle(_ title: String) {
        doneButton.title = title
    }
    
    public func setToolbarButtonAction(_ action: @escaping () -> Void) {
        doneButtonAction = action
    }
}
