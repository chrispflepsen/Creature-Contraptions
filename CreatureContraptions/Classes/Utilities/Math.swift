//
//  Math.swift
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
import CoreGraphics

enum Math {

    static func calcCurrentValue(startValue: CGFloat, endValue: CGFloat, percentage: CGFloat) -> CGFloat {
        var percentage = percentage
        if percentage < 0 { percentage = 0.0 }
        if percentage > 1 { percentage = 1.0 }
        
        return startValue - ((startValue - endValue) * percentage)
    }
    
    static func polarToRectangular(radians: Double, magnitude: Double) -> CGPoint {
        let reducedAngle = radians.truncatingRemainder(dividingBy: 2.0 * Double.pi)

        let y = magnitude * sin(reducedAngle) //swiftlint:disable:this identifier_name
        let x = magnitude * cos(reducedAngle) //swiftlint:disable:this identifier_name
        
        return CGPoint(x: x, y: y)
    }
    
}
