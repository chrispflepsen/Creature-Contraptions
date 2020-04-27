//
//  StyleRegistry.swift
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

public struct Style {
    let primaryColor: UIColor
    let secondaryColor: UIColor?
    let tertiaryColor: UIColor?
    let errorColor: UIColor?
    let font: UIFont?
    let secondaryFont: UIFont?
    let primaryStringStyle: StringStyle?
    let secondaryStringStyle: StringStyle?
    
    public init(primaryColor: UIColor, secondaryColor: UIColor?, tertiaryColor: UIColor?, errorColor: UIColor?, font: UIFont?, secondaryFont: UIFont?, primaryStringStyle: StringStyle?, secondaryStringStyle: StringStyle?) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.tertiaryColor = tertiaryColor
        self.errorColor = errorColor
        self.font = font
        self.secondaryFont = secondaryFont
        self.primaryStringStyle = primaryStringStyle
        self.secondaryStringStyle = secondaryStringStyle
    }
}

protocol Stylable {
    func apply(style: Style)
}

public enum StylableType: String, CaseIterable {
    case button = "button"
    case textField = "textField"
    case circleProgress = "circleProgress"
    case slider = "slider"
}

public class StyleRegistry {
    public static let standard = StyleRegistry()
    
    private var styleDictionary = [String : Style]()
    
    public func register(style: Style, forStylable styleable: StylableType) {
        styleDictionary[styleable.rawValue] = style
    }
    
    public func style(forStylable stylable: StylableType) -> Style? {
        return styleDictionary[stylable.rawValue]
    }
}

