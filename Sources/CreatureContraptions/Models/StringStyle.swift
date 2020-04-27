//
//  StringStyle.swift
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

//Line height - fontSize / 2.0 = line spacing

public struct StringStyle {
    let font: UIFont?
    let textColor: UIColor?
    let characterSpacing: CGFloat?
    let lineHeight: CGFloat?
    
    public init(font: UIFont?, textColor: UIColor?, characterSpacing: CGFloat?, lineHeight: CGFloat?) {
        self.font = font
        self.textColor = textColor
        self.characterSpacing = characterSpacing
        self.lineHeight = lineHeight
    }
}

extension StringStyle {
    var fontSize: CGFloat? {
        return font?.pointSize
    }
    
    var lineSpacing: CGFloat? {
        guard let lineHeight = lineHeight,
        let fontSize = fontSize else {
            return nil
        }
        
        return StringStyle.lineSpacing(fromLineHeight: lineHeight, fontSize: fontSize)
    }
    
    static func lineSpacing(fromLineHeight lineHeight: CGFloat, fontSize: CGFloat) -> CGFloat {
        return (lineHeight - fontSize) / 2.0
    }
}
