//
//  Hero.swift
//  BlockThing
//
//  Created by Pakin Intanate on 10/13/15.
//  Copyright © 2015 confusians. All rights reserved.
//

import SpriteKit

import Foundation


class Hero: SKSpriteNode {
    var x=0
    var y=0
    
    init(xd: Int, yd: Int) {
        let square = SKTexture(imageNamed: "Hero")
        super.init(texture: square, color: UIColor.blackColor(), size: CGSize(width: 50, height: 50))
        physicsBody = SKPhysicsBody(rectangleOfSize: square.size())
        physicsBody!.categoryBitMask = BodyType.hero.rawValue
        physicsBody!.contactTestBitMask = BodyType.monster.rawValue
        physicsBody!.affectedByGravity = false
        physicsBody!.allowsRotation = false
        physicsBody!.dynamic = true
        
        
//        let body:SKPhysicsBody = SKPhysicsBody(rectangleOfSize:square.size())
//        body.dynamic = true
//        body.affectedByGravity = false
//        body.allowsRotation = false
//        body.collisionBitMask = BodyType.monster.rawValue
//        body.categoryBitMask = BodyType.hero.rawValue //was toRaw() in Xcode 6
//        body.contactTestBitMask = BodyType.monster.rawValue // was toRaw() in Xcode 6

       // self.physicsBody = body
        
        x=xd
        y=yd

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}