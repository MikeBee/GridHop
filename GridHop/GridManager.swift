//
//  GridManager.swift
//  GridHop
//
//  Grid management for hex-based tactical gameplay
//

import Foundation
import SpriteKit

// Axial coordinate system for hex grid
struct HexCoord: Hashable, Equatable {
    let q: Int  // column
    let r: Int  // row
    
    init(_ q: Int, _ r: Int) {
        self.q = q
        self.r = r
    }
    
    // Convert to pixel position (pointy-top hexes)
    func toPixel(hexSize: CGFloat) -> CGPoint {
        let sqrt3 = sqrt(3.0)
        let qFloat = CGFloat(q)
        let rFloat = CGFloat(r)

        let xComponent1 = sqrt3 * qFloat
        let xComponent2 = (sqrt3 / 2.0) * rFloat
        let x = hexSize * (xComponent1 + xComponent2)

        let y = hexSize * (1.5 * rFloat)

        return CGPoint(x: x, y: y)
    }
    
    // Get all 6 neighbors
    func neighbors() -> [HexCoord] {
        return [
            HexCoord(q + 1, r),      // E
            HexCoord(q + 1, r - 1),  // NE
            HexCoord(q, r - 1),      // NW
            HexCoord(q - 1, r),      // W
            HexCoord(q - 1, r + 1),  // SW
            HexCoord(q, r + 1)       // SE
        ]
    }
    
    // Manhattan distance for hex grid
    func distance(to other: HexCoord) -> Int {
        return (abs(q - other.q) + abs(q + r - other.q - other.r) + abs(r - other.r)) / 2
    }
}

class GridManager {
    let hexSize: CGFloat
    let gridRadius: Int  // Grid extends from -radius to +radius
    var tiles: Set<HexCoord> = []
    var blockedTiles: Set<HexCoord> = []
    
    init(hexSize: CGFloat = 40.0, gridRadius: Int = 4) {
        self.hexSize = hexSize
        self.gridRadius = gridRadius
        generateGrid()
    }
    
    // Generate circular hex grid
    private func generateGrid() {
        tiles.removeAll()
        for q in -gridRadius...gridRadius {
            let r1 = max(-gridRadius, -q - gridRadius)
            let r2 = min(gridRadius, -q + gridRadius)
            for r in r1...r2 {
                tiles.insert(HexCoord(q, r))
            }
        }
    }
    
    // Check if coordinate is valid and not blocked
    func isValidTile(_ coord: HexCoord) -> Bool {
        return tiles.contains(coord) && !blockedTiles.contains(coord)
    }
    
    // Get all tiles reachable within range using BFS
    func reachableTiles(from start: HexCoord, range: Int, ignoreBlocked: Bool = false) -> Set<HexCoord> {
        var reachable: Set<HexCoord> = [start]
        var visited: Set<HexCoord> = [start]
        var frontier: [(coord: HexCoord, dist: Int)] = [(start, 0)]
        var frontierIndex = 0
        
        while frontierIndex < frontier.count {
            let (current, dist) = frontier[frontierIndex]
            frontierIndex += 1
            
            if dist >= range { continue }
            
            for neighbor in current.neighbors() {
                if visited.contains(neighbor) { continue }
                if !tiles.contains(neighbor) { continue }
                if !ignoreBlocked && blockedTiles.contains(neighbor) { continue }
                
                visited.insert(neighbor)
                reachable.insert(neighbor)
                frontier.append((neighbor, dist + 1))
            }
        }
        
        return reachable
    }
    
    // Simple A* pathfinding
    func findPath(from start: HexCoord, to goal: HexCoord) -> [HexCoord]? {
        if !isValidTile(goal) { return nil }
        if start == goal { return [start] }
        
        var openSet: Set<HexCoord> = [start]
        var cameFrom: [HexCoord: HexCoord] = [:]
        var gScore: [HexCoord: Int] = [start: 0]
        var fScore: [HexCoord: Int] = [start: start.distance(to: goal)]
        
        while !openSet.isEmpty {
            // Find node with lowest fScore
            let current = openSet.min(by: { fScore[$0, default: Int.max] < fScore[$1, default: Int.max] })!
            
            if current == goal {
                return reconstructPath(cameFrom: cameFrom, current: current)
            }
            
            openSet.remove(current)
            
            for neighbor in current.neighbors() {
                if !isValidTile(neighbor) { continue }
                
                let tentativeGScore = gScore[current, default: Int.max] + 1
                
                if tentativeGScore < gScore[neighbor, default: Int.max] {
                    cameFrom[neighbor] = current
                    gScore[neighbor] = tentativeGScore
                    fScore[neighbor] = tentativeGScore + neighbor.distance(to: goal)
                    openSet.insert(neighbor)
                }
            }
        }
        
        return nil // No path found
    }
    
    private func reconstructPath(cameFrom: [HexCoord: HexCoord], current: HexCoord) -> [HexCoord] {
        var path = [current]
        var current = current
        while let previous = cameFrom[current] {
            path.insert(previous, at: 0)
            current = previous
        }
        return path
    }
    
    // Get direction from one hex to adjacent hex
    func direction(from: HexCoord, to: HexCoord) -> HexCoord? {
        let neighbors = from.neighbors()
        if neighbors.contains(to) {
            return HexCoord(to.q - from.q, to.r - from.r)
        }
        return nil
    }
}
