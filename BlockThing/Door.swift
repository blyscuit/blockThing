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
        super.init(column: column, row: row, tileType: TileType.Door.rawValue, inTag:0)
        walk = false;
        
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI_2*Double(Int(arc4random_uniform(4)))), duration: 0.0)
        runAction(rotate)
    }
    init(column: Int, row: Int , inTag:Int){
        super.init(column: column, row: row, tileType: TileType.Door.rawValue, inTag:inTag)
        walk = false;
        
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI_2*Double(Int(arc4random_uniform(4)))), duration: 0.0)
        runAction(rotate)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Wall: Tile {
    var close = true
    init(column: Int, row: Int){
        super.init(column: column, row: row, tileType: TileType.Wall.rawValue, inTag:0)
        walk = false;
        let body = SKPhysicsBody(rectangleOfSize: CGSizeMake(TileWidth, TileWidth))
        body.dynamic = false
        body.affectedByGravity = false
        body.allowsRotation = false
        body.categoryBitMask = BodyType.wall.rawValue
        body.contactTestBitMask = BodyType.monster.rawValue
        body.collisionBitMask = 0
        self.physicsBody = body
        
        
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 0.000001)
        runAction(SKAction.repeatActionForever(SKAction.sequence([rotate,SKAction.waitForDuration(Double(arc4random_uniform(7)+1))])))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Switch: Tile {
    var close = true
    let time = 1.0
    
    var under:SKSpriteNode!
    
    func flip(){
        close = !close
        under.removeAllActions()
        if(close == true){
                        under.texture = SKTexture(imageNamed: "switch")
            under.runAction(SKAction.colorizeWithColor(.whiteColor(), colorBlendFactor: 1, duration: 0.0))
        }else{
                        under.texture = SKTexture(imageNamed: "switch-on")
            
            let colorize = SKAction.colorizeWithColor(.blackColor(), colorBlendFactor: 1, duration: time*1.36)//SKAction.colorizeWithColorBlendFactor(1, duration: time, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0)//
            let colorizeB = SKAction.colorizeWithColor(.whiteColor(), colorBlendFactor: 0.6, duration: time)//SKAction.colorizeWithColorBlendFactor(1, duration: time, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0)//
            let rotate = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 0.0)
            
            under.runAction(SKAction.colorizeWithColor(.blackColor(), colorBlendFactor: 1, duration: 0.0))
            
            var coloring = SKAction.repeatActionForever(SKAction.sequence([colorizeB,colorize,rotate]))
            
            under.runAction(coloring)
        }
        
        self.texture = nil
    }
    init(column: Int, row: Int , inTag:Int){
        super.init(column: column, row: row, tileType: TileType.Button.rawValue, inTag:inTag)
        
        let over = SKSpriteNode(texture: SKTexture(imageNamed: "switch-over"), color: UIColor.clearColor(), size: CGSizeMake(TileWidth, TileHeight))
//        over.position = self.position
        under = SKSpriteNode(texture: SKTexture(imageNamed: "switch"), color: UIColor.clearColor(), size: CGSizeMake(TileWidth, TileHeight))
//        self.parent?.addChild(over)
        addChild(under)
        self.texture = nil
        over.zPosition = 1
        addChild(over)
//        over.runAction(SKAction.repeatActionForever(SKAction.colorizeWithColor(.clearColor(), colorBlendFactor: 1, duration: 0.0)))
        
        under.runAction(SKAction.colorizeWithColor(.whiteColor(), colorBlendFactor: 1, duration: 0.0))
    }
    init(column: Int, row: Int){
        super.init(column: column, row: row, tileType: TileType.Button.rawValue, inTag:0)
        runAction(SKAction.colorizeWithColor(.whiteColor(), colorBlendFactor: 1, duration: 0.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class Lava: Tile {
    
    init(column: Int, row: Int){
        super.init(column: column, row: row, tileType: TileType.Lava.rawValue, inTag:0)
        
        let time = 3.0
        runAction(SKAction.colorizeWithColor(.blackColor(), colorBlendFactor: 1, duration: 0.0))
        let colorize = SKAction.colorizeWithColor(.redColor(), colorBlendFactor: 0.82, duration: time*1.36)
        let colorizeB = SKAction.colorizeWithColor(.blackColor(), colorBlendFactor: 1, duration: time)
        runAction(SKAction.repeatActionForever(SKAction.sequence([colorizeB,colorize])))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
