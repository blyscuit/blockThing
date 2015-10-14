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
        
        let circleMonster = CircleMonster(imageNamed: "mon", inX: 5, inY: 4)
        circleMonster.zPosition = 2;
        circleMonster.position = pointForColumn(circleMonster.x, row: circleMonster.y)
        tilesLayer.addChild(circleMonster)
        
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
            
            
//            let circleMonster = CircleMonster(imageNamed: "mon", inX: 1, inY: 1)
//                        let location = touch.locationInNode(self)
//                        circleMonster.position = location
//            self.addChild(circleMonster)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(justMove){return;}
        if(touches.first?.locationInNode(self).x > (fingerPosition?.x)!+10){
            if(myMap.canMoveToTile(hero.x+1, row: hero.y)){
                hero.goRight()
                tilesLayer.goRight()
                checkTile()
            }
        }else if(touches.first?.locationInNode(self).x < (fingerPosition?.x)!-10){
            if(myMap.canMoveToTile(hero.x-1, row: hero.y)){
                hero.goLeft()
                tilesLayer.goLeft()
                checkTile()
            }
        }else if(touches.first?.locationInNode(self).y > (fingerPosition?.y)!+10){
            if(myMap.canMoveToTile(hero.x, row: hero.y+1)){
                hero.goUp()
                tilesLayer.goUp()
                checkTile()
            }
        }else if(touches.first?.locationInNode(self).y < (fingerPosition?.y)!-10){
            if(myMap.canMoveToTile(hero.x, row: hero.y-1)){
                hero.goDown()
                tilesLayer.goDown()
                checkTile()
            }
        }
        
        justMove = true;
    }
   
    func checkTile(){
        if let tile = myMap.tileAtColumn(hero.x, row: hero.y) {
            if(tile.tileType == TileType.Lava){
                print("Fall in lava")
            }else if(tile.tileType == TileType.Door){
                print("Leave")
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        
        
        
        
    }
    
    let tilesLayer = MoveMap()
    
    func addTiles() {
        var centerTile:Tile!
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let tile = myMap.tileAtColumn(column, row: row) {
                    if(tile.tileType == TileType.Birth){
                        centerTile = tile
                    }
                    let tileNode = SKSpriteNode(imageNamed:tile.tileType.spriteName)
                    tileNode.position = pointForColumn(column, row: row)
                    tileNode.size = CGSize(width: TileWidth, height: TileHeight)
                    tileNode.zPosition = -1
                    tilesLayer.addChild(tileNode)
                }
            }
        }
        
        spawnPlayer(centerTile.column, inY: centerTile.row)
//        tilesLayer.size = CGSizeMake(TileWidth*CGFloat(NumColumns), TileHeight*CGFloat(NumRows))
//        tilesLayer.anchorPoint = CGPointMake(CGFloat(centerTile.column/NumColumns), CGFloat(centerTile.row/NumRows))
        tilesLayer.position = CGPointMake(self.size.width/2 - (pointForColumn(centerTile.column, row: centerTile.row)).x, self.size.height/2 - (pointForColumn(centerTile.column, row: centerTile.row)).y)
    }
    
    func spawnPlayer(inX : Int, inY: Int){
        hero = Hero(xd: inX, yd: inY)
        hero.anchorPoint = CGPointMake(0.5, 0.5)
        hero.position = CGPointMake(self.size.width/2, self.size.height/2)
        self.addChild(hero)
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


