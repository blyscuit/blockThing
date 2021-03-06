//
//  MainMenuViewController.swift
//  BlockThing
//
//  Created by Pakin Intanate on 2015-10-25.
//  Copyright © 2015 confusians. All rights reserved.
//

import UIKit
import SpriteKit

class MainMenuViewController: UIViewController,MultiplayerPromptViewControllerDelegate,PlayerChooseControllerDelegate,StageSelectControllerDelegate {
    @IBAction func startMulti(_ sender: AnyObject) {
        performSegue(withIdentifier: "m_multi", sender: self)
    }

    
    @IBOutlet var stage: UIView!
    @IBOutlet var startsingle: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        if let scene = GameScene(fileNamed:"GameScene") {
//            levelIs = 0
//            // Configure the view.
//
//            /* Sprite Kit applies additional optimizations to improve rendering performance */
//            MainMenuMap.ignoresSiblingOrder = true
//            
//            /* Set the scale mode to scale to fit the window */
//            scene.scaleMode = .AspectFill
//        
//            MainMenuMap.presentScene(scene)
//            scene.delegatePlayer = self
//            
//          
//        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            MainMenuMap.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            levelIs = 0
            multi = false
            
            MainMenuMap.presentScene(scene)
            
            scene.delegatePlayer = self
            
            
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
//        multi = false
//        self.performSegueWithIdentifier("game1", sender: self)
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "m_multi"){
            let mVC = segue.destination as? MultiplayerPromptViewController
            mVC?.delegate = self
        }
    }
    func multiCancel() {
        self.dismiss(animated: true) { () -> Void in
        }
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func playerControllerDidOnePlay() {
        multi = false
                if let currentLevel = UserDefaults.standard.object(forKey: "singleLevel") as? Int{
                    levelIs = currentLevel + 1
                }else{
                    levelIs = 1
        }
        
        MainMenuMap.scene?.removeAllActions()
        MainMenuMap.scene?.removeAllChildren()
        MainMenuMap.scene?.removeFromParent()
            self.performSegue(withIdentifier: "stageSelect_m", sender: self)
//        self.performSegueWithIdentifier("game1", sender: self)
        
    }
    func playerControllerDidTwoPlay() {
        MainMenuMap.scene?.removeAllActions()
        MainMenuMap.scene?.removeAllChildren()
        MainMenuMap.scene?.removeFromParent()
        performSegue(withIdentifier: "m_multi", sender: self)
    }

    func stageDidChoose(_ i: Int) {
        performSegue(withIdentifier: "game1", sender: self)
        
    }
}
