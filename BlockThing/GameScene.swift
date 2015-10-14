//
//  GameScene.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-10-12.
//  Copyright (c) 2015 confusians. All rights reserved.
//

import SpriteKit

enum BodyType:UInt32 {
    
    case hero = 1
    case ground = 2
    case monster = 4
    
}

let TileWidth: CGFloat = 80.0
let TileHeight: CGFloat = 80.0

class GameScene: SKScene,SKPhysicsContactDelegate {
    override func didMoveToView(view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        /* Setup your scene here */
        myMap = Map(filename: "Level_1")
        addTiles()
        self.addChild(tilesLayer);
        
        let circleMonster = CircleMonster(imageNamed: "mon", inX: 5, inY: 4)
        circleMonster.zPosition = 2;
        circleMonster.position = pointForColumn(circleMonster.x, row: circleMonster.y)
        self.addChild(circleMonster)
        var hero = Hero(xd: 4, yd: 4)
        hero.position = pointForColumn(hero.x, row: hero.y)
        self.addChild(hero)
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
            
            
            let circleMonster = CircleMonster(imageNamed: "mon", inX: 1, inY: 1)
                        let location = touch.locationInNode(self)
                        circleMonster.position = location
            self.addChild(circleMonster)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        
        
        
        
    }
    
    let tilesLayer = SKNode()
    
    func addTiles() {
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let tile = myMap.tileAtColumn(column, row: row) {
                    let tileNode = SKSpriteNode(imageNamed:tile.tileType.spriteName)
                    tileNode.position = pointForColumn(column, row: row)
                    tileNode.size = CGSize(width: 80, height: 80)
                    tileNode.zPosition = -1
                    tilesLayer.addChild(tileNode)
                }
            }
        }
    }
    
    
    var myMap : Map!
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        //this gets called automatically when two objects begin contact with each other
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch (contactMask) {
            case BodyType.monster.rawValue | BodyType.hero.rawValue:
                print("contact!")
            case BodyType.monster.rawValue | BodyType.monster.rawValue:
                print("Monster Contact!")
            default:
                return
        }
        
//        if (contact.bodyA.categoryBitMask == BodyType.hero.rawValue && contact.bodyB.categoryBitMask == BodyType.monster.rawValue )  {
//        
//            print("bodyA was our Bro class, bodyB was the ground")
//        } else if (contact.bodyA.categoryBitMask == BodyType.hero.rawValue && contact.bodyB.categoryBitMask == BodyType.monster.rawValue )  {
//            
//            print("bodyB was our Bro class, bodyA was the ground")
//        }
        
    }
    
//    func didEndContact(contact: SKPhysicsContact) {
//        <#code#>
//    }
    
}


