//
//  Door.swift
//  BlockThing
//
//  Created by Pakin Intanate on 2015-10-14.
//  Copyright © 2015 confusians. All rights reserved.
//

import SpriteKit

class Door: Tile {
    var close = true
    var life = 0
    func flip(_ closing:Bool){
        if(closing){
            life += 1;
        }else{
            life -= 1;
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
            
            var cover:SKSpriteNode = SKSpriteNode(color: UIColor.white, size: self.size)
            cover.alpha = 0.0
            cover.zPosition = 1
            addChild(cover)
            let ma = max(NumColumns, NumRows)
            var expand = SKAction.scale(to: CGFloat(ma), duration: 0.9)
            expand.timingMode = SKActionTimingMode.easeOut
            cover.run(expand, completion: { () -> Void in
                cover.removeAllActions()
                cover.removeFromParent()
            })
            cover.run(SKAction.sequence([SKAction.fadeAlpha(to: 0.450, duration: 0.3),SKAction.wait(forDuration: 0.45),SKAction.fadeAlpha(to: 0.0, duration: 0.15)]))
        }
        if(close==true){
            self.texture = SKTexture(imageNamed: TileType.door.spriteName)
        }else{
            self.texture = nil//SKTexture(imageNamed: TileType.Ground.spriteName)
        }
    }
    init(column: Int, row: Int){
        super.init(column: column, row: row, tileType: TileType.door.rawValue, inTag:0)
        walk = false;
        
        let rotate = SKAction.rotate(byAngle: CGFloat(M_PI_2*Double(Int(arc4random_uniform(4)))), duration: 0.0)
        run(rotate)
    }
    init(column: Int, row: Int , inTag:Int){
        super.init(column: column, row: row, tileType: TileType.door.rawValue, inTag:inTag)
        walk = false;
        
        let rotate = SKAction.rotate(byAngle: CGFloat(M_PI_2*Double(Int(arc4random_uniform(4)))), duration: 0.0)
        run(rotate)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Wall: Tile {
    var close = true
    init(column: Int, row: Int){
        super.init(column: column, row: row, tileType: TileType.wall.rawValue, inTag:0)
        walk = false;
        let body = SKPhysicsBody(rectangleOf: CGSize(width: TileWidth, height: TileWidth))
        body.isDynamic = false
        body.affectedByGravity = false
        body.allowsRotation = false
        body.categoryBitMask = BodyType.wall.rawValue
        body.contactTestBitMask = BodyType.monster.rawValue
        body.collisionBitMask = 0
        self.physicsBody = body
        
        
        let rotate = SKAction.rotate(byAngle: CGFloat(M_PI_2), duration: 0.000001)
        run(SKAction.repeatForever(SKAction.sequence([rotate,SKAction.wait(forDuration: Double(arc4random_uniform(7)+1))])))
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
            button.run(SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 0.0))
            topBar.run(SKAction.fadeAlpha(to: 0.0, duration: 0.3))
            button.run(SKAction.scaleTo(1.0, duration: 0.7, delay: 0.0, usingSpringWithDamping: 0.01, initialSpringVelocity: 0.0))
            over.size = CGSize(width: TileWidth/2, height: TileHeight/2)
            over.texture = SKTexture(imageNamed: "switch-over-1")
        }else{
            button.run(SKAction.scaleTo(2.0, duration: 0.7, delay: 0.0, usingSpringWithDamping: 0.01, initialSpringVelocity: 0.0))
                        button.texture = SKTexture(imageNamed: "inside-switch-on")
            
            let colorize = SKAction.colorize(with: .black, colorBlendFactor: 1, duration: time*1.36)//SKAction.colorizeWithColorBlendFactor(1, duration: time, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0)//
            let colorizeB = SKAction.colorize(with: .white, colorBlendFactor: 0.6, duration: time)//SKAction.colorizeWithColorBlendFactor(1, duration: time, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0)//
            let rotate = SKAction.rotate(byAngle: CGFloat(M_PI_2), duration: 0.0)
            
            button.run(SKAction.colorize(with: .black, colorBlendFactor: 1, duration: 0.0))
            
            var coloring = SKAction.repeatForever(SKAction.sequence([colorizeB,colorize,rotate]))
            topBar.run(SKAction.fadeAlpha(to: 0.23, duration: 0.6))
            topBar.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 0.01, duration: 0.1),SKAction.scale(to: 1.01, duration: 2.1)])))
            
            over.texture = SKTexture(imageNamed: "switch-over")
            over.size = self.size
            
            button.run(coloring)
        }
        
        self.texture = nil
    }
    init(column: Int, row: Int , inTag:Int){
        super.init(column: column, row: row, tileType: TileType.button.rawValue, inTag:inTag)
        
        over = SKSpriteNode(texture: SKTexture(imageNamed: "switch-over-1"), color: UIColor.clear, size: CGSize(width: TileWidth/2, height: TileHeight/2))
//        over.position = self.position
        under = SKSpriteNode(texture: SKTexture(imageNamed: "switch-1"), color: UIColor.clear, size: CGSize(width: TileWidth, height: TileHeight))
//        self.parent?.addChild(over)
        addChild(under)
        self.texture = nil
        over.zPosition = 1
        button = SKSpriteNode(texture:SKTexture(imageNamed: "inside-switch"),color:UIColor.clear,size:CGSize(width: TileWidth/2, height: TileHeight/2))
        button.zPosition = 0.98
        addChild(button)
        
        
        topBar = SKSpriteNode(texture: SKTexture(imageNamed: "switch-bar"), color: UIColor.clear, size: CGSize(width: TileWidth, height: TileHeight))
        topBar.zPosition = 0.99
        topBar.run(SKAction.colorize(with: .black, colorBlendFactor: 0.9, duration: 0.0))
        topBar.alpha = 0;
        addChild(over)
//        addChild(topBar)
//        over.runAction(SKAction.repeatActionForever(SKAction.colorizeWithColor(.clearColor(), colorBlendFactor: 1, duration: 0.0)))
        
        under.run(SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 0.0))
    }
    init(column: Int, row: Int){
        super.init(column: column, row: row, tileType: TileType.button.rawValue, inTag:0)
        run(SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 0.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class Lava: Tile {
    
    init(column: Int, row: Int){
        super.init(column: column, row: row, tileType: TileType.lava.rawValue, inTag:0)
        
        let time = 3.0
        run(SKAction.colorize(with: .black, colorBlendFactor: 1, duration: 0.0))
        let colorize = SKAction.colorize(with: UIColor(red:0.59, green:0.00, blue:0.00, alpha:1.0), colorBlendFactor: 1.22, duration: time*1.36)
        let colorizeB = SKAction.colorize(with: .black, colorBlendFactor: 1, duration: time)
        run(SKAction.repeatForever(SKAction.sequence([colorizeB,colorize])))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
