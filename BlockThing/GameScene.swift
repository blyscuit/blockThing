//
//  GameScene.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-10-12.
//  Copyright (c) 2015 confusians. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        addTiles()
        self.addChild(tilesLayer);
        let hero = Hero(xd: self.frame.width/2, yd: self.frame.height/2)
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
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    let tilesLayer = SKNode()
    
    func addTiles() {
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
//                if let tile = map.tileAtColumn(column, row: row) {
                    let tileNode = SKSpriteNode(imageNamed: "lava")
                    tileNode.position = pointForColumn(column, row: row)
                    tileNode.size = CGSize(width: 80, height: 80)
                    tilesLayer.addChild(tileNode)
//                }
            }
        }
    }
    
    let TileWidth: CGFloat = 80.0
    let TileHeight: CGFloat = 80.0
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
    
    
}


