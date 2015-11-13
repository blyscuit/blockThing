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
class StageSelectViewController: UIViewController {
    
    @IBOutlet weak var stageButton: SpringButton!
    
    @IBOutlet weak var buttomBR: M13ProgressViewSegmentedBar!
    @IBOutlet weak var moveLabel: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var pro: M13ProgressViewBar!
    var delegate:StageSelectControllerDelegate?
    
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
        
        let dic = saveManeger.loadLevel(1)
        time.text = "\(dic["time"]!)"
        moveLabel.text = "\(Int(dic["move"]!))"
    }
    @IBAction func menuPress(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    @IBAction func stagePress(sender: AnyObject) {
        changeStageTo()
        self.performSegueWithIdentifier("game1", sender: self)
    }
    
    func changeStageTo(){
        stageButton.animation="pop"
        stageButton.force=0.76
        stageButton.animate()
    }
}
