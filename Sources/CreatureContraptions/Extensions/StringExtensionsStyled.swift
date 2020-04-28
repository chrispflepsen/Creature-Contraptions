//
//  String+Styled.swift
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

public extension String {
    
    func styled(_ style: StringStyle, alignment: NSTextAlignment = .left, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> NSAttributedString {
        
        let lineSpacing = style.lineSpacing
        let characterSpacing = style.characterSpacing
        let textColor = style.textColor
        let font = style.font
        
        return styled(font: font,
                      textColor: textColor,
                      lineSpacing: lineSpacing,
                      characterSpacing: characterSpacing,
                      alignment: alignment,
                      lineBreakMode: lineBreakMode)
        
    }
    
    func styled(font: UIFont?,
                textColor: UIColor?,
                lineHeight: CGFloat?,
                characterSpacing: CGFloat?,
                alignment: NSTextAlignment = .left,
                lineBreakMode: NSLineBreakMode = .byWordWrapping) -> NSAttributedString {
        var lineSpacing: CGFloat?
        if let pointSize = font?.pointSize,
            let lineHeight = lineHeight {
            lineSpacing = StringStyle.lineSpacing(fromLineHeight: lineHeight, fontSize: pointSize)
        }
        
        return styled(font: font,
                      textColor: textColor,
                      lineSpacing: lineSpacing,
                      lineHeightMultiple: nil,
                      characterSpacing: characterSpacing,
                      alignment: alignment,
                      lineBreakMode: lineBreakMode)
    }
    
    func styled(font: UIFont?, textColor: UIColor?, lineSpacing: CGFloat? = nil,
                lineHeightMultiple: CGFloat? = nil, characterSpacing: CGFloat? = nil,
                alignment: NSTextAlignment = .left, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> NSAttributedString {
        
        let attrStr = NSMutableAttributedString(string: self)
        attrStr.addParagraphSyle(alignment: alignment, lineSpacing: lineSpacing, lineHeightMultiple: lineHeightMultiple, lineBreakMode: lineBreakMode)
        attrStr.addTextColor(textColor)
        attrStr.addCharacterSpacing(characterSpacing)
        attrStr.addFont(font)
        
        return NSAttributedString(attributedString: attrStr)
    }
    
}
