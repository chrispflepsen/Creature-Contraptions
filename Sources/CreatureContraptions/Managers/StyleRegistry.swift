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

public protocol ContraptionStyle {
    var primaryColor: UIColor { get }
    var secondaryColor: UIColor? { get }
    var tertiaryColor: UIColor? { get }
    var errorColor: UIColor? { get }
    var font: UIFont? { get }
    var secondaryFont: UIFont? { get }
    var primaryStringStyle: StringStyle? { get }
    var secondaryStringStyle: StringStyle? { get }
}

public struct Style: ContraptionStyle {
    public let primaryColor: UIColor
    public let secondaryColor: UIColor?
    public let tertiaryColor: UIColor?
    public let errorColor: UIColor?
    public let font: UIFont?
    public let secondaryFont: UIFont?
    public let primaryStringStyle: StringStyle?
    public let secondaryStringStyle: StringStyle?
    
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
    func apply(style: ContraptionStyle)
}

public enum StylableType: String, CaseIterable {
    case button = "button"
    case textField = "textField"
    case passwordTextField = "passwordTextField"
    case dateTextField = "dateTextField"
    case circleProgress = "circleProgress"
    case slider = "slider"
}

public class StyleRegistry {
    public static let standard = StyleRegistry()
    
    private var styleDictionary = [String : ContraptionStyle]()
    
    public func register<T: ContraptionStyle>(style: T, forStylable styleable: StylableType) {
        styleDictionary[styleable.rawValue] = style
    }
    
    public func style(forStylable stylable: StylableType) -> ContraptionStyle? {
        return styleDictionary[stylable.rawValue]
    }
}

