//
//  MoveMap.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-10-13.
//  Copyright © 2015 confusians. All rights reserved.
//

import SpriteKit

class MoveMap: SKNode {
    func goLeft(){
        
        let action = SKAction.moveBy(CGVectorMake(TileWidth,0), duration: 0.4);
        runAction(action)
    }
    func goRight(){
        
        let action = SKAction.moveBy(CGVectorMake(-TileWidth,0), duration: 0.4);
        runAction(action)
    }
    func goUp(){
        
        let action = SKAction.moveBy(CGVectorMake(0,-TileHeight), duration: 0.4);
        runAction(action)
    }
    func goDown(){
        let action = SKAction.moveBy(CGVectorMake(0,TileHeight), duration: 0.4);
        runAction(action)
        
    }
}
