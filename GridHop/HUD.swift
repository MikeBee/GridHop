//
//  HUD.swift
//  GridHop
//
//  Heads-up display for game information and controls
//

import Foundation
import SpriteKit

class HUD: SKNode {
    weak var gameScene: GameScene?

    var heroHPLabel: SKLabelNode!
    var goldLabel: SKLabelNode!
    var turnLabel: SKLabelNode!

    var attackButton: SKSpriteNode!
    var defendButton: SKSpriteNode!
    var endTurnButton: SKSpriteNode!

    init(scene: GameScene) {
        super.init()
        self.gameScene = scene
        self.zPosition = 50
        setupHUD()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHUD() {
        guard let scene = gameScene else { return }

        let screenWidth = scene.size.width
        let screenHeight = scene.size.height
        
        // Top bar background
        let topBar = SKSpriteNode(color: SKColor.black.withAlphaComponent(0.7), size: CGSize(width: screenWidth, height: 80))
        topBar.position = CGPoint(x: screenWidth / 2, y: screenHeight - 40)
        topBar.zPosition = 0
        addChild(topBar)
        
        // Hero HP Label
        heroHPLabel = SKLabelNode(text: "HP: 12/12")
        heroHPLabel.fontSize = 20
        heroHPLabel.fontName = "AvenirNext-Bold"
        heroHPLabel.fontColor = .white
        heroHPLabel.horizontalAlignmentMode = .left
        heroHPLabel.position = CGPoint(x: 20, y: screenHeight - 50)
        addChild(heroHPLabel)
        
        // Gold Label
        goldLabel = SKLabelNode(text: "Gold: 0")
        goldLabel.fontSize = 18
        goldLabel.fontName = "AvenirNext-Bold"
        goldLabel.fontColor = .yellow
        goldLabel.horizontalAlignmentMode = .left
        goldLabel.position = CGPoint(x: 20, y: screenHeight - 75)
        addChild(goldLabel)
        
        // Turn Label
        turnLabel = SKLabelNode(text: "Turn: 1")
        turnLabel.fontSize = 18
        turnLabel.fontName = "AvenirNext-Bold"
        turnLabel.fontColor = .white
        turnLabel.horizontalAlignmentMode = .right
        turnLabel.position = CGPoint(x: screenWidth - 20, y: screenHeight - 50)
        addChild(turnLabel)
        
        // Bottom action buttons
        let buttonY: CGFloat = 60
        let buttonSize = CGSize(width: 100, height: 50)
        
        // Attack Button
        attackButton = createButton(text: "⚔️ Attack", size: buttonSize, color: .systemRed)
        attackButton.position = CGPoint(x: screenWidth / 2 - 120, y: buttonY)
        attackButton.name = "attackButton"
        addChild(attackButton)
        
        // Defend Button
        defendButton = createButton(text: "🛡️ Defend", size: buttonSize, color: .systemBlue)
        defendButton.position = CGPoint(x: screenWidth / 2, y: buttonY)
        defendButton.name = "defendButton"
        addChild(defendButton)
        
        // End Turn Button
        endTurnButton = createButton(text: "End Turn", size: buttonSize, color: .systemGreen)
        endTurnButton.position = CGPoint(x: screenWidth / 2 + 120, y: buttonY)
        endTurnButton.name = "endTurnButton"
        addChild(endTurnButton)
    }
    
    func createButton(text: String, size: CGSize, color: UIColor) -> SKSpriteNode {
        let button = SKSpriteNode(color: color, size: size)
        button.colorBlendFactor = 0.8
        
        // Add rounded corners effect with border
        let border = SKShapeNode(rectOf: size, cornerRadius: 8)
        border.strokeColor = .white
        border.lineWidth = 2
        border.fillColor = .clear
        button.addChild(border)
        
        let label = SKLabelNode(text: text)
        label.fontSize = 14
        label.fontName = "AvenirNext-Bold"
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        button.addChild(label)
        
        return button
    }
    
    func updateActionButtons(selected: GameScene.PlayerAction) {
        // Reset all buttons to default state
        attackButton.alpha = 1.0
        defendButton.alpha = 1.0
        endTurnButton.alpha = 1.0
        
        // Highlight selected button
        switch selected {
        case .attack:
            attackButton.alpha = 0.5
        case .defend:
            defendButton.alpha = 0.5
        default:
            break
        }
    }
    
    func update() {
        guard let scene = gameScene else { return }

        // Update labels
        heroHPLabel.text = "HP: \(scene.hero.hp)/\(scene.hero.maxHp)"
        goldLabel.text = "Gold: \(scene.hero.gold)"

        if let combatManager = scene.combatManager {
            turnLabel.text = "Turn: \(combatManager.turnCount)"
        }

        // Update hero HP color based on health
        let healthPercent = Float(scene.hero.hp) / Float(scene.hero.maxHp)
        if healthPercent > 0.6 {
            heroHPLabel.fontColor = .green
        } else if healthPercent > 0.3 {
            heroHPLabel.fontColor = .yellow
        } else {
            heroHPLabel.fontColor = .red
        }
    }
}

// Extension to keep HUD updated
extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        hud?.update()
    }
}
