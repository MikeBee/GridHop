//
//  GameScene.swift
//  GridHop
//
//  Tactical roguelite main game scene
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // Core game systems
    var gridManager: GridManager!
    var hero: Hero!
    var combatManager: CombatManager!
    
    // UI Elements
    var hud: HUD!
    var highlightedTiles: [HexCoord: SKShapeNode] = [:]
    var gridTileSprites: [HexCoord: SKShapeNode] = [:]
    
    // Input state
    var selectedAction: PlayerAction = .none
    
    enum PlayerAction {
        case none
        case move
        case attack
        case defend
    }
    
    override func didMove(to view: SKView) {
        setupGame()
    }
    
    func setupGame() {
        backgroundColor = SKColor(white: 0.15, alpha: 1.0)
        
        // Initialize grid manager
        gridManager = GridManager(hexSize: 40.0, gridRadius: 4)
        
        // Draw grid
        drawGrid()
        
        // Create hero at center
        hero = Hero(position: HexCoord(0, 0))
        gridManager.blockedTiles.insert(hero.position)
        addChild(hero.sprite)
        hero.updateSpritePosition(hexSize: gridManager.hexSize)
        
        // Initialize combat manager
        combatManager = CombatManager(scene: self, gridManager: gridManager, hero: hero)
        
        // Spawn initial enemies
        spawnInitialEnemies()
        
        // Setup HUD
        setupHUD()
        
        // Start first turn
        combatManager.startPlayerTurn()
    }
    
    func drawGrid() {
        for coord in gridManager.tiles {
            let hexShape = createHexagonShape()
            let pixelPos = coord.toPixel(hexSize: gridManager.hexSize)
            hexShape.position = pixelPos
            hexShape.zPosition = 0
            hexShape.name = "gridTile"
            addChild(hexShape)
            gridTileSprites[coord] = hexShape
        }
    }
    
    func createHexagonShape() -> SKShapeNode {
        let path = CGMutablePath()
        let hexSize = gridManager.hexSize
        
        for i in 0..<6 {
            let angle = CGFloat(i) * CGFloat.pi / 3.0
            let x = hexSize * cos(angle)
            let y = hexSize * sin(angle)
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        
        let hexNode = SKShapeNode(path: path)
        hexNode.strokeColor = SKColor(white: 0.3, alpha: 0.8)
        hexNode.lineWidth = 2
        hexNode.fillColor = SKColor(white: 0.2, alpha: 0.3)
        
        return hexNode
    }
    
    func spawnInitialEnemies() {
        // Spawn a few enemies around the hero
        let enemyPositions = [
            HexCoord(2, -1),
            HexCoord(-2, 1),
            HexCoord(1, 2)
        ]
        
        for (index, pos) in enemyPositions.enumerated() {
            let enemyType: EnemyType = index == 0 ? .brute : .grunt
            let enemy = Enemy(type: enemyType, position: pos)
            combatManager.addEnemy(enemy)
        }
    }
    
    func setupHUD() {
        hud = HUD(scene: self)
        addChild(hud)
    }
    
    // MARK: - Tile Highlighting
    
    func showReachableTiles(from position: HexCoord, range: Int) {
        clearHighlights()
        
        let reachable = gridManager.reachableTiles(from: position, range: range)
        
        for coord in reachable {
            if coord == position { continue } // Don't highlight current position
            
            let highlight = createHexagonShape()
            highlight.fillColor = SKColor.green.withAlphaComponent(0.3)
            highlight.strokeColor = SKColor.green
            highlight.lineWidth = 3
            highlight.zPosition = 5
            
            let pixelPos = coord.toPixel(hexSize: gridManager.hexSize)
            highlight.position = pixelPos
            highlight.name = "highlight"
            
            addChild(highlight)
            highlightedTiles[coord] = highlight
        }
    }
    
    func showAttackRange(from position: HexCoord, range: Int) {
        clearHighlights()
        
        let reachable = gridManager.reachableTiles(from: position, range: range, ignoreBlocked: true)
        
        for coord in reachable {
            if coord == position { continue }
            
            // Only highlight if there's an enemy
            let hasEnemy = combatManager.enemies.contains { $0.position == coord && $0.isAlive }
            if !hasEnemy { continue }
            
            let highlight = createHexagonShape()
            highlight.fillColor = SKColor.red.withAlphaComponent(0.4)
            highlight.strokeColor = SKColor.red
            highlight.lineWidth = 3
            highlight.zPosition = 5
            
            let pixelPos = coord.toPixel(hexSize: gridManager.hexSize)
            highlight.position = pixelPos
            highlight.name = "highlight"
            
            addChild(highlight)
            highlightedTiles[coord] = highlight
        }
    }
    
    func clearHighlights() {
        for (_, highlight) in highlightedTiles {
            highlight.removeFromParent()
        }
        highlightedTiles.removeAll()
    }
    
    // MARK: - Touch Handling
    
    func pixelToHex(_ point: CGPoint) -> HexCoord? {
        // Convert pixel position to hex coordinate (approximation)
        let hexSize = gridManager.hexSize
        let q = (sqrt(3.0)/3.0 * point.x - 1.0/3.0 * point.y) / hexSize
        let r = (2.0/3.0 * point.y) / hexSize
        
        return hexRound(q: q, r: r)
    }
    
    func hexRound(q: CGFloat, r: CGFloat) -> HexCoord {
        let s = -q - r
        
        var rq = round(q)
        var rr = round(r)
        let rs = round(s)
        
        let qDiff = abs(rq - q)
        let rDiff = abs(rr - r)
        let sDiff = abs(rs - s)
        
        if qDiff > rDiff && qDiff > sDiff {
            rq = -rr - rs
        } else if rDiff > sDiff {
            rr = -rq - rs
        }
        
        return HexCoord(Int(rq), Int(rr))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard combatManager.currentPhase == .playerTurn else { return }
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        
        // Check if HUD button was tapped
        if let tappedNode = atPoint(location) as? SKSpriteNode {
            if tappedNode.name == "attackButton" {
                handleAttackButton()
                return
            } else if tappedNode.name == "defendButton" {
                handleDefendButton()
                return
            } else if tappedNode.name == "endTurnButton" {
                handleEndTurnButton()
                return
            }
        }
        
        // Handle grid tap
        if let hexCoord = pixelToHex(location) {
            handleGridTap(at: hexCoord)
        }
    }
    
    func handleGridTap(at coord: HexCoord) {
        guard gridManager.tiles.contains(coord) else { return }
        
        switch selectedAction {
        case .none, .move:
            // Try to move to this tile
            let reachable = gridManager.reachableTiles(from: hero.position, range: hero.moveRange)
            if reachable.contains(coord) && coord != hero.position {
                combatManager.moveActor(hero, to: coord)
                clearHighlights()
                selectedAction = .none
                hud.updateActionButtons(selected: .none)
            }
            
        case .attack:
            // Try to attack enemy at this tile
            if let enemy = combatManager.enemies.first(where: { $0.position == coord && $0.isAlive }) {
                let distance = hero.position.distance(to: enemy.position)
                if distance <= hero.attackRange {
                    combatManager.performAttack(attacker: hero, defender: enemy)
                    clearHighlights()
                    selectedAction = .none
                    hud.updateActionButtons(selected: .none)
                }
            }
            
        case .defend:
            break
        }
    }
    
    func handleAttackButton() {
        if selectedAction == .attack {
            selectedAction = .none
            clearHighlights()
            showReachableTiles(from: hero.position, range: hero.moveRange)
        } else {
            selectedAction = .attack
            showAttackRange(from: hero.position, range: hero.attackRange)
        }
        hud.updateActionButtons(selected: selectedAction)
    }
    
    func handleDefendButton() {
        hero.defend()
        combatManager.endPlayerTurn()
        selectedAction = .none
        hud.updateActionButtons(selected: .none)
    }
    
    func handleEndTurnButton() {
        combatManager.endPlayerTurn()
        selectedAction = .none
        hud.updateActionButtons(selected: .none)
    }
    
    // MARK: - Game Over / Victory
    
    func showGameOver() {
        let overlay = SKSpriteNode(color: SKColor.black.withAlphaComponent(0.7), size: size)
        overlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
        overlay.zPosition = 100
        
        let label = SKLabelNode(text: "GAME OVER")
        label.fontSize = 48
        label.fontName = "AvenirNext-Bold"
        label.fontColor = .red
        label.position = CGPoint(x: 0, y: 50)
        overlay.addChild(label)
        
        let scoreLabel = SKLabelNode(text: "Gold: \(hero.gold)")
        scoreLabel.fontSize = 24
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: 0, y: 0)
        overlay.addChild(scoreLabel)
        
        let restartLabel = SKLabelNode(text: "Tap to Restart")
        restartLabel.fontSize = 20
        restartLabel.fontName = "AvenirNext-Regular"
        restartLabel.fontColor = .white
        restartLabel.position = CGPoint(x: 0, y: -50)
        overlay.addChild(restartLabel)
        
        addChild(overlay)
        
        // Enable restart on tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(restartGame))
        view?.addGestureRecognizer(tapGesture)
    }
    
    func showVictory() {
        let overlay = SKSpriteNode(color: SKColor.black.withAlphaComponent(0.7), size: size)
        overlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
        overlay.zPosition = 100
        
        let label = SKLabelNode(text: "VICTORY!")
        label.fontSize = 48
        label.fontName = "AvenirNext-Bold"
        label.fontColor = .green
        label.position = CGPoint(x: 0, y: 50)
        overlay.addChild(label)
        
        let scoreLabel = SKLabelNode(text: "Gold: \(hero.gold)")
        scoreLabel.fontSize = 24
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: 0, y: 0)
        overlay.addChild(scoreLabel)
        
        let restartLabel = SKLabelNode(text: "Tap to Play Again")
        restartLabel.fontSize = 20
        restartLabel.fontName = "AvenirNext-Regular"
        restartLabel.fontColor = .white
        restartLabel.position = CGPoint(x: 0, y: -50)
        overlay.addChild(restartLabel)
        
        addChild(overlay)
        
        // Enable restart on tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(restartGame))
        view?.addGestureRecognizer(tapGesture)
    }
    
    @objc func restartGame() {
        // Remove all gesture recognizers
        view?.gestureRecognizers?.forEach { view?.removeGestureRecognizer($0) }

        // Reload the scene
        if let scene = GKScene(fileNamed: "GameScene") {
            if let sceneNode = scene.rootNode as? GameScene {
                sceneNode.scaleMode = .aspectFill
                view?.presentScene(sceneNode, transition: SKTransition.fade(withDuration: 0.5))
            }
        }
    }
}
