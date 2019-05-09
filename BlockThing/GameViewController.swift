//
//  GameViewController.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-10-12.
//  Copyright (c) 2015 confusians. All rights reserved.
//

import UIKit
import SpriteKit
import MultipeerConnectivity

class GameViewController: UIViewController,GameplayControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        var level: Map!
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.handleMPCReceivedDataWithNotification(_:)), name: NSNotification.Name(rawValue: "receivedMPCDataNotification"), object: nil)
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
//            skView.showsFPS = true
//            skView.showsNodeCount = true
//            skView.showsPhysics = true;
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            scene.delegateGame = self
            
            skView.presentScene(scene)
            
        }
        
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @objc func handleMPCReceivedDataWithNotification(_ notification: Notification) {
        // Get the dictionary containing the data and the source peer from the notification.
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        
        // "Extract" the data and the source peer from the received dictionary.
        let data = receivedDataDictionary["data"] as? Data
        let fromPeer = receivedDataDictionary["fromPeer"] as! MCPeerID
        
        // Convert the data (NSData) into a Dictionary object.
        let dataDictionary = NSKeyedUnarchiver.unarchiveObject(with: data!) as! Dictionary<String, AnyObject>
        
        // Check if there's an entry with the "message" key.
        if let message = dataDictionary["message"] {
            let messageS = message as! String
            // Make sure that the message is other than "_end_chat_".
            if messageS == "_end_chat_"{
                // In this case an "_end_chat_" message was received.
                // Show an alert view to the user.
                let alert = UIAlertController(title: "", message: "\(fromPeer.displayName) ended this chat.", preferredStyle: UIAlertController.Style.alert)
                
                let doneAction: UIAlertAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default) { (alertAction) -> Void in
                    (UIApplication.shared.delegate as! AppDelegate).mpcManager.session.disconnect()
                    self.dismiss(animated: true, completion: nil)
                }
                
                alert.addAction(doneAction)
                
                OperationQueue.main.addOperation({ () -> Void in
                    //                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
            else{
                
            }
        }
    }
    func gameDidLostConnection(){
        self.dismiss(animated: true) { () -> Void in
            
            let skView = self.view as! SKView
            skView.presentScene(nil)
//            print("LOST CONNECTION TO MJTOM")
//            let alert = UIAlertController(title: "", message: "Lost connection", preferredStyle: UIAlertControllerStyle.Alert)
//            
//            let doneAction: UIAlertAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
//                //                    self.dismissViewControllerAnimated(true, completion: nil)
//                
//            }
//            
//            alert.addAction(doneAction)
//            self.presentViewController(alert, animated: true, completion: { () -> Void in
//                
//            })
        }
    }
    func gameDidQuit() {
        self.dismiss(animated: true) { () -> Void in
            
            let skView = self.view as! SKView
            skView.presentScene(nil)
        }
    }
}
