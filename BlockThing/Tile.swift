//
//  Tile.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-10-13.
//  Copyright © 2015 confusians. All rights reserved.
//

import UIKit
import SpriteKit

class Tile : CustomStringConvertible {
    var column: Int
    var row: Int
    let tileType : TileType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, tileType: Int) {
        self.column = column
        self.row = row
        self.tileType = TileType(rawValue: tileType)!
    }
    
    var description: String {
        return "type:\(tileType) square:(\(column),\(row))"
    }
    
    var hashValue: Int {
        return row*10 + column
    }
}

enum TileType: Int, CustomStringConvertible {
    case Unknown = 0, Button, Ground, Lava, Monster
    
    var spriteName: String {
        let spriteNames = [
            "button",
            "plain",
            "lava",
            "wall",
            "monster"]
        
        return spriteNames[rawValue - 1]
    }
    
    static func random() -> TileType {
        return TileType(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
    
    var description: String {
        return spriteName
    }
}