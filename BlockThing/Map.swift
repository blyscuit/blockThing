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
    
    fileprivate var tiles = Array2D<Tile>(columns:NumColumns, rows: NumRows)
    var texts = [Text]()
    var darknessLevel = 1;

    
    func tileAtColumn(_ column: Int, row: Int) -> Tile? {
//        assert(column >= 0 && column <= NumColumns)
//        assert(row >= 0 && row <= NumRows)
        return tiles[column, row]
    }
    
    func canMoveToTile(_ column: Int, row: Int) -> Bool {
        print(tileAtColumn(column, row: row)?.description)
        if(tileAtColumn(column, row: row)?.walk == false){
            return false
        }
        return true
    }
    
    func remove(){
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                tiles[column, row]!.removeFromParent()
            }
        }
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
            
            texts = [Text]()
            
            if let tilesArray: AnyObject = dictionary["tiles"] {
                
                NumRows = tilesArray.count
                NumColumns = (tilesArray[0] as AnyObject).count
                
                tiles = Array2D<Tile>(columns:NumColumns, rows: NumRows)
                
                // Loop through the rows...
                for (row, rowArray) in (tilesArray as! [[Float]]).enumerated() {
                    
                    // Note: In Sprite Kit (0,0) is at the bottom of the screen,
                    // so we need to read this file upside down.
                    let tileRow = NumRows - row - 1
                    
                    // Loop through the columns in the current row...
                    for (column, rawValueIn) in rowArray.enumerated() {
                        
                        let afterValue = Int((rawValueIn * 10000).truncatingRemainder(dividingBy: 10000))
                        let value = Int(rawValueIn)
                        // If the value is 1, create a tile object.
                        if value == TileType.door.rawValue {
                            tiles[column, tileRow] = Door(column: column, row: tileRow, inTag:afterValue)
                        }else if value == TileType.wall.rawValue {
                            tiles[column, tileRow] = Wall(column: column, row: tileRow)
                        }else if value == TileType.button.rawValue{
                            tiles[column,tileRow] = Switch(column: column, row: tileRow, inTag: afterValue)
                        }else if value == TileType.lava.rawValue{
                            tiles[column,tileRow] = Lava(column: column, row: tileRow)
                        }else{
                            tiles[column, tileRow] = Tile(column: column, row: tileRow, tileType: value, inTag:afterValue)
                        }
                    }
                }
            }
            
            if(dictionary["darkness"] != nil){
                if let textArray: JSON = JSON( dictionary["darkness"]!) {
                    darknessLevel = textArray.intValue
                }
            }
            
            //andy starts here
            
            if(dictionary["texts"] != nil){
                if let textArray: JSON = JSON( dictionary["texts"]!) {
                    for (index,subJson):(String, JSON) in textArray {
                        let coor=subJson["coor"].arrayObject as! [Int]
                        var size = 16
                        if(subJson["size"].exists()){
                            size = subJson["size"].intValue
                        }
                        var nText = Text(text: subJson["text"].stringValue, xd: coor[0], yd: coor[1], Size: size)
                        //Do something you want
                        texts.append(nText)
                    }
                    
                }
            }
        }
    }
}
