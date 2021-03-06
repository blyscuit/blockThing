//
//  MultiplayerPromptViewController.swift
//  BlockThing
//
//  Created by Bliss Watchaye on 2015-10-23.
//  Copyright © 2015 confusians. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol MultiplayerPromptViewControllerDelegate {
    func multiCancel()
}

class MultiplayerPromptViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MPCManagerDelegate// ,MCSessionDelegate,MCBrowserViewControllerDelegate
{
    var delegate:MultiplayerPromptViewControllerDelegate?
    @IBOutlet weak var tableMulti: UITableView!
    let playerService = PlayerServiceManager()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBAction func cancelMulti(_ sender: AnyObject) {
        delegate?.multiCancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableMulti.delegate = self
        tableMulti.dataSource = self
        
        if let currentLevel = UserDefaults.standard.object(forKey: "multiLevel") as? Int{
            levelIs = currentLevel + 1
        }else{
            levelIs = 201
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appDelegate.mpcManager.refreshStatus()
        
        appDelegate.mpcManager.delegate = self
        appDelegate.mpcManager.browser.startBrowsingForPeers()
        
        appDelegate.mpcManager.advertiser.startAdvertisingPeer()
        
        if let currentLevel = UserDefaults.standard.object(forKey: "multiLevel") as? Int{
            levelIs = currentLevel + 1
        }else{
            levelIs = 201
        }
        levelLabel.text = "Level \(levelIs-200)"
    }
    
    @IBAction func startStopAdvertising(_ sender: AnyObject) {
        let actionSheet = UIAlertController(title: "", message: "Change Visibility", preferredStyle: UIAlertController.Style.actionSheet)
        
        let actionTitle: String = ""
        
        let visibilityAction: UIAlertAction = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default) { (alertAction) -> Void in
                self.appDelegate.mpcManager.advertiser.stopAdvertisingPeer()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (alertAction) -> Void in
            
        }
        
        actionSheet.addAction(visibilityAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func foundPeer() {
        tableMulti.reloadData()
    }
    
    
    func lostPeer() {
        tableMulti.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.mpcManager.foundPeers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellPeer")
        let fullName = appDelegate.mpcManager.foundPeers[indexPath.row].displayName
        let fullNameArr = fullName.components(separatedBy: ":")
        
        cell!.textLabel?.text = fullNameArr[0]
        cell!.detailTextLabel?.text = fullNameArr[1]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPeer = appDelegate.mpcManager.foundPeers[indexPath.row] as MCPeerID
        
        appDelegate.mpcManager.browser.invitePeer(selectedPeer, to: appDelegate.mpcManager.session, withContext: nil, timeout: 20)
        
        player = 1
    }
    
    func invitationWasReceived(_ fromPeer: String,level:Int) {
        let alert = UIAlertController(title: "", message: "\(fromPeer) wants to play with you.", preferredStyle: UIAlertController.Style.alert)
        
        print("level isssss \(level)")
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertAction.Style.default) { (alertAction) -> Void in
            player = 2
            levelIs = 200+level
            self.appDelegate.mpcManager.invitationHandler(true, self.appDelegate.mpcManager.session)
        }
        
        let declineAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (alertAction) -> Void in
            self.tableMulti.reloadData()
            self.appDelegate.mpcManager.invitationHandler(false, self.appDelegate.mpcManager.session)
        }
        
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        OperationQueue.main.addOperation { () -> Void in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func connectedWithPeer(_ peerID: MCPeerID) {
        OperationQueue.main.addOperation { () -> Void in
            multi = true
            self.performSegue(withIdentifier: "game2", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "game2"){
        }
    }
    
    
//    var peerID: MCPeerID!
//    var mcSession: MCSession!
//    var mcAdvertiserAssistant: MCAdvertiserAssistant!
//    func showConnectionPrompt() {
//        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .ActionSheet)
//        ac.addAction(UIAlertAction(title: "Host a session", style: .Default, handler: startHosting))
//        ac.addAction(UIAlertAction(title: "Join a session", style: .Default, handler: joinSession))
//        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
//        presentViewController(ac, animated: true, completion: nil)
//    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
//    @IBAction func multiPress(sender: AnyObject) {
//        showConnectionPrompt()
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
//        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .Required)
//        mcSession.delegate = self
//        
//        // Do any additional setup after loading the view.
//    }
//    
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func startHosting(action: UIAlertAction!) {
//        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
//        mcAdvertiserAssistant.start()
//    }
//    
//    func joinSession(action: UIAlertAction!) {
//        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
//        mcBrowser.delegate = self
//        presentViewController(mcBrowser, animated: true, completion: nil)
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//    
//    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
//        
//    }
//    
//    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
//        
//    }
//    
//    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
//        
//    }
//    
//    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
//        switch state {
//        case MCSessionState.Connected:
//            print("Connected: \(peerID.displayName)")
//            
//        case MCSessionState.Connecting:
//            print("Connecting: \(peerID.displayName)")
//            
//        case MCSessionState.NotConnected:
//            print("Not Connected: \(peerID.displayName)")
//        }
//    }
//    
//    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
////        if let image = UIImage(data: data) {
////            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
////                self.images.insert(image, atIndex: 0)
////                self.collectionView.reloadData()
////            }
////        }
//    }
//    
//    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
//        dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
//        dismissViewControllerAnimated(true, completion: nil)
//    }
//

}
