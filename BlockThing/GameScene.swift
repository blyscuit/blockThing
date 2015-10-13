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
    case emptyness = 9
    
}

let TileWidth: CGFloat = 80.0
let TileHeight: CGFloat = 80.0

class GameScene: SKScene,SKPhysicsContactDelegate {
    var hero:Hero!
    var justMove = false;
    var fingerPosition:CGPoint?
    
    override func didMoveToView(view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        /* Setup your scene here */
        myMap = Map(filename: "Level_1")
        addTiles()
        self.addChild(tilesLayer);
        
//        let circleMonster = CircleMonster(imageNamed: "mon", inX: 5, inY: 4)
//        circleMonster.zPosition = 2;
//        circleMonster.position = pointForColumn(circleMonster.x, row: circleMonster.y)
//        self.addChild(circleMonster)
//        hero = Hero(xd: NumColumns/2, yd: NumRows/2)
//        hero.position = pointForColumn(hero.x, row: hero.y)
//        self.addChild(hero)
        
        tilesLayer.position = CGPointMake(0, 0)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        fingerPosition = touches.first?.locationInNode(self)
        justMove = false;
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
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(justMove){return;}
        if(touches.first?.locationInNode(self).x > (fingerPosition?.x)!+10){
            hero.goRight()
            tilesLayer.goRight()
        }else if(touches.first?.locationInNode(self).x < (fingerPosition?.x)!-10){
            hero.goLeft()
            tilesLayer.goLeft()
        }else if(touches.first?.locationInNode(self).y > (fingerPosition?.y)!+10){
            hero.goUp()
            tilesLayer.goUp()
        }else if(touches.first?.locationInNode(self).y < (fingerPosition?.y)!-10){
            hero.goDown()
            tilesLayer.goDown()
        }
        
        justMove = true;
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    let tilesLayer = MoveMap()
    
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
        
        if (contact.bodyA.categoryBitMask == BodyType.hero.rawValue && contact.bodyB.categoryBitMask == BodyType.monster.rawValue )  {
            
            print("bodyA was our Bro hero, bodyB was the monster")
        } else if (contact.bodyA.categoryBitMask == BodyType.hero.rawValue && contact.bodyB.categoryBitMask == BodyType.monster.rawValue )  {
            
            print("bodyB was our Bro hero, bodyA was the monster")
        }
        
    }
    
}


