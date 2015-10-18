//
//  Tile.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-10-13.
//  Copyright © 2015 confusians. All rights reserved.
//

import UIKit
import SpriteKit

class Tile : SKSpriteNode {
    var column: Int
    var row: Int
    var tileType : TileType
    
    var walk : Bool
    
    init(column: Int, row: Int, tileType: Int) {
        self.column = column
        self.row = row
        self.walk = true
        self.tileType = TileType(rawValue: tileType)!
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSizeZero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var description: String {
        return "type:\(tileType) square:(\(column),\(row))"
    }
}

enum TileType: Int, CustomStringConvertible {
    case Unknown = 0,Ground , Lava,Wall, Monster, Button, Birth, Key, Lock,Door
    
    var spriteName: String {
        let spriteNames = [
            "plain",
            "lava",
            "wall",
            "monster",
            "button",
        "plain",
        "plain",
        "lock",
        "Door"]
        
        return spriteNames[rawValue - 1]
    }
    
    static func random() -> TileType {
        return TileType(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
    
    var description: String {
        return spriteName
    }
}