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
            
            var cover:SKSpriteNode = SKSpriteNode(color: UIColor.whiteColor(), size: self.size)
            cover.alpha = 0.0
            cover.zPosition = 1
            addChild(cover)
            cover.runAction(SKAction.scaleTo(25, duration: 0.8, delay: 0.1, usingSpringWithDamping: 0.005, initialSpringVelocity: 0))
            cover.runAction(SKAction.fadeAlphaTo(0.750, duration: 0.8)) { () -> Void in
                cover.removeAllActions()
                cover.removeFromParent()
            }
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
    var topBar:SKSpriteNode!
    var button:SKSpriteNode!
    var over:SKSpriteNode!
    
    func flip(){
        close = !close
        under.removeAllActions()
        if(close == true){
                        button.texture = SKTexture(imageNamed: "inside-switch")
            button.removeAllActions()
            button.runAction(SKAction.colorizeWithColor(.whiteColor(), colorBlendFactor: 1, duration: 0.0))
            topBar.runAction(SKAction.fadeAlphaTo(0.0, duration: 0.3))
            button.runAction(SKAction.scaleTo(1.0, duration: 0.7, delay: 0.0, usingSpringWithDamping: 0.01, initialSpringVelocity: 0.0))
            over.size = CGSize(width: TileWidth/2, height: TileHeight/2)
            over.texture = SKTexture(imageNamed: "switch-over-1")
        }else{
            button.runAction(SKAction.scaleTo(2.0, duration: 0.7, delay: 0.0, usingSpringWithDamping: 0.01, initialSpringVelocity: 0.0))
                        button.texture = SKTexture(imageNamed: "inside-switch-on")
            
            let colorize = SKAction.colorizeWithColor(.blackColor(), colorBlendFactor: 1, duration: time*1.36)//SKAction.colorizeWithColorBlendFactor(1, duration: time, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0)//
            let colorizeB = SKAction.colorizeWithColor(.whiteColor(), colorBlendFactor: 0.6, duration: time)//SKAction.colorizeWithColorBlendFactor(1, duration: time, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0)//
            let rotate = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 0.0)
            
            button.runAction(SKAction.colorizeWithColor(.blackColor(), colorBlendFactor: 1, duration: 0.0))
            
            var coloring = SKAction.repeatActionForever(SKAction.sequence([colorizeB,colorize,rotate]))
            topBar.runAction(SKAction.fadeAlphaTo(0.23, duration: 0.6))
            topBar.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.scaleTo(0.01, duration: 0.1),SKAction.scaleTo(1.01, duration: 2.1)])))
            
            over.texture = SKTexture(imageNamed: "switch-over")
            over.size = self.size
            
            button.runAction(coloring)
        }
        
        self.texture = nil
    }
    init(column: Int, row: Int , inTag:Int){
        super.init(column: column, row: row, tileType: TileType.Button.rawValue, inTag:inTag)
        
        over = SKSpriteNode(texture: SKTexture(imageNamed: "switch-over-1"), color: UIColor.clearColor(), size: CGSizeMake(TileWidth/2, TileHeight/2))
//        over.position = self.position
        under = SKSpriteNode(texture: SKTexture(imageNamed: "switch-1"), color: UIColor.clearColor(), size: CGSizeMake(TileWidth, TileHeight))
//        self.parent?.addChild(over)
        addChild(under)
        self.texture = nil
        over.zPosition = 1
        button = SKSpriteNode(texture:SKTexture(imageNamed: "inside-switch"),color:UIColor.clearColor(),size:CGSizeMake(TileWidth/2, TileHeight/2))
        button.zPosition = 0.98
        addChild(button)
        
        
        topBar = SKSpriteNode(texture: SKTexture(imageNamed: "switch-bar"), color: UIColor.clearColor(), size: CGSizeMake(TileWidth, TileHeight))
        topBar.zPosition = 0.99
        topBar.runAction(SKAction.colorizeWithColor(.blackColor(), colorBlendFactor: 0.9, duration: 0.0))
        topBar.alpha = 0;
        addChild(over)
//        addChild(topBar)
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
