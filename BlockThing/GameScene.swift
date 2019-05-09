//
//  GameScene.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-10-12.
//  Copyright (c) 2015 confusians. All rights reserved.
//

import SpriteKit
import MultipeerConnectivity
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

//import UIKit

enum Direction:String{
    case North = "north"
    case South = "south"
    case East = "east"
    case West = "west"
    case Death = "die"
    case Win = "win"
}

enum BodyType:UInt32 {
    
    case hero = 1
    case ground = 2
    case monster = 4
    case emptyness = 9
    case wall = 5
}

let maxSingleStages = 16;
let maxMultiStages = 210;

@objc protocol PlayerChooseControllerDelegate {
    func playerControllerDidOnePlay()
    func playerControllerDidTwoPlay()
}
@objc protocol GameplayControllerDelegate {
    func gameDidQuit()
    func gameDidLostConnection()
}

let TileWidth: CGFloat = 80.0
let TileHeight: CGFloat = 80.0

var levelIs = 1

var multi = false
var player = 1

class GameScene: SKScene,SKPhysicsContactDelegate {
    var delegatePlayer: PlayerChooseControllerDelegate?
    var delegateGame: GameplayControllerDelegate?
    
    var messagesArray: [Dictionary<String, String>] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var hero: Hero!
    var justMove = false
    var fingerPosition:CGPoint?
    var velo: CGVector!
    
    var secondHero: SKSpriteNode!
    
    var isOver = false
    
    var darkness = SKSpriteNode(imageNamed: "dark")
    
    var pauseText = SKLabelNode(fontNamed: "Timeless-Normal")
    
    // time values
    var delta:TimeInterval = TimeInterval(0)
    var last_update_time:TimeInterval = TimeInterval(0)
    
    var numberMoved = 0;
    
    var gearNode = SKNode()
    
    var friendIsFinish = 0
    
//    var isMoving = false
    
    
    override func didMove(to view: SKView) {
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.handleMPCReceivedDataWithNotification(_:)), name: NSNotification.Name(rawValue: "receivedMPCDataNotification"), object: nil)

        //let someText = Text(text: "THIS IS TOO HARD!")
        //self.addChild(someText)
        physicsWorld.contactDelegate = self
        backgroundColor = UIColor.clear
        
        
        startGame()
    }
    
    func startGame(){
        physicsWorld.speed = 0.9999
        createEffect()
        
        isOver = false
        friendIsFinish = 0
        
        //let someText = Text(Color: UIColor.blackColor(), Size: 20, inX: 300, inY: 300,text: "GG")
        //self.addChild(someText)
        
        let cover:SKSpriteNode = SKSpriteNode(color: UIColor.black, size: self.size)
        cover.zPosition = 5
        addChild(cover)
        cover.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        cover.run(SKAction.fadeAlpha(to: 0.0, duration: 0.32), completion: { () -> Void in
            cover.removeFromParent()
        }) 
        
        /* Setup your scene here */
        let levelIn = "Level_\(levelIs)"
        myMap = nil
        myMap = Map(filename: levelIn)
        addTiles()
        self.addChild(tilesLayer);
    }
    
    func createEffect(){
        if(levelIs==0){
            backgroundColor = UIColor.white
            return;
        }
        addChild(gearNode)
        var bg:SKSpriteNode = SKSpriteNode(color: UIColor(white: 1.0, alpha: 0.35), size: self.size)
        bg.zPosition = -5
        bg.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        var bgUnder:SKSpriteNode = SKSpriteNode(color: UIColor(white: 177.0/255.0, alpha: 1.0), size: self.size)
        bgUnder.zPosition = -7
        bgUnder.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        addChild(bgUnder)
        addChild(bg)
        for(var i=0;i<Randoms.randomInt(1, 5);i += 1){
        var cover:SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "gear"), color: UIColor.clear, size: CGSize(width: self.size.width, height: self.size.width))
        cover.zPosition = -6
            cover.alpha=0
        let startPosition = CGPoint(
            x: Randoms.randomCGFloat(0, self.size.width),
            y: Randoms.randomCGFloat(0, self.size.height))
        cover.run(SKAction.scale(
            to: Randoms.randomCGFloat(0.1, 0.5), duration: 0.0))
            cover.run(SKAction.sequence([SKAction.wait(forDuration: Randoms.randomDouble(1.0, 5.0)), SKAction.fadeAlpha(to: 1.0, duration: Randoms.randomDouble(3.0, 6.0))]))
        cover.position = startPosition
        let endPosition = CGPoint(
            x: Randoms.randomCGFloat(0, self.size.width),
            y: Randoms.randomCGFloat(0, self.size.height))
        let duration = Randoms.randomDouble(30.0, 50.0)
            cover.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: Randoms.randomCGFloat(0.75, 1.0), duration: 0.0))
            let moveIn = SKAction.move(to: endPosition, duration: duration)
            moveIn.timingMode = SKActionTimingMode.easeInEaseOut
            let moveOut = SKAction.move(to: startPosition, duration: duration)
            moveOut.timingMode = SKActionTimingMode.easeInEaseOut
        cover.run(SKAction.repeatForever(SKAction.sequence([moveIn,moveOut])))
        gearNode.addChild(cover)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        
       /* Called when a touch begins */
        fingerPosition = touches.first?.location(in: self)
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
//            if(myMap!.canMoveToTile(hero.xCoor, row: hero.yCoor+1)){
//                hero.goUp()
//                tilesLayer.goUp()
//                checkTile()
//            }
//            break
//        case "s":
//            if(myMap!.canMoveToTile(hero.xCoor, row: hero.yCoor-1)){
//                hero.goDown()
//                tilesLayer.goDown()
//                checkTile()
//            }
//            break
//        case "d":
//            if(myMap!.canMoveToTile(hero.xCoor+1, row: hero.yCoor)){
//                hero.goRight()
//                tilesLayer.goRight()
//                checkTile()
//            }
//            break
//        case "a":
//            if(myMap!.canMoveToTile(hero.xCoor-1, row: hero.yCoor)){
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(isPaused){
            for touch in touches {
                
                let location = touch.location(in: self)
                if (touch.tapCount > 2 && event?.allTouches!.count>=3 && multi==false){
                    isOver = true
                    self.myMap!.remove()
                    self.hero.remove()
                    self.gearNode.removeAllActions()
                    self.gearNode.removeAllChildren()
                    self.gearNode.removeFromParent()
                    self.tilesLayer.removeAllActions()
                    self.tilesLayer.removeAllChildren()
                    self.tilesLayer.removeFromParent()
                    self.removeAllActions()
                    self.removeAllChildren()
                    self.removeFromParent()
                    
                    self.toMainMenu()
                }else if (touch.tapCount > 1){
                    //                if paused{
                    pause()
                    //                }
                }
            }
        }else{
        print(event?.allTouches!.count)
        for touch in touches {
            
            let location = touch.location(in: self)
            if (touch.tapCount > 1 && event?.allTouches!.count>=2){
                //                if paused{
                pause()
                //                }
            }
            }
        }
    }
    
    var moveDistance = CGFloat(6.1)
    
    let gearDur = 0.3
    let gearSpring = CGFloat(7.0)
    let gearDivider = CGFloat(8.5)
    
    func moveUp(){
        if(myMap!.canMoveToTile(hero.xCoor, row: hero.yCoor+1)){
            centerMap(){
                //                isMoving = true
                self.gearNode.run(SKAction.moveBy(CGVector(dx: 0,dy: -TileHeight/self.gearDivider), duration: self.gearDur,delay:0,usingSpringWithDamping: self.gearSpring, initialSpringVelocity: 0))
                
                self.hero.goUp()
                self.tilesLayer.goUp(){
                    //                    self.isMoving = false
                    //                    self.centerMap();
                }
                self.sendPositionData()
                self.checkTile(self.hero.xCoor,inY: self.hero.yCoor,second: false)
            }
        }
    }
    func moveDown(){
        if(myMap!.canMoveToTile(hero.xCoor, row: hero.yCoor-1)){
            centerMap(){
                //                isMoving = true
                
                self.gearNode.run(SKAction.moveBy(CGVector(dx: 0,dy: TileHeight/self.gearDivider), duration: self.gearDur,delay:0,usingSpringWithDamping: self.gearSpring, initialSpringVelocity: 0))
                
                self.hero.goDown()
                self.tilesLayer.goDown(){
                    //                    self.isMoving = false
                    //                    self.centerMap();
                }
                self.sendPositionData()
                self.checkTile(self.hero.xCoor,inY: self.hero.yCoor,second: false)
            }
        }
    }
    func moveLeft(){
        if(myMap!.canMoveToTile(hero.xCoor-1, row: hero.yCoor)){
            centerMap(){
                //                isMoving = true
                
                self.gearNode.run(SKAction.moveBy(CGVector(dx: TileHeight/self.gearDivider,dy: 0), duration: self.gearDur,delay:0,usingSpringWithDamping: self.gearSpring, initialSpringVelocity: 0))
                
                self.hero.goLeft()
                self.tilesLayer.goLeft(){
                    //                    self.isMoving = false
                    //                    self.centerMap();
                }
                self.sendPositionData()
                self.checkTile(self.hero.xCoor,inY: self.hero.yCoor,second: false)
            }
        }
    }
    func moveRight(){
        if(myMap!.canMoveToTile(hero.xCoor+1, row: hero.yCoor)){
            self.centerMap(){
                //                isMoving = true
                self.gearNode.run(SKAction.moveBy(CGVector(dx: -TileHeight/self.gearDivider,dy: 0), duration: self.gearDur,delay:0,usingSpringWithDamping: self.gearSpring, initialSpringVelocity: 0))
                
                self.hero.goRight()
                self.tilesLayer.goRight(){
                    //                    self.isMoving = false
                    
                }
                self.sendPositionData()
                self.checkTile(self.hero.xCoor,inY: self.hero.yCoor,second: false)
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(justMove||isOver||friendIsFinish>=2){return;}
        
        let distanceX = abs((touches.first?.location(in: self).x)! - (fingerPosition?.x)!)
        let distanceY = abs((touches.first?.location(in: self).y)! - (fingerPosition?.y)!)
        
        if(touches.first?.location(in: self).x > (fingerPosition?.x)!+moveDistance && distanceX > distanceY){
            if(myMap!.canMoveToTile(hero.xCoor+1, row: hero.yCoor)){
                moveRight()
//                sendOnlineData(Direction.East)
//                sendPositionData()
            }
            justMove = true;
        }else if(touches.first?.location(in: self).x < (fingerPosition?.x)!-moveDistance && distanceX > distanceY){
            if(myMap!.canMoveToTile(hero.xCoor-1, row: hero.yCoor)){
                moveLeft()
//                sendOnlineData(Direction.West)
//                sendPositionData()
            }
            justMove = true;
        }else if(touches.first?.location(in: self).y > (fingerPosition?.y)!+moveDistance && distanceX < distanceY){
            if(myMap!.canMoveToTile(hero.xCoor, row: hero.yCoor+1)){
                moveUp()
//                sendOnlineData(Direction.North)
//                sendPositionData()
            }
            justMove = true;
        }else if(touches.first?.location(in: self).y < (fingerPosition?.y)!-moveDistance && distanceX < distanceY){
            if(myMap!.canMoveToTile(hero.xCoor, row: hero.yCoor-1)){
                moveDown()
                //                sendOnlineData(Direction.North)
                //                sendPositionData()
            }
            justMove = true;
        }
        
    }
   
    func sendPositionData(){
        let messageDictionary: [String: [Int]] = ["location": [hero.xCoor,hero.yCoor]]
        
        print(messageDictionary)
        
        if(appDelegate.mpcManager.session.connectedPeers.count>0){
            if appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary as Dictionary<String, AnyObject>, toPeer: appDelegate.mpcManager.session.connectedPeers[0] as MCPeerID){
                
//                var dictionary: [String: AnyObject] = ["sender": "self", "message": [hero.x,hero.y]]
//                messagesArray.append(dictionary)
                
            }
            else{
                print("Could not send data")
            }
        }
    }
    func sendOnlineData(_ direct:Direction){
        let messageDictionary: [String: String] = ["message": direct.rawValue]
        
        if(appDelegate.mpcManager.session.connectedPeers.count>0){
        if appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary as Dictionary<String, AnyObject>, toPeer: appDelegate.mpcManager.session.connectedPeers[0] as MCPeerID){
            
            var dictionary: [String: String] = ["sender": "self", "message": direct.rawValue]
//            messagesArray.append(dictionary)
            
        }
        else{
            print("Could not send data")
        }
        }
    }
    
    func checkTile(_ inX:Int,inY:Int,second:Bool){
        if(levelIs==0){
            cancelMenuGoto()
        }
        if second{
            multi = true
        }
        
        if(myMap == nil){
            return
        }
        
        numberMoved += 1;
        
        if let tile = myMap!.tileAtColumn(inX, row: inY) {
            if(tile.tileType == TileType.lava){
                print("Fall in lava")
                gameOver()
            }else if(tile.tileType == TileType.exit){
                if multi{
                    friendIsFinish += 1;
                    if friendIsFinish==2{
                        clearLevel()
//                        if friendIsFinish{
////                            self.sendPositionData()
////                            clearLevel()
//                        }else{
//                            friendIsFinish = true
//                        }
//                    }else{
//                        isOver = true
//                        self.sendPositionData()
//                        if friendIsFinish{
//                            clearLevel()
//                        }else{
//                            
//                        }
                    }
                    
                    var cover:SKSpriteNode = SKSpriteNode(color: UIColor.white, size: self.size)
                    cover.anchorPoint = CGPoint(x: 0.0, y: 0.0)
                    cover.alpha = 0.0
                    cover.zPosition = 5
                    addChild(cover)
                    cover.run(SKAction.fadeAlpha(to: 0.70, duration: 0.4), completion: { () -> Void in
                        cover.removeAllChildren()
                        cover.removeFromParent()
                    })
                    if (second == true && secondHero != nil){
                        secondHero.run(SKAction.scaleTo(0.1, duration: 0.41, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 0))
                    }else{
                        hero.dieAnimation()
                        isOver=true
                    }
                }else{
                    clearLevel()
                }
//                clearLevel()
            }else if(tile.tileType == TileType.button){
                (tile as? Switch)?.flip()
                if((tile as? Switch)?.tag != 0){
                    for row in 0..<NumRows {
                        for column in 0..<NumColumns {
                            if let tiles = myMap!.tileAtColumn(column, row: row) as? Door {
                                if(tiles.tileType == TileType.door && tiles.tag == (tile as? Switch)?.tag){
                                    tiles.flip(((tile as? Switch)?.close)!)
                                }
                            }
                        }
                    }
                }
            }else if(tile.tileType == TileType.darknessTile){
                if((tile).tag != 0){
                    darknessExpantTo(Double(tile.tag)/100)
                }
            }else if(tile.tileType == TileType.twoPlay){
                gotoTwoPlay()
            }else if(tile.tileType == TileType.onePlay){
                gotoOnePlay()
            }
        }
    }
    
    func pause() {
        if(levelIs==0){return;}
        pauseText.text = "Paused!"
        pauseText.fontSize = 50
        pauseText.fontColor = UIColor.gray
        pauseText.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        if isPaused == false {
            self.addChild(pauseText)
        } else if isPaused == true {
            pauseText.removeFromParent()
        }
        isOver = !isPaused
        isPaused = !isPaused
    }

    func gotoTwoPlay(){
        let cover:SKSpriteNode = SKSpriteNode(color: UIColor.white, size: self.size)
        cover.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        cover.alpha = 0.0
        cover.zPosition = 5
        cover.name = "coverNode"
        addChild(cover)
        
        
        cover.run(SKAction.fadeAlpha(to: 0.70, duration: 0.94), completion: { () -> Void in
            self.hero.dieAnimation()
            self.run(SKAction.wait(forDuration: 0.1), completion: { () -> Void in
                self.delegatePlayer?.playerControllerDidTwoPlay()
            })
        }) 
    }
    
    func gotoOnePlay(){
        let cover:SKSpriteNode = SKSpriteNode(color: UIColor.white, size: self.size)
        cover.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        cover.alpha = 0.0
        cover.zPosition = 5
        cover.name = "coverNode"
        addChild(cover)
        
        
        cover.run(SKAction.fadeAlpha(to: 0.70, duration: 0.94), completion: { () -> Void in
            self.hero.dieAnimation()
            self.run(SKAction.wait(forDuration: 0.1), completion: { () -> Void in
                self.delegatePlayer?.playerControllerDidOnePlay()
            })
        }) 
    }
    
    func cancelMenuGoto(){
        if let cover = childNode(withName: "coverNode"){
            cover.removeAllActions();
            cover.run(SKAction.fadeAlpha(to: 0.00, duration: 0.3), completion: { () -> Void in
                cover.removeFromParent()
            }) 
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        if self.last_update_time == 0.0 {
            self.delta = 0
            self.last_update_time = currentTime
        } else {
            self.delta = currentTime - self.last_update_time
        }
        //print(self.delta)
        
    }
    
    let tilesLayer = MoveMap()
    
    func addTiles() {
        var centerTile:Tile!
        var centerSecond:Tile!
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let tile = myMap!.tileAtColumn(column, row: row) {
                    if(tile.tileType == TileType.birth){
                        if(player == 1){
                            centerTile = tile
                        }else if(player == 2){
                            centerSecond = tile
                        }
                    }else if(tile.tileType == TileType.second){// && multi == true){
                        multi = true
                        if(player == 2){
                            centerTile = tile
                        }else if(player == 1){
                            centerSecond = tile
                        }
                    }else if(tile.tileType == TileType.monster){
                        let triangleMonster = TriangleMonster(imageNamed: "triangle", inX: tile.column, inY: tile.row)
                        triangleMonster.zPosition = 2;
                        triangleMonster.position = pointForColumn(triangleMonster.xCoor, row: triangleMonster.yCoor)
                        triangleMonster.rainParticle?.targetNode = (tilesLayer)
                        tilesLayer.addChild(triangleMonster)
                    }else if(tile.tileType == TileType.circleMon){
                        let circleMonster = CircleMonster(imageNamed: "mon", inX: tile.column, inY: tile.row, horizontal: tile.tag, inv: true)
                        circleMonster.zPosition = 2;
                        circleMonster.position = pointForColumn(circleMonster.xCoor, row: circleMonster.yCoor)
                        circleMonster.rainParticle?.targetNode = (tilesLayer)
                        tilesLayer.addChild(circleMonster)
                    }else if(tile.tileType == TileType.button){
                        for row in 0..<NumRows {
                            for column in 0..<NumColumns {
                                if let tileIn = myMap!.tileAtColumn(column, row: row) {
                                    if(tileIn.tileType == TileType.door && (tileIn as? Door)?.tag == (tile as? Switch)!.tag){
                                        (tileIn as? Door)?.life += 1
                                    }
                                }
                            }
                        }
                    }
                    
                    tile.texture = SKTexture(imageNamed: tile.tileType.spriteName)
                    if tile.tileType.spriteName == "plain"{
                        tile.texture = nil
                    }
                    tile.position = pointForColumn(column, row: row)
                    tile.size = CGSize(width: TileWidth, height: TileHeight)
                    tile.zPosition = -2
                    tilesLayer.addChild(tile)
                }
            }
        }
        
        addText()
        
        if(multi && centerSecond != nil){
            let square = SKTexture(imageNamed: "player2")
            secondHero = SKSpriteNode(texture: square)
            secondHero.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            secondHero.position = centerSecond.position // pointForColumn(column, row: row)
            secondHero.zPosition = -1
            tilesLayer.addChild(secondHero)
        }
        
        spawnPlayer(centerTile.column, inY: centerTile.row)
//        tilesLayer.size = CGSizeMake(TileWidth*CGFloat(NumColumns), TileHeight*CGFloat(NumRows))
//        tilesLayer.anchorPoint = CGPointMake(CGFloat(centerTile.column/NumColumns), CGFloat(centerTile.row/NumRows))
        let realPosition = CGPoint(x: self.size.width/2 - (pointForColumn(centerTile.column, row: centerTile.row)).x, y: self.size.height/2 - (pointForColumn(centerTile.column, row: centerTile.row)).y)
        tilesLayer.position = realPosition
    }
    
    func addText(){
        for text in myMap!.texts{
            text.position = pointForColumn(text.xCoor, row: NumRows - text.yCoor)
            text.zPosition = -1
            tilesLayer.addChild(text)
        }
    }
    
    func centerMap(_ complete:@escaping ()-> Void){
        let realPosition = CGPoint(x: self.size.width/2 - (pointForColumn(hero.xCoor, row: hero.yCoor)).x, y: self.size.height/2 - (pointForColumn(hero.xCoor, row: hero.yCoor)).y)
        tilesLayer.run(SKAction.move(to: realPosition, duration: 0.0000), completion: {
            complete()
        })
    }
    
    func spawnPlayer(_ inX : Int, inY: Int){
        hero = Hero(xd: inX, yd: inY)
        hero.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        hero.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(hero)
        
        
        if(levelIs != 0){
            darkness = SKSpriteNode(imageNamed: "dark")
            darkness.position = hero.position
            darkness.zPosition = 10
            let darknessSize = myMap!.darknessLevel;
            darknessExpantTo(Double(darknessSize))
            darkness.size = CGSize(width: darkness.size.width *  CGFloat(11.5), height: darkness.size.height *  CGFloat(11.5))
            addChild(darkness)
        }
        
    }
    
    func darknessExpantTo(_ darknessSize:Double){
        darkness.run(SKAction.scaleTo(CGFloat(Double(12.0-darknessSize)/11.0), duration: 2.1, delay: 0.0, usingSpringWithDamping: 0.01, initialSpringVelocity: 0.0), completion: { () -> Void in
        })
        darkness.run(SKAction.fadeAlpha(to: CGFloat(Double(darknessSize+1.8)/11.0), duration: 0.3))
    }
    
    var myMap : Map?
    
    func pointForColumn(_ column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
    
    
    func gameOver(){
        if((multi == false && isOver == true)||(multi == true && isOver == true && friendIsFinish>=2)){
            return
        }
        friendIsFinish = 3
        isOver = true
        myMap=nil
        
        sendOnlineData(Direction.Death)
        
        var cover:SKSpriteNode = SKSpriteNode(color: UIColor.black, size: self.size)
        cover.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        cover.alpha = 0.0
        cover.zPosition = 5
        addChild(cover)
        
        hero.dieAnimation()
        
        var path = Bundle.main.path(forResource: "Flicker", ofType: "sks")
        var rainParticle = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
        
        rainParticle.position = CGPoint(x: hero.position.x,y: hero.position.y)
        rainParticle.name = "flick"
        rainParticle.targetNode = self
        addChild(rainParticle)
        
        self.tilesLayer.run(SKAction.shake(0.57, amplitudeX: 40, amplitudeY: 40), completion: { () -> Void in
//            self.myMap!.remove()
            self.hero.remove()
            self.gearNode.removeAllActions()
            self.gearNode.removeAllChildren()
            self.gearNode.removeFromParent()
            self.tilesLayer.removeAllActions()
            self.tilesLayer.removeAllChildren()
            self.tilesLayer.removeFromParent()
            self.removeAllActions()
            self.removeAllChildren()
            self.startGame()
        }) 
//        cover.runAction(SKAction.fadeAlphaTo(0.95, duration: 0.4))
    }
    
    func clearLevel(){
        if(multi == false){
            UserDefaults.standard.set(levelIs, forKey: "singleLevel")
        }else{
            if(player == 1){
                UserDefaults.standard.set(levelIs, forKey: "multiLevel")
            }
        }
        var saveManager = SaveDataModule()
        saveManager.saveDataForStage(levelIs, time: delta, move: numberMoved)
        
        if(isOver == true){
            if(multi == true && friendIsFinish>=3){
                return
            }else if(multi == false){
                return
            }
        }
        
        levelIs += 1;
        var cover:SKSpriteNode = SKSpriteNode(color: UIColor.white, size: self.size)
        cover.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        cover.alpha = 0.0
        cover.zPosition = 5
        addChild(cover)
        
        hero.dieAnimation()

        isOver = true
        myMap=nil
        
        cover.run(SKAction.fadeAlpha(to: 0.70, duration: 0.4), completion: { () -> Void in
//            self.myMap!.remove()
            self.hero.remove()
            self.gearNode.removeAllActions()
            self.gearNode.removeAllChildren()
            self.gearNode.removeFromParent()
            self.tilesLayer.removeAllActions()
            self.tilesLayer.removeAllChildren()
            self.tilesLayer.removeFromParent()
            self.removeAllActions()
            self.removeAllChildren()
            if(multi == false){
                if(levelIs<=maxSingleStages){
                    self.startGame()
                }else{
                    self.toMainMenu()
                }
            }else{
                if(levelIs<=maxMultiStages){
                    self.startGame()
                }else{
                    
                    self.toMainMenu()
                }
            }
        }) 
    }
    func didBegin(_ contact: SKPhysicsContact) {
        
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
            let circleMon = contact.bodyA.node as! Monster
            circleMon.changeDirection()
        } else if (contact.bodyA.categoryBitMask == BodyType.wall.rawValue && contact.bodyB.categoryBitMask == BodyType.monster.rawValue) {
            if(contact.bodyB.node as? CircleMonster != nil){
            let circleMon = contact.bodyB.node as! CircleMonster
            circleMon.changeDirection()
            print("Wall contact")
            }
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
    
    func handleMPCReceivedDataWithNotification(_ notification: Notification) {
        // Get the dictionary containing the data and the source peer from the notification.
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        
        // "Extract" the data and the source peer from the received dictionary.
        let data = receivedDataDictionary["data"] as? Data
        let fromPeer = receivedDataDictionary["fromPeer"] as! MCPeerID
        
        // Convert the data (NSData) into a Dictionary object.
        let dataDictionary = NSKeyedUnarchiver.unarchiveObject(with: data!) as! Dictionary<String, AnyObject>
        
        // Check if there's an entry with the "message" key.
        if let message = dataDictionary["message"]{
            let messageS = message as! String
            // Make sure that the message is other than "_end_chat_".
            if messageS != "_end_chat_"{
                // Create a new dictionary and set the sender and the received message to it.
//                var messageDictionary: [String: String] = ["sender": fromPeer.displayName, "message": messageS]
                
                // Add this dictionary to the messagesArray array.
//                messagesArray.append(messageDictionary)
                if messageS == Direction.North.rawValue{
                    moveUp()
                }else if messageS == Direction.East.rawValue{
                    moveRight()
                }else if messageS == Direction.West.rawValue{
                    moveLeft()
                }else if messageS == Direction.South.rawValue{
                    moveDown()
                }else if messageS == Direction.Death.rawValue{
                    gameOver()
                }
                
                // Reload the tableview data and scroll to the bottom using the main thread.
                OperationQueue.main.addOperation({ () -> Void in
//                    self.updateTableview()
                })
            }
            else{
                // In this case an "_end_chat_" message was received.
                // Show an alert view to the user.
//                let alert = UIAlertController(title: "", message: "\(fromPeer.displayName) ended this chat.", preferredStyle: UIAlertControllerStyle.Alert)
//                
//                let doneAction: UIAlertAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
//                    self.appDelegate.mpcManager.session.disconnect()
////                    self.dismissViewControllerAnimated(true, completion: nil)
//                    
//                }
//                
//                alert.addAction(doneAction)
                
//                self.myMap!.remove()
//                self.hero.remove()
//                self.tilesLayer.removeAllActions()
//                self.tilesLayer.removeAllChildren()
//                self.tilesLayer.removeFromParent()
//                self.removeAllActions()
//                self.removeAllChildren()
                
                isOver = true
                self.appDelegate.mpcManager.session.disconnect()
                OperationQueue.main.addOperation({ () -> Void in
                    //                    self.presentViewController(alert, animated: true, completion: nil)
                    self.delegateGame?.gameDidLostConnection()
                })
                
            }
        }else if let message = dataDictionary["location"]{
            let messageI = message as! [Int]
            if messageI.count == 2 {
                messageI[0]
                checkTile(Int(messageI[0]),inY: Int(messageI[1]),second:true)
                if(myMap != nil){
                    if let tile = myMap!.tileAtColumn(Int(messageI[0]), row: Int(messageI[1])){
                        if secondHero != nil{
                            secondHero.position  = tile.position
                        }
                    }
                }
//                secondHero.position = (myMap!.tileAtColumn(Int(messageI[0]), row: Int(messageI[1]))?.position)!
            }
        }
    }
    
    func toMainMenu(){
        self.delegateGame?.gameDidQuit()
    }
}


