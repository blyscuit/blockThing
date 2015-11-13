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
    
    var tag : Int
    
    init(column: Int, row: Int, tileType: Int, inTag:Int) {
        self.column = column
        self.row = row
        self.walk = true
        self.tag = inTag
        self.tileType = TileType(rawValue: tileType)!
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSizeZero)
        zPosition = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var description: String {
        return "type:\(tileType) square:(\(column),\(row))"
    }
}

enum TileType: Int, CustomStringConvertible {
    //0,1Ground , 2Lava,3Wall, 4Monster, 5Button, 6Birth, 7Key, 8Lock,9door,10 second birth,11CircleMon,12 Exit,13 one play,14 two play,15 dotTile,16 darknessTile"
    case Unknown = 0,Ground , Lava,Wall, Monster, Button, Birth, Key, Lock,Door,Second,CircleMon,Exit,OnePlay,TwoPlay,DotTile,DarknessTile
    
    var spriteName: String {
        let spriteNames = [
            "plain",
            "lava",
            "wall",
            "plain",
            "switch",
        "plain",
        "plain",
        "lock",
            "door",
            "plain",
            "plain",
            "exit",
            "one",
        "two",
            "dotTile",
        "plain"]
        
        return spriteNames[rawValue - 1]
    }
    
    static func random() -> TileType {
        return TileType(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
    
    var description: String {
        return spriteName
    }
}