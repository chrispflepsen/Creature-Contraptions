//
//  CircleProgressView.swift
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


public class CircleProgressView: UIView {
    
    var circleHeight: CGFloat = 30.0
    
    private(set) var currentPage: Int = 1
    private var totalPagesValue = 5
    
    private let stackView = UIStackView()
    
    /// The color of the circles after the progress is equal to it
    private var progressColor: UIColor = .systemBlue // .primaryColor
    
    /// The uncompleted circle color
    private var circleColor: UIColor = .systemGray
    
    private var font: UIFont = UIFont.systemFont(ofSize: 14.0)
    
    
    
    @IBInspectable var totalPages: Int {
        get {
            return totalPagesValue
        }
        set {
            totalPagesValue = newValue
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
    
    public func gotoNextPage() {
        self.currentPage += 1
        self.build()
    }
    
    private func initCommon() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        build()
    }
    
    private func build() {
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        var dividers = [UIView]()
        
        for index in 1...totalPagesValue {
            let text = index < currentPage ? "" : "\(index)"
            let color: UIColor = index > currentPage ? circleColor : progressColor
            let circle = label(withString: text, backgroundColor: color)
            stackView.addArrangedSubview(circle)
            
            if index < totalPagesValue {
                let divider = dividerView()
                stackView.addArrangedSubview(divider)
                if let firstDivider = dividers.first {
                    divider.snp.makeConstraints { (make) in
                        make.height.equalTo(1)
                        make.width.equalTo(firstDivider.snp.width)
                    }
                } else {
                    divider.snp.makeConstraints { (make) in
                        make.height.equalTo(1)
                    }
                }
                dividers.append(divider)
            }
        }
    }
    
    private func label(withString text: String, backgroundColor: UIColor) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = .white
        label.backgroundColor = backgroundColor
        label.text = text
        label.textAlignment = .center
        label.clipsToBounds = true
        
        label.snp.makeConstraints { (make) in
            make.height.width.equalTo(circleHeight)
        }
        label.layer.cornerRadius = circleHeight / 2.0
        
        return label
    }
    
    private func dividerView() -> UIView {
        let divider = UIView()
        divider.backgroundColor = .darkGray
        return divider
    }
    
}
