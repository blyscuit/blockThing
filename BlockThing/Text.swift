//
//  Text.swift
//  BlockThing
//
//  Created by Pakin Intanate on 10/27/15.
//  Copyright © 2015 confusians. All rights reserved.
//

import Foundation
import SpriteKit

class Text: SKLabelNode {
    var xCoor=0
    var yCoor=0
//    var text: String? = ""
//    var fontColor = UIColor.blackColor()
//    var fontName =
    init (text: String,xd: Int, yd: Int) {
    //init (Color: UIColor, Size: CGFloat, inX: CGFloat, inY: CGFloat, text: String) {
       // super.init (Color: Color, Size: Size, inX: inX, inY: inY, text: text)
        super.init()
        self.fontName = "Timeless-Normal"
        self.fontColor = UIColor.grayColor()
        self.fontSize = 40
        self.position = CGPointMake(0, 0)
        horizontalAlignmentMode = .Center
        verticalAlignmentMode = .Center
        self.text = text
        xCoor=xd
        yCoor=yd
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}