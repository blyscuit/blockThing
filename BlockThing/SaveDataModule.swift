//
//  SaveDataModule.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-11-11.
//  Copyright © 2015 confusians. All rights reserved.
//

import UIKit

class SaveDataModule:NSObject {
    var saveDictionary = [String: AnyObject]()
    override init(){
        super.init()
        saveDictionary = [String: AnyObject]()
        self.loadDataDictionary()
    }
    
    func saveDataForStage(stage:Int,time:NSTimeInterval,move:Int){
        if let stageDic = saveDictionary["Stage\(stage)"]{
            var stageDictionary = stageDic as! Dictionary<String,Double>
            if(Double(move)<stageDictionary["move"]){
                stageDictionary["move"]=Double(move)
            }
            if(time<stageDictionary["time"]){
                stageDictionary["time"]=time
            }
            saveDictionary["Stage\(stage)"] = stageDictionary
        }
        else{
            var newSave = Dictionary<String,Double>()
            newSave["move"]=Double(move)
            newSave["time"]=time
            saveDictionary["Stage\(stage)"] = newSave
        }
        NSUserDefaults.standardUserDefaults().setObject(saveDictionary, forKey: "StageSave")
    }
    
    func loadDataDictionary(){
        if let saveDic:Dictionary = (NSUserDefaults.standardUserDefaults().dictionaryForKey("StageSave")){
//        if(saveDic.count>0){
            saveDictionary = saveDic
        }
    }
    
    func loadLevel(stage:Int)->[String:Double]{
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
