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
    
    @IBOutlet weak var pro: M13ProgressViewBar!
    var delegate:StageSelectControllerDelegate?
    
    override func viewDidLoad() {
//        var pro = M13ProgressViewBar()

        pro.setIndeterminate(true)
//        pro.numberOfSegments = 11
//        pro.cornerRadius = pro.frame.size.width/CGFloat(pro.numberOfSegments)
//        pro.segmentShape = M13ProgressViewSegmentedBarSegmentShapeRoundedRect
//        pro.primaryColors = [UIColor.darkGrayColor(),UIColor.darkGrayColor(),UIColor.darkGrayColor(),UIColor.darkGrayColor(),UIColor.darkGrayColor(),UIColor.darkGrayColor(),UIColor.darkGrayColor(),UIColor.darkGrayColor(),UIColor.darkGrayColor(),UIColor.darkGrayColor(),UIColor.darkGrayColor()]
        //        pro.segmentSeparation = 1
        pro.setPrimaryColor(UIColor.darkGrayColor())
        pro.setSecondaryColor(UIColor.lightGrayColor())
        pro.showPercentage = false
        pro.progressBarThickness = 1
//        progressView.addSubview(pro)
//        progressView.backgroundColor = UIColor.clearColor()
    }
}
