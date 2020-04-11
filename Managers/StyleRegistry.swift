//
//  StyleRegistry.swift
//  Pods
//
//  Created by Chris Pflepsen on 4/7/20.
//

import Foundation

protocol Style {
    let primaryColor: UIColor?
}

class StyleRegistry {
    static let standard = StyleRegistry()
    
    func register<T>(style: Style, forClass class: T) {
        
    }
    
    func style<T>(forClass class: T) -> Style? {
        return nil
    }
}
