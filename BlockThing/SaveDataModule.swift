//
//  SaveDataModule.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-11-11.
//  Copyright © 2015 confusians. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class SaveDataModule:NSObject {
    var saveDictionary = [String: AnyObject]()
    override init(){
        super.init()
        saveDictionary = [String: AnyObject]()
        self.loadDataDictionary()
    }
    
    func saveDataForStage(_ stage:Int,time:TimeInterval,move:Int){
        if let stageDic = saveDictionary["Stage\(stage)"]{
            var stageDictionary = stageDic as! Dictionary<String,Double>
            if(Double(move)<stageDictionary["move"]){
                stageDictionary["move"]=Double(move)
            }
            if(time<stageDictionary["time"]){
                stageDictionary["time"]=time
            }
            saveDictionary["Stage\(stage)"] = stageDictionary as AnyObject
        }
        else{
            var newSave = Dictionary<String,Double>()
            newSave["move"]=Double(move)
            newSave["time"]=time
            saveDictionary["Stage\(stage)"] = newSave as AnyObject
        }
        UserDefaults.standard.set(saveDictionary, forKey: "StageSave")
    }
    
    func loadDataDictionary(){
        if let saveDic:Dictionary = (UserDefaults.standard.dictionary(forKey: "StageSave")){
//        if(saveDic.count>0){
            saveDictionary = saveDic as [String : AnyObject]
        }
    }
    
    func loadLevel(_ stage:Int)->[String:Double]{
        loadDataDictionary()
        if let stageDic = saveDictionary["Stage\(stage)"]{
            return stageDic as! [String : Double]
        }else{
            
            var newSave = Dictionary<String,Double>()
            newSave["move"]=Double(0)
            newSave["time"]=0
            return newSave
        }
    }
}
