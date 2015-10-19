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
    var xCoor=0
    var yCoor=0
    var key = false;
    
    init(xd: Int, yd: Int) {
        let square = SKTexture(imageNamed: "Hero")
        super.init(texture: square, color: UIColor.blackColor(), size:square.size())
        
        var body:SKPhysicsBody = SKPhysicsBody(rectangleOfSize:square.size() )
        body.dynamic = false
        body.affectedByGravity = false
        body.allowsRotation = false
        body.categoryBitMask = BodyType.hero.rawValue
        body.contactTestBitMask = BodyType.monster.rawValue
        body.collisionBitMask = 0
        
        self.physicsBody = body
        
        xCoor=xd
        yCoor=yd

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func goLeft(){
        xCoor--;
    }
    func goRight(){
        
        xCoor++;
    }
    func goUp(){
        
        yCoor++;
    }
    func goDown(){
        
        yCoor--;
        
    }
    
    func remove(){
        removeFromParent()
    }
}