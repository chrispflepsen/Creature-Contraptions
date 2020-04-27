//
//  CreatureContraptions.swift
//  CreatureContraptions
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

class CreatureContraptions {
    
    static func imageFromBundle(named: String) -> UIImage {
        return UIImage(named: named) ?? UIImage()
        
//        let bundle = Bundle(for: CreatureContraptions.self)
//        return UIImage(named: "ImageAssets.bundle/\(named)", in: bundle, compatibleWith: nil) ?? UIImage()
//        return UIImage(named: "ImageAssets.bundle/\(named)", inBundle: bundle, compatibleWithTraitCollection: nil)
        
        
        
//        let defaultImage = UIImage()
//        let image = UIImage(imageLiteralResourceName: named)
//
//        return image
        
//        let podBundle = Bundle(for: CreatureContraptions.self) // or any other class within the pod. technically doesn't have the be the same as the current file, but good practice to
//        
//        
//        if let url = podBundle.url(forResource: "ImageAssets", withExtension: "bundle") {
//            let imageBundle = Bundle(url: url)
//            print("asdf")
//        }
//            
//        
//        guard let url = podBundle.url(forResource: "ImageAssets", withExtension: "bundle"),
//            let imageBundle = Bundle(url: url),
//            
//            let retrievedImage = UIImage(named: named, in: imageBundle, compatibleWith: nil) else {
//                return defaultImage
//        }
//        
//        return retrievedImage
    }
    
}
