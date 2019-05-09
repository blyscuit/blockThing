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
    
    func goLeft(_ completion:@escaping () -> Void){
        
        let action = SKAction.moveBy(CGVector(dx: TileWidth,dy: 0), duration: dur,delay:0,usingSpringWithDamping: spring, initialSpringVelocity: 0);
        run(action, completion: { () -> Void in
            completion()
        })
    }
    func goRight(_ completion:@escaping () -> Void){
        
        let action = SKAction.moveBy(CGVector(dx: -TileWidth,dy: 0), duration: dur,delay:0,usingSpringWithDamping: spring, initialSpringVelocity: 0);
        run(action, completion: { () -> Void in
            completion()
        })
    }
    func goUp(_ completion:@escaping () -> Void) {
        
        let action = SKAction.moveBy(CGVector(dx: 0,dy: -TileHeight), duration: dur,delay:0,usingSpringWithDamping: spring, initialSpringVelocity: 0);
        run(action, completion: { () -> Void in
            completion()
        })
    }
    func goDown(_ completion:@escaping () -> Void){
        let action = SKAction.moveBy(CGVector(dx: 0,dy: TileHeight), duration: dur,delay:0,usingSpringWithDamping: spring, initialSpringVelocity: 0);
        run(action, completion: { () -> Void in
            completion()
        })
        
    }
}
