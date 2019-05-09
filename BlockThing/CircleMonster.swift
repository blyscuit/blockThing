//
//  CircleMonster.swift
//  BlockThing
//
//  Created by Pakin Intanate on 2015-10-13.
//  Copyright © 2015 confusians. All rights reserved.
//

import SpriteKit

class TriangleMonster: Monster {
    
    override init (imageNamed: String, inX:Int,inY:Int ) {
        
        let imageTexture = SKTexture(imageNamed: "triangle")
        
        super.init(imageNamed: imageNamed, inX: inX, inY: inY)
        self.texture = nil;
        
        let circleHit = SKSpriteNode(imageNamed: imageNamed);
        circleHit.position = CGPoint(x: self.frame.size.width*1.3, y: 0);
        let body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: (imageTexture.size().width/2) )
        body.isDynamic = true
        body.affectedByGravity = false
        body.allowsRotation = false
        body.categoryBitMask = BodyType.monster.rawValue
        body.contactTestBitMask = BodyType.hero.rawValue
        body.collisionBitMask = 0
        
        circleHit.physicsBody = body
        
        self.addChild(circleHit)
        
        zPosition = 1
        
//                circleHit.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(3.15, duration: 2, delay: 0.0, usingSpringWithDamping: 10.01, initialSpringVelocity: 0)))

                circleHit.run(SKAction.repeatForever(SKAction.sequence([SKAction.rotate(byAngle: 7.15, duration: 1.6),SKAction.rotate(byAngle: 5.15, duration: 1.3).reversed()])))
        
        let path = Bundle.main.path(forResource: "Smoke", ofType: "sks")
        rainParticle = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
        
        rainParticle?.position = CGPoint(x: 0,y: 0)
        rainParticle?.name = "smoke"
        rainParticle?.zPosition = 4
        circleHit.addChild((rainParticle)!)
        
        startMoving()
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMoving(){
        anchorPoint = CGPoint(x: anchorPoint.x, y: anchorPoint.y);
                let action = SKAction.rotate(byAngle: CGFloat(M_PI), duration:1)
    
                        run(SKAction.repeatForever(action))
//        self.physicsBody?.angularDamping=0.0;
//        self.physicsBody?.applyForce(CGVectorMake(100.0, 0.0))
    }
    
}
class CircleMonster: Monster {
    var moveHorizontal: Bool
    var body: SKPhysicsBody!
    var inverse: Bool
    init(imageNamed: String, inX: Int, inY: Int, horizontal: Int, inv: Bool) {
        let imageTexture = SKTexture(imageNamed: imageNamed)
        
        body = SKPhysicsBody(circleOfRadius: (imageTexture.size().width/2))
        inverse = inv
        moveHorizontal = (horizontal==1000)
    
        super.init(imageNamed: imageNamed, inX: inX, inY: inY)
        
        body!.isDynamic = true
        body!.affectedByGravity = false
        body!.allowsRotation = false
        body!.categoryBitMask = BodyType.monster.rawValue
        body!.contactTestBitMask = BodyType.hero.rawValue
        body!.collisionBitMask = 0
        body!.linearDamping = 0
        self.physicsBody = body
        
        let path = Bundle.main.path(forResource: "Smoke", ofType: "sks")
        rainParticle = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
        
        rainParticle?.position = CGPoint(x: 0,y: 0)
        rainParticle?.name = "smoke"
        rainParticle?.zPosition = 4
        addChild((rainParticle)!)
        
        startMoving()
        zPosition = 1
        
        
    }
    func startMoving() {
        if moveHorizontal == true {
            if inverse == true {
                body!.velocity = CGVector(dx: -80, dy: 0)
                //body.applyForce(CGVectorMake(-20, 0))
            } else if inverse == false {
                body!.velocity = CGVector(dx: 80, dy: 0)
                //body.applyForce(CGVectorMake(20,0))
            }
        } else if moveHorizontal == false {
            if inverse == true {
                body!.velocity = CGVector(dx: 0, dy: -80)
                //body.applyForce(CGVectorMake(0, 2))
            } else if inverse == false {
                body!.velocity = CGVector(dx: 0, dy: 80)
            }
        }
    }
    override func changeDirection() {
        if moveHorizontal == true {
            if inverse == true {
                body!.velocity = CGVector(dx: 80, dy: 0)
                inverse = false
            } else if inverse == false {
                body!.velocity = CGVector(dx: -80, dy: 0)
                inverse = true
            }
        } else if moveHorizontal == false {
            if inverse == true {
                body!.velocity = CGVector(dx: 0, dy: 80)
                inverse = false
            } else if inverse == false {
                body!.velocity = CGVector(dx: 0, dy: -80)
                inverse = true
            }
        }
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
