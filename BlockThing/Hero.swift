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
        super.init(texture: square, color: UIColor.black, size:square.size())
        
        let body:SKPhysicsBody = SKPhysicsBody(rectangleOf:square.size() )
        body.isDynamic = false
        body.affectedByGravity = false
        body.allowsRotation = false
        body.categoryBitMask = BodyType.hero.rawValue
        body.contactTestBitMask = BodyType.monster.rawValue
        body.collisionBitMask = 0
        
        self.physicsBody = body
        
        xCoor=xd
        yCoor=yd
        
        let path = Bundle.main.path(forResource: "DeathParticle", ofType: "sks")
        let flickParticle = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
        
        flickParticle.position = CGPoint(x: 0,y: 0)
        flickParticle.name = "death"
        flickParticle.targetNode = self
        addChild(flickParticle)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func goLeft(){
        xCoor -= 1;
    }
    func goRight(){
        
        xCoor += 1;
    }
    func goUp(){
        
        yCoor += 1;
    }
    func goDown(){
        
        yCoor -= 1;
        
    }
    
    func dieAnimation(){
        run(SKAction.scaleTo(0.1, duration: 0.41, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 0))
    }
    
    func remove(){
        removeFromParent()
    }
}
