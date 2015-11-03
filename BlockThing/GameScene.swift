//
//  GameScene.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-10-12.
//  Copyright (c) 2015 confusians. All rights reserved.
//

import SpriteKit
import MultipeerConnectivity
//import UIKit

enum BodyType:UInt32 {
    
    case hero = 1
    case ground = 2
    case monster = 4
    case emptyness = 9
    case wall = 5
}

let TileWidth: CGFloat = 80.0
let TileHeight: CGFloat = 80.0

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var messagesArray: [Dictionary<String, String>] = []
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var hero: Hero!
    var justMove = false
    var fingerPosition:CGPoint?
    var velo: CGVector!
    
    var isOver = false
    
//    var isMoving = false
    
    var levelIs = "Level_main"
    
    override func didMoveToView(view: SKView) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleMPCReceivedDataWithNotification:", name: "receivedMPCDataNotification", object: nil)

        //let someText = Text(text: "THIS IS TOO HARD!")
        //self.addChild(someText)
        physicsWorld.contactDelegate = self
        backgroundColor = UIColor.whiteColor()
        
        startGame()
    }
    
    func startGame(){
        
        isOver = false
        
        //let someText = Text(Color: UIColor.blackColor(), Size: 20, inX: 300, inY: 300,text: "GG")
        //self.addChild(someText)
        
        var cover:SKSpriteNode = SKSpriteNode(color: UIColor.blackColor(), size: self.size)
        cover.zPosition = 5
        addChild(cover)
        cover.anchorPoint = CGPointMake(0.0, 0.0)
        cover.runAction(SKAction.fadeAlphaTo(0.0, duration: 0.32)) { () -> Void in
            cover.removeFromParent()
        }
        
        /* Setup your scene here */
        myMap = Map(filename: levelIs)
        addTiles()
        self.addChild(tilesLayer);
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        fingerPosition = touches.first?.locationInNode(self)
//        if (isMoving==true){
//            return
//        }

                justMove = false;
        
//        for touch in touches {
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
//        }
    }
    
//    override func keyUp(theEvent: NSEvent) {
//        let s: String = String(self.returnChar(theEvent)!)
//        switch(s){
//        case "w":
//            if(myMap.canMoveToTile(hero.xCoor, row: hero.yCoor+1)){
//                hero.goUp()
//                tilesLayer.goUp()
//                checkTile()
//            }
//            break
//        case "s":
//            if(myMap.canMoveToTile(hero.xCoor, row: hero.yCoor-1)){
//                hero.goDown()
//                tilesLayer.goDown()
//                checkTile()
//            }
//            break
//        case "d":
//            if(myMap.canMoveToTile(hero.xCoor+1, row: hero.yCoor)){
//                hero.goRight()
//                tilesLayer.goRight()
//                checkTile()
//            }
//            break
//        case "a":
//            if(myMap.canMoveToTile(hero.xCoor-1, row: hero.yCoor)){
//                hero.goLeft()
//                tilesLayer.goLeft()
//                checkTile()
//            }
//            break
//            
//            
//        default:
//            print("default")
//        }
//    }
    var moveDistance = CGFloat(5)
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(justMove||isOver){return;}
        
        let distanceX = abs((touches.first?.locationInNode(self).x)! - (fingerPosition?.x)!)
        let distanceY = abs((touches.first?.locationInNode(self).y)! - (fingerPosition?.y)!)
        
        if(touches.first?.locationInNode(self).x > (fingerPosition?.x)!+moveDistance && distanceX > distanceY){
            if(myMap.canMoveToTile(hero.xCoor+1, row: hero.yCoor)){
                self.centerMap(){
//                isMoving = true
                self.hero.goRight()
                self.tilesLayer.goRight(){
//                    self.isMoving = false
                    
                }
                self.checkTile()
                }
            }
        }else if(touches.first?.locationInNode(self).x < (fingerPosition?.x)!-moveDistance && distanceX > distanceY){
            if(myMap.canMoveToTile(hero.xCoor-1, row: hero.yCoor)){
                centerMap(){
//                isMoving = true
                self.hero.goLeft()
                self.tilesLayer.goLeft(){
                    //                    self.isMoving = false
//                    self.centerMap();
                }
                self.checkTile()
                }
            }
        }else if(touches.first?.locationInNode(self).y > (fingerPosition?.y)!+moveDistance && distanceX < distanceY){
            if(myMap.canMoveToTile(hero.xCoor, row: hero.yCoor+1)){
                centerMap(){
//                isMoving = true
                self.hero.goUp()
                self.tilesLayer.goUp(){
                    //                    self.isMoving = false
//                    self.centerMap();
                }
                self.checkTile()
                }
            }
        }else if(touches.first?.locationInNode(self).y < (fingerPosition?.y)!-moveDistance && distanceX < distanceY){
            if(myMap.canMoveToTile(hero.xCoor, row: hero.yCoor-1)){
                centerMap(){
//                isMoving = true
                self.hero.goDown()
                self.tilesLayer.goDown(){
                    //                    self.isMoving = false
//                    self.centerMap();
                }
                self.checkTile()
                }
            }
        }
        
        justMove = true;
    }
   
    func checkTile(){
        if let tile = myMap.tileAtColumn(hero.xCoor, row: hero.yCoor) {
            if(tile.tileType == TileType.Lava){
                print("Fall in lava")
                gameOver()
            }else if(tile.tileType == TileType.Exit){
                clearLevel()
            }else if(tile.tileType == TileType.Button){
                (tile as? Switch)?.flip()
                if((tile as? Switch)?.tag != 0){
                    for row in 0..<NumRows {
                        for column in 0..<NumColumns {
                            if let tiles = myMap.tileAtColumn(column, row: row) as? Door {
                                if(tiles.tileType == TileType.Door && tiles.tag == (tile as? Switch)?.tag){
                                    tiles.flip(((tile as? Switch)?.close)!)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //checkWall()
        
        
        
    }
    
    let tilesLayer = MoveMap()
    
    func addTiles() {
        var centerTile:Tile!
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let tile = myMap.tileAtColumn(column, row: row) {
                    if(tile.tileType == TileType.Birth){
                        centerTile = tile
                    }else if(tile.tileType == TileType.Monster){
                        let triangleMonster = TriangleMonster(imageNamed: "triangle", inX: tile.column, inY: tile.row)
                        triangleMonster.zPosition = 2;
                        triangleMonster.position = pointForColumn(triangleMonster.xCoor, row: triangleMonster.yCoor)
                        tilesLayer.addChild(triangleMonster)
                    }else if(tile.tileType == TileType.CircleMon){
                        let circleMonster = CircleMonster(imageNamed: "mon", inX: tile.column, inY: tile.row, horizontal: tile.tag, inv: true)
                        circleMonster.zPosition = 2;
                        circleMonster.position = pointForColumn(circleMonster.xCoor, row: circleMonster.yCoor)
                        tilesLayer.addChild(circleMonster)
                    }else if(tile.tileType == TileType.Button){
                        for row in 0..<NumRows {
                            for column in 0..<NumColumns {
                                if let tileIn = myMap.tileAtColumn(column, row: row) {
                                    if(tileIn.tileType == TileType.Door && (tileIn as? Door)?.tag == (tile as? Switch)!.tag){
                                        (tileIn as? Door)?.life += 1
                                    }
                                }
                            }
                        }
                    }
                    tile.texture = SKTexture(imageNamed: tile.tileType.spriteName)
                    tile.position = pointForColumn(column, row: row)
                    tile.size = CGSize(width: TileWidth, height: TileHeight)
                    tile.zPosition = -1
                    tilesLayer.addChild(tile)
                }
            }
        }
        
        spawnPlayer(centerTile.column, inY: centerTile.row)
//        tilesLayer.size = CGSizeMake(TileWidth*CGFloat(NumColumns), TileHeight*CGFloat(NumRows))
//        tilesLayer.anchorPoint = CGPointMake(CGFloat(centerTile.column/NumColumns), CGFloat(centerTile.row/NumRows))
        let realPosition = CGPointMake(self.size.width/2 - (pointForColumn(centerTile.column, row: centerTile.row)).x, self.size.height/2 - (pointForColumn(centerTile.column, row: centerTile.row)).y)
        tilesLayer.position = realPosition
    }
    
    func centerMap(complete:()-> Void){
        let realPosition = CGPointMake(self.size.width/2 - (pointForColumn(hero.xCoor, row: hero.yCoor)).x, self.size.height/2 - (pointForColumn(hero.xCoor, row: hero.yCoor)).y)
        tilesLayer.runAction(SKAction.moveTo(realPosition, duration: 0.01)){
            complete()
        }
    }
    
    func spawnPlayer(inX : Int, inY: Int){
        hero = Hero(xd: inX, yd: inY)
        hero.anchorPoint = CGPointMake(0.5, 0.5)
        hero.position = CGPointMake(self.size.width/2, self.size.height/2)
        self.addChild(hero)
        
        
        
        let darkness = SKSpriteNode(imageNamed: "dark")
        darkness.position = hero.position
        let darknessSize = 11 - 0
        darkness.size = CGSizeMake(darkness.size.width *  CGFloat(darknessSize), darkness.size.height *  CGFloat(darknessSize))
//        addChild(darkness)
    }
    
    var myMap : Map!
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
    
    
    func gameOver(){
        isOver = true
        var cover:SKSpriteNode = SKSpriteNode(color: UIColor.blackColor(), size: self.size)
        cover.anchorPoint = CGPointMake(0.0, 0.0)
        cover.alpha = 0.0
        cover.zPosition = 5
        addChild(cover)
        
        hero.dieAnimation()
        
        var path = NSBundle.mainBundle().pathForResource("Flicker", ofType: "sks")
        var rainParticle = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        
        rainParticle.position = CGPointMake(hero.position.x,hero.position.y)
        rainParticle.name = "flick"
        rainParticle.targetNode = self
        addChild(rainParticle)
        
        self.tilesLayer.runAction(SKAction.shake(0.57, amplitudeX: 40, amplitudeY: 40)) { () -> Void in
            self.myMap.remove()
            self.hero.remove()
            self.tilesLayer.removeAllActions()
            self.tilesLayer.removeAllChildren()
            self.tilesLayer.removeFromParent()
            self.removeAllActions()
            self.removeAllChildren()
            self.startGame()
        }
//        cover.runAction(SKAction.fadeAlphaTo(0.95, duration: 0.4))
    }
    
    func clearLevel(){
        var cover:SKSpriteNode = SKSpriteNode(color: UIColor.whiteColor(), size: self.size)
        cover.anchorPoint = CGPointMake(0.0, 0.0)
        cover.alpha = 0.0
        cover.zPosition = 5
        addChild(cover)
        
        hero.dieAnimation()

//        self.tilesLayer.runAction(SKAction.shake(0.57, amplitudeX: 40, amplitudeY: 40)) { () -> Void in
//            self.myMap.remove()
//            self.hero.remove()
//            self.tilesLayer.removeAllActions()
//            self.tilesLayer.removeAllChildren()
//            self.tilesLayer.removeFromParent()
//            self.removeAllActions()
//            self.removeAllChildren()
////            self.startGame()
//        }
                cover.runAction(SKAction.fadeAlphaTo(0.70, duration: 0.4))
    }
    func didBeginContact(contact: SKPhysicsContact) {
        
        //this gets called automatically when two objects begin contact with each other
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if (contact.bodyA.categoryBitMask == BodyType.hero.rawValue && contact.bodyB.categoryBitMask == BodyType.monster.rawValue )  {
            
            gameOver()
            print("bodyA was our Bro hero, bodyB was the monster")
        } else if (contact.bodyA.categoryBitMask == BodyType.hero.rawValue && contact.bodyB.categoryBitMask == BodyType.monster.rawValue )  {
            
            gameOver()
            print("bodyB was our Bro hero, bodyA was the monster")
        } else if (contact.bodyA.categoryBitMask == BodyType.monster.rawValue && contact.bodyB.categoryBitMask == BodyType.wall.rawValue) {
            print("Contact Wall")
            let circleMon = contact.bodyA.node as! CircleMonster
            circleMon.changeDirection()
        } else if (contact.bodyA.categoryBitMask == BodyType.wall.rawValue && contact.bodyB.categoryBitMask == BodyType.monster.rawValue) {
            let circleMon = contact.bodyB.node as! CircleMonster
            circleMon.changeDirection()
            print("Wall contact")
        }
    }
    
    //MARK: - Multi
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        
//        let messageDictionary: [String: String] = ["message": textField.text]
//        
//        if appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary, toPeer: appDelegate.mpcManager.session.connectedPeers[0] as MCPeerID){
//            
//            var dictionary: [String: String] = ["sender": "self", "message": textField.text]
//            messagesArray.append(dictionary)
//            
//            self.updateTableview()
//        }
//        else{
//            println("Could not send data")
//        }
//        
//        textField.text = ""
//        
//        return true
//    }
    
    func handleMPCReceivedDataWithNotification(notification: NSNotification) {
        // Get the dictionary containing the data and the source peer from the notification.
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        
        // "Extract" the data and the source peer from the received dictionary.
        let data = receivedDataDictionary["data"] as? NSData
        let fromPeer = receivedDataDictionary["fromPeer"] as! MCPeerID
        
        // Convert the data (NSData) into a Dictionary object.
        let dataDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! Dictionary<String, String>
        
        // Check if there's an entry with the "message" key.
        if let message = dataDictionary["message"] {
            // Make sure that the message is other than "_end_chat_".
            if message != "_end_chat_"{
                // Create a new dictionary and set the sender and the received message to it.
                var messageDictionary: [String: String] = ["sender": fromPeer.displayName, "message": message]
                
                // Add this dictionary to the messagesArray array.
                messagesArray.append(messageDictionary)
                
                // Reload the tableview data and scroll to the bottom using the main thread.
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                    self.updateTableview()
                })
            }
            else{
                // In this case an "_end_chat_" message was received.
                // Show an alert view to the user.
                let alert = UIAlertController(title: "", message: "\(fromPeer.displayName) ended this chat.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let doneAction: UIAlertAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
                    self.appDelegate.mpcManager.session.disconnect()
//                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
                alert.addAction(doneAction)
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func endChat(sender: AnyObject) {
        let messageDictionary: [String: String] = ["message": "_end_chat_"]
//        if appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary, toPeer: appDelegate.mpcManager.session.connectedPeers[0] as MCPeerID){
//            self.dismissViewControllerAnimated(true, completion: { () -> Void in
//                self.appDelegate.mpcManager.session.disconnect()
//            })
//        }
    }
}


