//
//  CombatManager.swift
//  GridHop
//
//  Manages turn order, action resolution, and combat flow
//

import Foundation
import SpriteKit

enum GamePhase {
    case playerTurn
    case enemyTurn
    case gameOver
    case victory
}

class CombatManager {
    weak var scene: GameScene?
    var gridManager: GridManager
    var hero: Hero
    var enemies: [Enemy] = []
    var currentPhase: GamePhase = .playerTurn
    var turnCount: Int = 0
    
    init(scene: GameScene, gridManager: GridManager, hero: Hero) {
        self.scene = scene
        self.gridManager = gridManager
        self.hero = hero
    }
    
    func startPlayerTurn() {
        currentPhase = .playerTurn
        turnCount += 1
        
        // Clear stun from hero
        hero.clearStun()
        
        // Process poison
        hero.processPoisonDamage()
        
        // Show reachable tiles
        scene?.showReachableTiles(from: hero.position, range: hero.moveRange)
        
        print("Turn \(turnCount) - Player Phase")
    }
    
    func endPlayerTurn() {
        hero.endTurn()
        scene?.clearHighlights()
        startEnemyTurn()
    }
    
    func startEnemyTurn() {
        currentPhase = .enemyTurn
        print("Enemy Phase")
        
        // Show enemy intents first
        for enemy in enemies where enemy.isAlive {
            let action = enemy.decideAction(hero: hero, gridManager: gridManager)
            enemy.showIntent(action: action, gridManager: gridManager)
        }
        
        // Wait a moment for player to see intents
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.executeEnemyActions()
        }
    }
    
    private func executeEnemyActions() {
        var delay: TimeInterval = 0.0
        
        for enemy in enemies where enemy.isAlive {
            enemy.clearIntent()
            
            if enemy.isStunned {
                enemy.clearStun()
                continue
            }
            
            let action = enemy.decideAction(hero: hero, gridManager: gridManager)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.resolveEnemyAction(enemy: enemy, action: action)
            }
            
            delay += 0.4
        }
        
        // After all enemy actions, check game state and start next turn
        DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.5) { [weak self] in
            self?.endEnemyTurn()
        }
    }
    
    private func resolveEnemyAction(enemy: Enemy, action: EnemyAction) {
        switch action {
        case .move(let to):
            moveActor(enemy, to: to)
            
        case .attack(let target):
            if target == hero.position {
                performAttack(attacker: enemy, defender: hero)
            }
            
        case .wait:
            break
        }
        
        // Process poison on enemy
        enemy.processPoisonDamage()
        
        // Check if enemy died
        if enemy.isDead {
            handleActorDeath(enemy)
        }
    }
    
    private func endEnemyTurn() {
        // Check game state
        if hero.isDead {
            currentPhase = .gameOver
            scene?.showGameOver()
            return
        }
        
        if enemies.allSatisfy({ $0.isDead }) {
            currentPhase = .victory
            scene?.showVictory()
            return
        }
        
        // Start next player turn
        startPlayerTurn()
    }
    
    func moveActor(_ actor: Actor, to destination: HexCoord) {
        guard gridManager.isValidTile(destination) else { return }
        
        // Unblock old position
        gridManager.blockedTiles.remove(actor.position)
        
        // Update position
        actor.position = destination
        
        // Block new position
        gridManager.blockedTiles.insert(destination)
        
        // Animate movement
        let targetPos = destination.toPixel(hexSize: gridManager.hexSize)
        let moveAction = SKAction.move(to: targetPos, duration: 0.2)
        moveAction.timingMode = .easeInEaseOut
        actor.sprite.run(moveAction)
    }
    
    func performAttack(attacker: Actor, defender: Actor) {
        print("\(attacker.actorType) attacks \(defender.actorType) for \(attacker.attackDamage) damage")
        
        // Attack animation
        let originalPos = attacker.sprite.position
        let defenderPos = defender.sprite.position
        let dx = (defenderPos.x - originalPos.x) * 0.3
        let dy = (defenderPos.y - originalPos.y) * 0.3

        let lunge = SKAction.moveBy(x: dx, y: dy, duration: 0.1)
        let returnBack = SKAction.move(to: originalPos, duration: 0.1)
        attacker.sprite.run(SKAction.sequence([lunge, returnBack]))
        
        // Deal damage
        defender.takeDamage(attacker.attackDamage)
        
        // Handle push
        if attacker.pushDistance > 0 {
            performPush(attacker: attacker, defender: defender)
        }
        
        // Check if defender died
        if defender.isDead {
            handleActorDeath(defender)
        }
    }
    
    func performPush(attacker: Actor, defender: Actor) {
        // Calculate push direction (away from attacker)
        let direction = HexCoord(
            defender.position.q - attacker.position.q,
            defender.position.r - attacker.position.r
        )
        
        // Calculate push destination
        let pushDest = HexCoord(
            defender.position.q + direction.q * attacker.pushDistance,
            defender.position.r + direction.r * attacker.pushDistance
        )
        
        // Check if push destination is valid
        if gridManager.isValidTile(pushDest) && !gridManager.blockedTiles.contains(pushDest) {
            print("\(defender.actorType) pushed to \(pushDest)")
            moveActor(defender, to: pushDest)
        } else {
            print("Push blocked - destination occupied or invalid")
        }
    }
    
    func handleActorDeath(_ actor: Actor) {
        print("\(actor.actorType) has died")
        
        // Unblock tile
        gridManager.blockedTiles.remove(actor.position)
        
        // Death animation
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let scale = SKAction.scale(to: 0.5, duration: 0.3)
        let group = SKAction.group([fadeOut, scale])
        
        actor.sprite.run(group) {
            actor.sprite.removeFromParent()
        }
        
        // Award gold if enemy
        if let enemy = actor as? Enemy {
            let goldReward = enemy.enemyType == .grunt ? 5 : 15
            hero.addGold(goldReward)
        }
    }
    
    func addEnemy(_ enemy: Enemy) {
        enemies.append(enemy)
        gridManager.blockedTiles.insert(enemy.position)
        scene?.addChild(enemy.sprite)
        enemy.updateSpritePosition(hexSize: gridManager.hexSize)
    }
    
    func reset() {
        // Clear all enemies
        for enemy in enemies {
            enemy.sprite.removeFromParent()
            gridManager.blockedTiles.remove(enemy.position)
        }
        enemies.removeAll()
        
        // Reset hero
        hero.hp = hero.maxHp
        hero.isDefending = false
        hero.shieldAmount = 0
        hero.poisonStacks = 0
        hero.updateHPLabel()
        
        // Reset turn
        turnCount = 0
        currentPhase = .playerTurn
    }
}
