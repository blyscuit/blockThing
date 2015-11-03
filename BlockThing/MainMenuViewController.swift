//
//  MainMenuViewController.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-10-25.
//  Copyright © 2015 confusians. All rights reserved.
//

import UIKit
import SpriteKit

class MainMenuViewController: UIViewController,MultiplayerPromptViewControllerDelegate {
    @IBAction func startMulti(sender: AnyObject) {
        performSegueWithIdentifier("m_multi", sender: self)
    }

    @IBOutlet var Stage: SKView!
    @IBOutlet var Esqace: UILabel!
    @IBOutlet var SlideLeft: UILabel!
    @IBOutlet var SlideRight: UILabel!
    @IBOutlet var startsingle: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let scene = GameScene(fileNamed:"GameScene") {
            scene.levelIs = "Level_main"
            // Configure the view.

            /* Sprite Kit applies additional optimizations to improve rendering performance */
            MainMenuMap.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
        
            MainMenuMap.presentScene(scene)
            
          
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet var MainMenuMap: SKView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//       self.performSegueWithIdentifier("game1", sender: self)
//    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "m_multi"){
            let mVC = segue.destinationViewController as? MultiplayerPromptViewController
            mVC?.delegate = self
        }
    }
    func multiCancel() {
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
