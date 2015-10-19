//
//  Monster.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-10-13.
//  Copyright © 2015 confusians. All rights reserved.
//

import SpriteKit

class Monster:SKSpriteNode {
    var x=0;
    var y=0;
    init (imageNamed: String, inX:Int,inY:Int ) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        
        super.init(texture: imageTexture, color: UIColor.clearColor(), size: imageTexture.size())
        
        var body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: (imageTexture.size().width/2) )
        body.dynamic = false
        body.affectedByGravity = false
        body.allowsRotation = false
        body.usesPreciseCollisionDetection = true
        body.categoryBitMask = BodyType.monster.rawValue
        body.contactTestBitMask = BodyType.hero.rawValue
        body.collisionBitMask = BodyType.hero.rawValue // was toRaw() in Xcode 6
       
        self.physicsBody = body
        
        x=inX
        y=inY
        
        position = CGPointMake(CGFloat(x)*TileWidth, CGFloat(y)*TileHeight)
        //startMovingCircle()
        
        
    }
//    func MoveDirection () {
//        
//    }
//    func startMovingCircle () {
//        var path = CGPathCreateMutable()
//        CGPathMoveToPoint(path, nil, startingx, startingy)
//        CGPathAddLineToPoint(path, nil, endx, endy)
//        var followLine = SKAction.followPath(path, asOffset: true, orientToPath: false, duration: 5.0)
//        var reversedLine = followLine.reversedAction()
//        runAction(SKAction.sequence([followLine,reversedLine]))
//    }
//    func moveUp() {
//        
//    }
//    func moveRight() {
//        
//    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
