
import Foundation
import MultipeerConnectivity

//protocol PlayerServiceManagerDelegate {
//    
//    func connectedDevicesChanged(manager : PlayerServiceManager, connectedDevices: [String])
//    func colorChanged(manager : PlayerServiceManager, colorString: String)
//    
//}
protocol MPCManagerDelegate {
    func foundPeer()
    
    func lostPeer()
    
    func invitationWasReceived(fromPeer: String,level:Int)
    
    func connectedWithPeer(peerID: MCPeerID)
    
//    func lostConnection()
}
class PlayerServiceManager : NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate
 {
    var session: MCSession!
    
    var peer: MCPeerID!
    
    var browser: MCNearbyServiceBrowser!
    
    var advertiser: MCNearbyServiceAdvertiser!
    var foundPeers = [MCPeerID]()
    
    var invitationHandler: ((Bool, MCSession)->Void)!
    
    var connectedPeer: MCPeerID!
    
    var delegate: MPCManagerDelegate?
    
    var myLevel = 1;
    
    override init() {
        super.init()
        
        peer = MCPeerID(displayName: UIDevice.currentDevice().name)
        
        session = MCSession(peer: peer)
        session.delegate = self
        
        if(NSUserDefaults.standardUserDefaults().integerForKey("multiLevel") > 0){
            myLevel = NSUserDefaults.standardUserDefaults().integerForKey("multiLevel") - 200
        }
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: ["level":"\(myLevel)"], serviceType: "mika")
        advertiser.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "mika")
        browser.delegate = self
        
    }
    
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        foundPeers.append(peerID)
        
        delegate?.foundPeer()
    }
    
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for (index, aPeer) in foundPeers.enumerate(){
            if aPeer == peerID {
                foundPeers.removeAtIndex(index)
                break
            }
        }
        
//        if(peerID == connectedPeer){
//            let messageDictionary: [String: String] = ["message": "_end_chat_"]
        
//            sendData(dictionaryWithData: messageDictionary, toPeer: connectedPeer)
//        }
        
        delegate?.lostPeer()
    }
    
    func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
        print(error.localizedDescription)
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        print(error.localizedDescription)
    }
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        switch state{
        case MCSessionState.Connected:
            print("Connected to session: \(session)")
            connectedPeer = peerID
            delegate?.connectedWithPeer(peerID)
            
        case MCSessionState.Connecting:
            print("Connecting to session: \(session)")
            
        default:
            print("Did not connect to session: \(session)")
        }
    }
    
    func sendData(dictionaryWithData dictionary: Dictionary<String, AnyObject>, toPeer targetPeer: MCPeerID) -> Bool {
        let dataToSend = NSKeyedArchiver.archivedDataWithRootObject(dictionary)
        let peersArray = NSArray(object: targetPeer)
        var error: NSError?
        
        do {
        try
        session.sendData(dataToSend, toPeers: peersArray as! [MCPeerID], withMode: MCSessionSendDataMode.Reliable)
        }catch{
            return false
        }
        return true
    }
    
    
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
        
        self.invitationHandler = invitationHandler
        
        delegate?.invitationWasReceived(peerID.displayName,level: myLevel)
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        let dictionary: [String: AnyObject] = ["data": data, "fromPeer": peerID]
        NSNotificationCenter.defaultCenter().postNotificationName("receivedMPCDataNotification", object: dictionary)
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) { }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) { }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    

}
