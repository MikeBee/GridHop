//
//  Hero.swift
//  GridHop
//
//  Player-controlled hero character
//

import Foundation
import SpriteKit

class Hero: Actor {
    var isDefending: Bool = false
    var gold: Int = 0
    
    init(position: HexCoord) {
        super.init(
            type: .hero,
            position: position,
            hp: 12,
            moveRange: 1,
            attackDamage: 3,
            attackRange: 1,
            pushDistance: 1
        )
        
        // Customize hero sprite appearance
        sprite.color = .systemBlue
        sprite.name = "hero"
        
        // Add a small border to distinguish hero
        let border = SKShapeNode(circleOfRadius: 32)
        border.strokeColor = .white
        border.lineWidth = 3
        border.fillColor = .clear
        border.zPosition = -1
        sprite.addChild(border)
    }
    
    func defend() {
        isDefending = true
        
        // Visual feedback for defense
        let pulseUp = SKAction.scale(to: 1.1, duration: 0.2)
        let pulseDown = SKAction.scale(to: 1.0, duration: 0.2)
        sprite.run(SKAction.sequence([pulseUp, pulseDown]))
        
        // Add temporary shield effect
        addShield(3)
    }
    
    func endTurn() {
        // Reset defense state
        isDefending = false
    }
    
    override func takeDamage(_ damage: Int) {
        var modifiedDamage = damage
        
        // Defending reduces damage by 50%
        if isDefending {
            modifiedDamage = damage / 2
        }
        
        super.takeDamage(modifiedDamage)
    }
    
    func addGold(_ amount: Int) {
        gold += amount
        print("Gold collected: \(amount), Total: \(gold)")
    }
}
