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
//    var text: String? = ""
//    var fontColor = UIColor.blackColor()
//    var fontName =
    convenience init (text: String) {
    //init (Color: UIColor, Size: CGFloat, inX: CGFloat, inY: CGFloat, text: String) {
       // super.init (Color: Color, Size: Size, inX: inX, inY: inY, text: text)
        self.init(text: text)
        self.fontName = "Times"
        self.fontColor = UIColor.blackColor()
        self.fontSize = 20
        self.position = CGPointMake(300, 300)
        self.text = text
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}