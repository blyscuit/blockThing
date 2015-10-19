//
//  Door.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-10-14.
//  Copyright © 2015 confusians. All rights reserved.
//

import SpriteKit

class Door: Tile {
    var close = true
    var tag = 0;
    func flip(){
        close = !close
        walk = !close;
        if(close==true){
            self.texture = SKTexture(imageNamed: TileType.Door.spriteName)
        }else{
            self.texture = SKTexture(imageNamed: TileType.Ground.spriteName)
        }
    }
    init(column: Int, row: Int){
        super.init(column: column, row: row, tileType: TileType.Door.rawValue)
        walk = false;
    }
    init(column: Int, row: Int , inTag:Int){
        tag = inTag
        super.init(column: column, row: row, tileType: TileType.Door.rawValue)
        walk = false;
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Wall: Tile {
    var close = true
    init(column: Int, row: Int){
        super.init(column: column, row: row, tileType: TileType.Wall.rawValue)
        walk = false;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Switch: Tile {
    var tag = 0;
    var close = true
    func flip(){
        close = !close
    }
    init(column: Int, row: Int , inTag:Int){
        tag = inTag
        super.init(column: column, row: row, tileType: TileType.Button.rawValue)
    }
    init(column: Int, row: Int){
        super.init(column: column, row: row, tileType: TileType.Button.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
