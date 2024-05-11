//
//  SKAction+Ext.swift
//  TribeLeap
//
//  Created by Natasha Radika on 28/04/24.
//

import SpriteKit


// global variable
private let keyEffect = "keyEffect"
var effectEnabled: Bool = {
    return  !UserDefaults.standard.bool(forKey: keyEffect)
}() {
    didSet {
        let value = !effectEnabled
        UserDefaults.standard.set(value,forKey: keyEffect)
        
        if value {
            SKAction.stop()
        }
    }
}

extension SKAction {
    class func playSoundFileNamed(_ fileNamed: String) -> SKAction {
        if !effectEnabled {
            return SKAction()
        }
        
        return SKAction.playSoundFileNamed(fileNamed, waitForCompletion: false)
    }
}
