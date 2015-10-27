//
//  Monster.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-10-13.
//  Copyright © 2015 confusians. All rights reserved.
//

import SpriteKit

class Monster:SKSpriteNode {
    var xCoor=0;
    var yCoor=0;
    var rainParticle : SKEmitterNode?
    
    init (imageNamed: String, inX:Int,inY:Int ) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        
        super.init(texture: imageTexture, color: UIColor.clearColor(), size: imageTexture.size())
        
//        var body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: (imageTexture.size().width/2) )
//        body.dynamic = false
//        body.affectedByGravity = false
//        body.allowsRotation = false
//        body.usesPreciseCollisionDetection = true
//        body.categoryBitMask = BodyType.monster.rawValue
//        body.contactTestBitMask = BodyType.hero.rawValue
//        body.collisionBitMask = BodyType.hero.rawValue // was toRaw() in Xcode 6
//        
//        self.physicsBody = body
        
        xCoor=inX
        yCoor=inY
        
        position = CGPointMake(CGFloat(xCoor)*TileWidth, CGFloat(yCoor)*TileHeight)
        //startMovingCircle()
        
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
