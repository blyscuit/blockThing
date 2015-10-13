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
        position = CGPointMake(xd, yd)
        square.physicsBody = SKPhysicsBody(circleOfRadius:
            (square.size.width/2))
        square.physicsBody?.usesPreciseCollisionDetection = true
        square.physicsBody?.categoryBitMask = ballCategory
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}