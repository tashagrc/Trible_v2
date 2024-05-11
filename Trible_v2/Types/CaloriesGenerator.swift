//
//  ScoreGenerator.swift
//  TribeLeap
//
//  Created by Natasha Radika on 28/04/24.
//

import Foundation

class CaloriesGenerator {
    static let sharedInstance = CaloriesGenerator()
    private init() {
        
    }
    
    static let keyHighscore = "keyHighscore"
    static let keyScore = "keyScore"
    
    func setScore(_ score: Double) {
        UserDefaults.standard.set(score, forKey: CaloriesGenerator.keyScore)
    }
    
    func getScore() -> Double {
        return Double(UserDefaults.standard.double(forKey: CaloriesGenerator.keyScore))
    }
    
    func setHighscore(_ score: Double) {
        UserDefaults.standard.set(score, forKey: CaloriesGenerator.keyHighscore)
    }
    
    func getHighscore() -> Double {
        return Double(UserDefaults.standard.double(forKey: CaloriesGenerator.keyHighscore))
    }
}
