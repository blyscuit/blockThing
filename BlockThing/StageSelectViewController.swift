//
//  StageSelectViewController.swift
//  BlockThing
//
//  Created by Pakin Intanate on 2015-11-10.
//  Copyright © 2015 confusians. All rights reserved.
//

import UIKit

@objc protocol StageSelectControllerDelegate {
    func stageDidChoose(_ i:Int)
}
class StageSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var stageButton: SpringButton!
    
    @IBOutlet weak var buttomBR: M13ProgressViewSegmentedBar!
    @IBOutlet weak var moveLabel: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet var StageTable: UITableView!
    @IBOutlet weak var pro: M13ProgressViewBar!
    var delegate:StageSelectControllerDelegate?
    var index: Int?
    
//    var stageArray = [String]()
    
    var saveManeger = SaveDataModule()
    
    override func viewDidLoad() {
//        var pro = M13ProgressViewBar()

        pro.setIndeterminate(true)
        buttomBR.setIndeterminate(true)
        buttomBR.numberOfSegments = 11
        buttomBR.cornerRadius = pro.frame.size.width/CGFloat(buttomBR.numberOfSegments)
        buttomBR.segmentShape = M13ProgressViewSegmentedBarSegmentShapeCircle
        buttomBR.primaryColors = [UIColor.darkGray,UIColor.darkGray,UIColor.darkGray,UIColor.darkGray,UIColor.darkGray,UIColor.darkGray,UIColor.darkGray,UIColor.darkGray,UIColor.darkGray,UIColor.darkGray,UIColor.darkGray]
        //        pro.segmentSeparation = 1
        pro.setPrimaryColor(UIColor.darkGray)
        pro.setSecondaryColor(UIColor.lightGray)
        pro.showPercentage = false
        pro.progressBarThickness = 1
//        progressView.addSubview(pro)
//        progressView.backgroundColor = UIColor.clearColor()
//        for index in 1...15 {
//            stageArray.append("Stage \(index)")
//            print(stageArray)
//        }
        let dic = saveManeger.loadLevel(1)
        time.text = NSString(format: "%.3fs", dic["time"]!) as String
        moveLabel.text = "\(Int(dic["move"]!))"
        
        changeStageTo(levelIs)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let currentLevel = UserDefaults.standard.object(forKey: "singleLevel") as? Int{
            levelIs = currentLevel + 1
        }else{
            levelIs = 1
        }
    }
    
    @IBAction func menuPress(_ sender: AnyObject) {
        self.dismiss(animated: true) { () -> Void in
            
        }
    }
    @IBAction func stagePress(_ sender: AnyObject) {
//        changeStageTo(1)
        self.performSegue(withIdentifier: "game1", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maxSingleStages
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stagesth", for: indexPath)
        cell.textLabel!.text = "Stage \(indexPath.row+1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Row \(indexPath.row+1)")
        changeStageTo(indexPath.row+1)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func changeStageTo(_ stage:Int){
        let dic = saveManeger.loadLevel(stage)
        time.text = NSString(format: "%.3fs", dic["time"]!) as String
        moveLabel.text = "\(Int(dic["move"]!))"
        
        levelIs = stage
        
        stageButton.setTitle("Stage \(stage)", for: UIControl.State())
        stageButton.animation="pop"
        stageButton.force=0.76
        stageButton.animate()
    }
}
