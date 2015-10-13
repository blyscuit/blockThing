//
//  CircleMonster.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-10-13.
//  Copyright © 2015 confusians. All rights reserved.
//

import SpriteKit

class CircleMonster: Monster {
    
    override init (imageNamed: String, inX:Int,inY:Int ) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        
        super.init(imageNamed: imageNamed, inX: inX, inY: inY)
        
        startMoving()
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMoving(){
        anchorPoint = CGPoint(x: -1, y: anchorPoint.y);
                let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
    
                runAction(SKAction.repeatActionForever(action))
    }
}
