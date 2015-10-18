//
//  MoveMap.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-10-13.
//  Copyright © 2015 confusians. All rights reserved.
//

import SpriteKit

class MoveMap: SKSpriteNode {
    let dur = 0.4
    let spring = CGFloat(10.0)
    func goLeft(){
        
        let action = SKAction.moveBy(CGVectorMake(TileWidth,0), duration: dur,delay:0,usingSpringWithDamping: spring, initialSpringVelocity: 0);
        runAction(action)
    }
    func goRight(){
        
        let action = SKAction.moveBy(CGVectorMake(-TileWidth,0), duration: dur,delay:0,usingSpringWithDamping: spring, initialSpringVelocity: 0);
        runAction(action)
    }
    func goUp(){
        
        let action = SKAction.moveBy(CGVectorMake(0,-TileHeight), duration: dur,delay:0,usingSpringWithDamping: spring, initialSpringVelocity: 0);
        runAction(action)
    }
    func goDown(){
        let action = SKAction.moveBy(CGVectorMake(0,TileHeight), duration: dur,delay:0,usingSpringWithDamping: spring, initialSpringVelocity: 0);
        runAction(action)
        
    }
}
