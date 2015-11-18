//
//  StageSelectViewController.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-11-10.
//  Copyright © 2015 confusians. All rights reserved.
//

import UIKit

@objc protocol StageSelectControllerDelegate {
    func stageDidChoose(i:Int)
}
class StageSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var stageButton: SpringButton!
    
    @IBOutlet weak var buttomBR: M13ProgressViewSegmentedBar!
    @IBOutlet weak var moveLabel: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet var StageTable: UITableView!
    @IBOutlet weak var pro: M13ProgressViewBar!
    var delegate:StageSelectControllerDelegate?
    
//    var stageArray = [String]()
    
    var saveManeger = SaveDataModule()
    
    override func viewDidLoad() {
//        var pro = M13ProgressViewBar()

        pro.setIndeterminate(true)
        buttomBR.setIndeterminate(true)
        buttomBR.numberOfSegments = 11
        buttomBR.cornerRadius = pro.frame.size.width/CGFloat(buttomBR.numberOfSegments)
        buttomBR.segmentShape = M13ProgressViewSegmentedBarSegmentShapeCircle
        buttomBR.primaryColors = [UIColor.darkGrayColor(),UIColor.darkGrayColor(),UIColor.darkGrayColor(),UIColor.darkGrayColor(),UIColor.darkGrayColor(),UIColor.darkGrayColor(),UIColor.darkGrayColor(),UIColor.darkGrayColor(),UIColor.darkGrayColor(),UIColor.darkGrayColor(),UIColor.darkGrayColor()]
        //        pro.segmentSeparation = 1
        pro.setPrimaryColor(UIColor.darkGrayColor())
        pro.setSecondaryColor(UIColor.lightGrayColor())
        pro.showPercentage = false
        pro.progressBarThickness = 1
//        progressView.addSubview(pro)
//        progressView.backgroundColor = UIColor.clearColor()
//        for index in 1...15 {
//            stageArray.append("Stage \(index)")
//            print(stageArray)
//        }
        let dic = saveManeger.loadLevel(1)
        time.text = "\(dic["time"]!)"
        moveLabel.text = "\(Int(dic["move"]!))"
    }
    @IBAction func menuPress(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    @IBAction func stagePress(sender: AnyObject) {
        changeStageTo(1)
        self.performSegueWithIdentifier("game1", sender: self)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("stagesth", forIndexPath: indexPath)
        cell.textLabel!.text = "Stage \(indexPath.row+1)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Row \(indexPath.row+1)")
        changeStageTo(indexPath.row+1)
        let dic = saveManeger.loadLevel(indexPath.row+1)
        time.text = "\(dic["time"]!)"
        moveLabel.text = "\(Int(dic["move"]!))"
    }

    func changeStageTo(stage:Int){
        stageButton.setTitle("Stage \(stage)", forState: UIControlState.Normal)
        stageButton.animation="pop"
        stageButton.force=0.76
        stageButton.animate()
    }
}
