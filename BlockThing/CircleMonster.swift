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
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        
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
    //var velocity: CG = 0;
    var moveHorizontal = 1
    var body: SKPhysicsBody!
    override init(imageNamed: String, inX: Int, inY: Int) {
        let imageTexture = SKTexture(imageNamed: imageNamed)
        
        body = SKPhysicsBody(circleOfRadius: (imageTexture.size().width/2))
        
    
        super.init(imageNamed: imageNamed, inX: inX, inY: inY)
        
        body!.dynamic = true
        body!.affectedByGravity = false
        body!.allowsRotation = false
        body!.categoryBitMask = BodyType.hero.rawValue
        body!.contactTestBitMask = BodyType.monster.rawValue
        body!.collisionBitMask = 0
        self.physicsBody = body
        
        startMoving()
        
    }
    func startMoving() {
        if moveHorizontal == 1 {
            body.applyForce(CGVectorMake(200, 0))
        } else if moveHorizontal == 0 {
            body.applyForce(CGVectorMake(0, 200))
        }
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
