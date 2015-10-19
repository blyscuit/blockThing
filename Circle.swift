//
//  Circle.swift
//  BlockThing
//
//  Created by Pakin Intanate on 10/19/15.
//  Copyright © 2015 confusians. All rights reserved.
//

import Foundation
import SpriteKit


class CircleMonster: Monster {
    
    override init(imageNamed: String, inX: Int, inY: Int) {
        super.init(imageNamed: imageNamed, , )
        
        var body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: (imageTexture.size().width/2))
        body.dynamic = false
        body.affectedByGravity = false
        body.allowsRotation = false
        body.categoryBitMask = BodyType.hero.rawValue
        body.contactTestBitMask = BodyType.monster.rawValue
        body.collisionBitMask = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}