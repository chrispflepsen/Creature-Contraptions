//
//  NSMutableAttributedString+Style.swift
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

public extension NSMutableAttributedString {
    
    func addParagraphSyle(alignment: NSTextAlignment?, lineSpacing: CGFloat? = nil, lineHeightMultiple: CGFloat? = nil, lineBreakMode: NSLineBreakMode?) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        if let alignment = alignment {
            paragraphStyle.alignment = alignment
        }
        
        if let spacing = lineSpacing {
            paragraphStyle.lineSpacing = spacing
        }
        
        if let lineHeightMultiple = lineHeightMultiple {
            paragraphStyle.lineHeightMultiple = lineHeightMultiple
        }

        if let breakMode = lineBreakMode {
            paragraphStyle.lineBreakMode = breakMode
        }
        
        addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: length))
    }
    
    func addFont(_ font: UIFont?, range: NSRange? = nil) {
        guard let font = font else { return }
        let range = range ?? NSRange(location: 0, length: length)
        addAttribute(.font, value: font, range: range)
    }
    
    func addTextColor(_ color: UIColor?, range: NSRange? = nil) {
        guard let color = color else { return }
        let range = range ?? NSRange(location: 0, length: length)
        addAttribute(.foregroundColor, value: color, range: range)
    }
    
    func addCharacterSpacing(_ spacing: CGFloat?, range: NSRange? = nil) {
        guard let spacing = spacing else { return }
        let range = range ?? NSRange(location: 0, length: length)
        addAttribute(.kern, value: spacing, range: range)
    }
    
}
