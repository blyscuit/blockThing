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
    init(xd: CGFloat, yd: CGFloat) {
        let square = SKTexture(imageNamed: "Hero")
        super.init(texture: square, color: UIColor.blackColor(), size: CGSize(width: 50, height: 50))
        position = CGPointMake(xd, yd)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}