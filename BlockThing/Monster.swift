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
    
    let TileWidth: CGFloat = 80.0
    let TileHeight: CGFloat = 80.0
    
    init (imageNamed: String, inX:Int,inY:Int ) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        
        super.init(texture: imageTexture, color: UIColor.clearColor(), size: imageTexture.size())
        
        var body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: (imageTexture.size().width / 2.6) )
        body.dynamic = false
        body.affectedByGravity = false
        body.allowsRotation = false
        body.categoryBitMask = BodyType.monster.rawValue //was toRaw() in Xcode 6
        body.contactTestBitMask = BodyType.hero.rawValue // was toRaw() in Xcode 6
        
        self.physicsBody = body
        
        x=inX
        y=inY
        
        position = CGPointMake(CGFloat(x)*TileWidth, CGFloat(y)*TileHeight)
        
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
