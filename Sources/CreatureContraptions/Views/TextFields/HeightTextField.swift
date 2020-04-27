//
//  HeightTextField.swift
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
import RxCocoa

public class HeightTextField: TextField {
    
    fileprivate let heightPickerView = UIPickerView()
    private let toolbar = UIToolbar()
    private let doneButton = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
    private var doneButtonAction: (() -> Void)?
    
    //reversed so that the values are ascending
    fileprivate let feet: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9].reversed()
    fileprivate let inches: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].reversed()
    
    override func setupViews() {
        super.setupViews()
        
        self.inputView = heightPickerView
        self.inputAccessoryView = toolbar
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton], animated: false)
        toolbar.barTintColor = style?.primaryColor
        toolbar.isTranslucent = false
        toolbar.tintColor = .white
        toolbar.sizeToFit()
        
        heightPickerView.dataSource = self
        heightPickerView.delegate = self
        heightPickerView.selectRow(4, inComponent: 0, animated: false)
        heightPickerView.selectRow(6, inComponent: 2, animated: false)
        
        tintColor = .clear
        
        doneButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.doneButtonAction?()
        })
        .disposed(by: bag)
    }
    
    public func setToolbarButtonTitle(_ title: String) {
        doneButton.title = title
    }
    
    public func setToolbarButtonAction(_ action: @escaping () -> Void) {
        doneButtonAction = action
    }
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

extension HeightTextField: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return feet.count
        } else if component == 2 {
            return inches.count
        }
        return 1
    }
}

extension HeightTextField: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(feet[row])"
        case 1:
            return NSLocalizedString("ft", comment: "Feet Abbreviation")
        case 2:
            return "\(inches[row])"
        case 3:
            return NSLocalizedString("in", comment: "Inches Abbreviation")
        default:
            return ""
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sendActions(for: .valueChanged)
    }
}

extension Reactive where Base: HeightTextField {
    
    public var feet: ControlProperty<Int?> {
        return base.rx.controlProperty(editingEvents: .valueChanged,
                                       getter: { (textField: HeightTextField) -> Int? in
                                            let selectedRow = textField.heightPickerView.selectedRow(inComponent: 0)
                                            return textField.feet[selectedRow]
                                        }, setter: { (_, _) in
                                            //do nothing, no setter provided
                                        })
    }
    
    public var inches: ControlProperty<Int?> {
        return base.rx.controlProperty(editingEvents: .valueChanged,
                                       getter: { (textField: HeightTextField) -> Int? in
                                            let selectedRow = textField.heightPickerView.selectedRow(inComponent: 2)
                                            return textField.inches[selectedRow]
                                        }, setter: { (_, _) in
                                            //do nothing, no setter provided
                                        })
    }
    
}
