//
//  Actor.swift
//  GridHop
//
//  Base class for all grid-based actors (Hero, Enemies)
//

import Foundation
import SpriteKit

enum ActorType {
    case hero
    case enemy
}

class Actor {
    var actorType: ActorType
    var sprite: SKSpriteNode
    var position: HexCoord
    var hp: Int
    var maxHp: Int
    var moveRange: Int
    var attackDamage: Int
    var attackRange: Int
    var pushDistance: Int
    var isAlive: Bool { return hp > 0 }
    var isDead: Bool { return hp <= 0 }
    
    // Status effects
    var isStunned: Bool = false
    var poisonStacks: Int = 0
    var shieldAmount: Int = 0
    
    init(type: ActorType, position: HexCoord, hp: Int, moveRange: Int, attackDamage: Int, attackRange: Int = 1, pushDistance: Int = 1) {
        self.actorType = type
        self.position = position
        self.hp = hp
        self.maxHp = hp
        self.moveRange = moveRange
        self.attackDamage = attackDamage
        self.attackRange = attackRange
        self.pushDistance = pushDistance
        
        // Create sprite
        self.sprite = SKSpriteNode(color: type == .hero ? .blue : .red, size: CGSize(width: 60, height: 60))
        self.sprite.zPosition = 10
        
        // Add HP label
        let hpLabel = SKLabelNode(text: "\(hp)")
        hpLabel.fontSize = 18
        hpLabel.fontName = "AvenirNext-Bold"
        hpLabel.fontColor = .white
        hpLabel.verticalAlignmentMode = .center
        hpLabel.name = "hpLabel"
        self.sprite.addChild(hpLabel)
    }
    
    func updateSpritePosition(hexSize: CGFloat) {
        let pixelPos = position.toPixel(hexSize: hexSize)
        sprite.position = pixelPos
    }
    
    func takeDamage(_ damage: Int) {
        // Apply shield first
        var actualDamage = damage
        if shieldAmount > 0 {
            let shieldAbsorbed = min(shieldAmount, damage)
            shieldAmount -= shieldAbsorbed
            actualDamage -= shieldAbsorbed
        }
        
        hp = max(0, hp - actualDamage)
        updateHPLabel()
        
        // Visual feedback
        let flashRed = SKAction.sequence([
            SKAction.colorize(with: .red, colorBlendFactor: 0.5, duration: 0.1),
            SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.1)
        ])
        sprite.run(flashRed)
    }
    
    func heal(_ amount: Int) {
        hp = min(maxHp, hp + amount)
        updateHPLabel()
        
        // Visual feedback
        let flashGreen = SKAction.sequence([
            SKAction.colorize(with: .green, colorBlendFactor: 0.5, duration: 0.1),
            SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.1)
        ])
        sprite.run(flashGreen)
    }
    
    func addShield(_ amount: Int) {
        shieldAmount += amount
        updateHPLabel()
    }
    
    func updateHPLabel() {
        if let hpLabel = sprite.childNode(withName: "hpLabel") as? SKLabelNode {
            var displayText = "\(hp)"
            if shieldAmount > 0 {
                displayText += " +\(shieldAmount)"
            }
            hpLabel.text = displayText
        }
    }
    
    func applyPoison(_ stacks: Int) {
        poisonStacks += stacks
    }
    
    func processPoisonDamage() {
        if poisonStacks > 0 {
            takeDamage(poisonStacks)
            poisonStacks = max(0, poisonStacks - 1)
        }
    }
    
    func stun() {
        isStunned = true
    }
    
    func clearStun() {
        isStunned = false
    }
}
