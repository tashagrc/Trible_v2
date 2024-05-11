//
//  CGFloat+Ext.swift
//  TribeLeap
//
//  Created by Natasha Radika on 26/04/24.
//

// HAPUS
import CoreGraphics

public let phi = CGFloat.pi

extension CGFloat {
    func radiansToDegrees() -> CGFloat {
        return self * 180.0 / phi
    }
    func degreesToRadians() -> CGFloat {
        return self * phi / 180.0
    }
    
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random())/Float(0xFFFFFFFF)) // return 0, 1
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max-min) + min
    }
}
