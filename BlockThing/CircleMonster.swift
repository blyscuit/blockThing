//
//  CircleMonster.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-10-13.
//  Copyright © 2015 confusians. All rights reserved.
//

import SpriteKit

class TriangleMonster: Monster {
    
    override init (imageNamed: String, inX:Int,inY:Int ) {
        
        let imageTexture = SKTexture(imageNamed: "triangle")
        
        super.init(imageNamed: imageNamed, inX: inX, inY: inY)
        self.texture = nil;
        
        var circleHit = SKSpriteNode(imageNamed: imageNamed);
        circleHit.position = CGPointMake(self.frame.size.width, 0);
        var body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: (imageTexture.size().width/2) )
        body.dynamic = true
        body.affectedByGravity = false
        body.allowsRotation = false
        body.categoryBitMask = BodyType.monster.rawValue
        body.contactTestBitMask = BodyType.hero.rawValue
        body.collisionBitMask = 0
        
        circleHit.physicsBody = body
        
        self.addChild(circleHit)
        
        startMoving()
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMoving(){
        anchorPoint = CGPoint(x: anchorPoint.x, y: anchorPoint.y);
                let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
    
                        runAction(SKAction.repeatActionForever(action))
//        self.physicsBody?.angularDamping=0.0;
//        self.physicsBody?.applyForce(CGVectorMake(100.0, 0.0))
    }
}
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
