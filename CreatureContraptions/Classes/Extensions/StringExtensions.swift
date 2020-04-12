//
//  StringExtensions.swift
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

extension String {
    
    public func isEmailAddress() -> Bool {
        return range(of: Constants.emailRegex, options: .regularExpression) != nil
    }
    
    // MARK: - Phone Number
    
    public func phoneNumberFormat() -> String {
        //Remove any existing formatting
        var decimalString = removePhoneNumberFormat() as NSString
        let length = decimalString.length
        
        if length == 0 {
            return ""
        }
        
        //Remove leading one when displaying the phone number
        if decimalString.substring(with: NSRange(location: 0, length: 1)) == "1" {
            decimalString = decimalString.substring(with: NSRange(location: 1, length: decimalString.length - 1)) as NSString
        }
        
        var index: Int = 0
        let formattedString = NSMutableString()
        
        if length <= 3 {
            formattedString.appendFormat("(%@", decimalString)
            index = decimalString.length
        }
        
        if (length - index) > 3 {
            let areaCode = decimalString.substring(with: NSRange(location: index, length: 3))
            formattedString.appendFormat("(%@) ", areaCode)
            index += 3
        }
        
        if length - index > 3 {
            let prefix = decimalString.substring(with: NSRange(location: index, length: 3))
            formattedString.appendFormat("%@-", prefix)
            index += 3
        }
        
        var remainder = decimalString.substring(from: index)
        if remainder.count > 4 {
            //truncate additional
            let trimming = remainder as NSString
            remainder = trimming.substring(with: NSRange(location: 0, length: 4))
        }
        formattedString.append(remainder)
        return formattedString as String
    }
    
    public func removeSpecialCharacters() -> String {
        let components = self.components(separatedBy: NSCharacterSet.alphanumerics.inverted)
        let baseString = components.joined(separator: "")
        return baseString
    }
    
    public func removePhoneNumberFormat() -> String {
        let components = self.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        let baseString = components.joined(separator: "")
        return baseString
    }
    
    public func usPhoneNumberFormat() -> String {
        return "+1" + self.removePhoneNumberFormat()
    }
    
    public func isValidPhoneNumber() -> Bool {
        return self.removePhoneNumberFormat().count == Constants.phoneNumberLength
    }
    
    // MARK: - Substrings
    
    public func substring(toIndex: Int) -> String {
        guard toIndex < count else {
            return self
        }
        
        let endIndex = index(startIndex, offsetBy: toIndex)
        let substring = self[..<endIndex]
        return String(substring)
    }

    public func substring(fromIndex: Int) -> String {
        guard fromIndex < count else {
            return ""
        }
        
        let start = index(startIndex, offsetBy: fromIndex)
        let substring = self[start...]
        return String(substring)
    }
    
    public func substring(fromIndex: Int, toIndex: Int) -> String {
        guard toIndex > fromIndex else {
            return ""
        }
        
        return substring(fromIndex: fromIndex).substring(toIndex: toIndex - fromIndex)
    }
    
    public func ranges(of string: String) -> [NSRange] {
        var nsString: NSString
        
        var result: [NSRange] = []
        var startIndex = 0
        let endIndex = count
        while startIndex < endIndex {
            let subString = substring(fromIndex: startIndex)
            nsString = NSString(string: String(subString))
            let range = nsString.range(of: string)
            
            guard range.length > 0 else {
                break
            }
        
            //Account for the part of the string we have already truncated
            let offsetRange = NSRange(location: startIndex + range.location, length: range.length)
            result.append(offsetRange)
            startIndex += range.location + range.length
        }
        return result
    }
    
    public func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        return boundingBox.width
    }
    
    public var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}
