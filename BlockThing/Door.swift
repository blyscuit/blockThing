//
//  Door.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-10-14.
//  Copyright © 2015 confusians. All rights reserved.
//

import UIKit

class Door: Tile {
    var close = true
    func flip(){
        close = !close
        walk = !close;
    }
    init(column: Int, row: Int){
        super.init(column: column, row: row, tileType: TileType.Door.rawValue)
        walk = false;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Wall: Tile {
    var close = true
    init(column: Int, row: Int){
        super.init(column: column, row: row, tileType: TileType.Wall.rawValue)
        walk = false;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
