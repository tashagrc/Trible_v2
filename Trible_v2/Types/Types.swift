//
//  Types.swift
//  TribeLeap
//
//  Created by Natasha Radika on 28/04/24.
//

import Foundation


// ini bit digunakan utk detect collisions and contact antar object
// pakai bit agar lebih efisien
struct PhysicsCategory {
    static let Player: UInt32 = 0b1 // 2^1
    static let Block: UInt32 = 0b10 // 2^2
    static let Obstacle: UInt32 = 0b100 // 2^3
    static let Ground: UInt32 = 0b1000
    static let Coin: UInt32 = 0b10000
}
