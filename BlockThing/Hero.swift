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
        
        var path = NSBundle.mainBundle().pathForResource("DeathParticle", ofType: "sks")
        var flickParticle = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        
        flickParticle.position = CGPointMake(0,0)
        flickParticle.name = "death"
        flickParticle.targetNode = self
        addChild(flickParticle)
        
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
    
    func dieAnimation(){
        runAction(SKAction.scaleTo(0.1, duration: 0.41, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 0))
    }
    
    func remove(){
        removeFromParent()
    }
}