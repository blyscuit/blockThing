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
    var tag = 0
    var life = 0
    func flip(closing:Bool){
        if(closing){
            life++;
        }else{
            life--;
            if(life<=0){
                life=0;
            }
        }
        if(life>0){
            close = true
            walk = false
        }else{
            close = false
            walk = true
        }
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
        let body = SKPhysicsBody(rectangleOfSize: CGSizeMake(TileWidth, TileWidth))
        body.dynamic = false
        body.affectedByGravity = false
        body.allowsRotation = false
        body.categoryBitMask = BodyType.wall.rawValue
        body.contactTestBitMask = BodyType.monster.rawValue
        body.collisionBitMask = 0
        self.physicsBody = body
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
        if(close == true){
            self.texture = SKTexture(imageNamed: "button")
        }else{
            self.texture = SKTexture(imageNamed: "buttonOn")
        }
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
