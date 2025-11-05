//
//  Enemy.swift
//  GridHop
//
//  Enemy characters with simple AI behavior
//

import Foundation
import SpriteKit

enum EnemyType {
    case grunt
    case brute
}

class Enemy: Actor {
    var enemyType: EnemyType
    var aiState: AIState = .idle
    var targetPosition: HexCoord?
    
    enum AIState {
        case idle
        case moving
        case attacking
    }
    
    init(type: EnemyType, position: HexCoord) {
        self.enemyType = type
        
        switch type {
        case .grunt:
            super.init(
                type: .enemy,
                position: position,
                hp: 5,
                moveRange: 1,
                attackDamage: 2,
                attackRange: 1,
                pushDistance: 0
            )
            sprite.color = .systemRed
            
        case .brute:
            super.init(
                type: .enemy,
                position: position,
                hp: 14,
                moveRange: 1,
                attackDamage: 4,
                attackRange: 1,
                pushDistance: 1
            )
            sprite.color = .systemOrange
            sprite.size = CGSize(width: 70, height: 70)
        }
        
        sprite.name = "enemy"
        
        // Add enemy indicator
        let indicator = SKShapeNode(circleOfRadius: 5)
        indicator.fillColor = .red
        indicator.strokeColor = .clear
        indicator.position = CGPoint(x: 0, y: 35)
        sprite.addChild(indicator)
    }
    
    // Simple AI: move toward hero and attack if in range
    func decideAction(hero: Hero, gridManager: GridManager) -> EnemyAction {
        if isStunned {
            return .wait
        }
        
        let distanceToHero = position.distance(to: hero.position)
        
        // If in attack range, attack
        if distanceToHero <= attackRange {
            return .attack(target: hero.position)
        }
        
        // Otherwise, try to move closer
        if let path = gridManager.findPath(from: position, to: hero.position) {
            // Path includes current position, so get next step
            if path.count > 1 {
                let nextStep = path[1]
                // Check if we can move there (not blocked by another enemy)
                if !gridManager.blockedTiles.contains(nextStep) {
                    return .move(to: nextStep)
                }
            }
        }
        
        return .wait
    }
    
    func showIntent(action: EnemyAction, gridManager: GridManager) {
        // Remove old intent indicator
        sprite.childNode(withName: "intentIndicator")?.removeFromParent()
        
        switch action {
        case .attack:
            let indicator = SKLabelNode(text: "⚔️")
            indicator.fontSize = 24
            indicator.position = CGPoint(x: 0, y: 40)
            indicator.name = "intentIndicator"
            indicator.zPosition = 5
            sprite.addChild(indicator)
            
        case .move(let to):
            // Draw arrow showing movement direction
            let targetPos = to.toPixel(hexSize: gridManager.hexSize)
            let currentPos = position.toPixel(hexSize: gridManager.hexSize)
            let dx = targetPos.x - currentPos.x
            let dy = targetPos.y - currentPos.y
            
            let arrow = SKShapeNode()
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: dx * 0.3, y: dy * 0.3))
            arrow.path = path
            arrow.strokeColor = .yellow
            arrow.lineWidth = 3
            arrow.name = "intentIndicator"
            arrow.alpha = 0.7
            sprite.addChild(arrow)
            
        case .wait:
            break
        }
    }
    
    func clearIntent() {
        sprite.childNode(withName: "intentIndicator")?.removeFromParent()
    }
}

enum EnemyAction {
    case move(to: HexCoord)
    case attack(target: HexCoord)
    case wait
}
