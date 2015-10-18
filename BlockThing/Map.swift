//
//  Map.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-10-13.
//  Copyright © 2015 confusians. All rights reserved.
//

import UIKit


var NumColumns = 30
var NumRows = 40

class Map {
    
    private var tiles = Array2D<Tile>(columns:NumColumns, rows: NumRows)

    
    func tileAtColumn(column: Int, row: Int) -> Tile? {
//        assert(column >= 0 && column <= NumColumns)
//        assert(row >= 0 && row <= NumRows)
        return tiles[column, row]
    }
    
    func canMoveToTile(column: Int, row: Int) -> Bool {
        print(tileAtColumn(column, row: row)?.description)
        if(tileAtColumn(column, row: row)?.walk == false){
            return false
        }
        return true
    }
    
    init(filename: String) {
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename) {
//            if let columnN: AnyObject = dictionary["column"]{
//                NumColumns = columnN.integerValue
//            }
//            if let rowN: AnyObject = dictionary["row"]{
//                NumRows = rowN.integerValue
//            }
            
            // The dictionary contains an array named "tiles". This array contains
            // one element for each row of the level. Each of those row elements in
            // turn is also an array describing the columns in that row. If a column
            // is 1, it means there is a tile at that location, 0 means there is not.
            if let tilesArray: AnyObject = dictionary["tiles"] {
                
                NumRows = tilesArray.count
                NumColumns = tilesArray[0].count
                
                tiles = Array2D<Tile>(columns:NumColumns, rows: NumRows)
                
                // Loop through the rows...
                for (row, rowArray) in (tilesArray as! [[Int]]).enumerate() {
                    
                    // Note: In Sprite Kit (0,0) is at the bottom of the screen,
                    // so we need to read this file upside down.
                    let tileRow = NumRows - row - 1
                    
                    // Loop through the columns in the current row...
                    for (column, value) in rowArray.enumerate() {
                        
                        // If the value is 1, create a tile object.
                        if value == TileType.Door.rawValue {
                            tiles[column, tileRow] = Door(column: column, row: tileRow)
                        }else if value == TileType.Wall.rawValue {
                            tiles[column, tileRow] = Wall(column: column, row: tileRow)
                        }else{
                            tiles[column, tileRow] = Tile(column: column, row: tileRow, tileType: value)
                        }
                    }
                }
            }
        }
    }
}
