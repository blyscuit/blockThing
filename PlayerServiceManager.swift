
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
    
    func invitationWasReceived(fromPeer: String)
    
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
    
    override init() {
        super.init()
        
        peer = MCPeerID(displayName: UIDevice.currentDevice().name)
        
        session = MCSession(peer: peer)
        session.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "mika")
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
        
        if(peerID == connectedPeer){
            let messageDictionary: [String: String] = ["message": "_end_chat_"]
            
            sendData(dictionaryWithData: messageDictionary, toPeer: connectedPeer)
        }
        
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
        
        delegate?.invitationWasReceived(peerID.displayName)
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        let dictionary: [String: AnyObject] = ["data": data, "fromPeer": peerID]
        NSNotificationCenter.defaultCenter().postNotificationName("receivedMPCDataNotification", object: dictionary)
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) { }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) { }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    

}
//    
//    private let PlayerServiceType = "esqace"
//    private let myPeerId = MCPeerID(displayName: UIDevice.currentDevice().name)
//    private let serviceAdvertiser : MCNearbyServiceAdvertiser
//    private let serviceBrowser : MCNearbyServiceBrowser
//    var delegate : PlayerServiceManagerDelegate?
//    
//    override init() {
//        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: PlayerServiceType)
//
//        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: PlayerServiceType)
//
//        super.init()
//        
//        self.serviceAdvertiser.delegate = self
//        self.serviceAdvertiser.startAdvertisingPeer()
//        
//        self.serviceBrowser.delegate = self
//        self.serviceBrowser.startBrowsingForPeers()
//    }
//    
//    deinit {
//        self.serviceAdvertiser.stopAdvertisingPeer()
//        self.serviceBrowser.stopBrowsingForPeers()
//    }
//    
//    lazy var session: MCSession = {
//        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
//        session.delegate = self
//        return session
//    }()
//
//    func sendColor(colorName : String) {
//        NSLog("%@", "sendColor: \(colorName)")
//        
//        if session.connectedPeers.count > 0 {
//            var error : NSError?
//            do {
//                try self.session.sendData(colorName.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable)
//            } catch var error1 as NSError {
//                error = error1
//                NSLog("%@", "\(error)")
//            }
//        }
//
//    }
//    
//}
//
//extension PlayerServiceManager : MCNearbyServiceAdvertiserDelegate {
//    
//    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
//        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
//    }
//    
//    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: ((Bool, MCSession) -> Void)) {
//        
//        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
//        invitationHandler(true, self.session)
//    }
//
//}
//
//extension PlayerServiceManager : MCNearbyServiceBrowserDelegate {
//    
//    func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
//        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
//    }
//    
//    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
//        NSLog("%@", "foundPeer: \(peerID)")
//        NSLog("%@", "invitePeer: \(peerID)")
//        browser.invitePeer(peerID, toSession: self.session, withContext: nil, timeout: 10)
//    }
//    
//    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
//        NSLog("%@", "lostPeer: \(peerID)")
//    }
//    
//}
//
//extension MCSessionState {
//    
//    func stringValue() -> String {
//        switch(self) {
//        case .NotConnected: return "NotConnected"
//        case .Connecting: return "Connecting"
//        case .Connected: return "Connected"
//        default: return "Unknown"
//        }
//    }
//    
//}
//
//extension PlayerServiceManager : MCSessionDelegate {
//    
//    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
//        NSLog("%@", "peer \(peerID) didChangeState: \(state.stringValue())")
//        self.delegate?.connectedDevicesChanged(self, connectedDevices: session.connectedPeers.map({$0.displayName}))
//    }
//    
//    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
//        NSLog("%@", "didReceiveData: \(data.length) bytes")
//        let str = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
//        self.delegate?.colorChanged(self, colorString: str)
//    }
//    
//    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
//        NSLog("%@", "didReceiveStream")
//    }
//    
//    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
//        NSLog("%@", "didFinishReceivingResourceWithName")
//    }
//    
//    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
//        NSLog("%@", "didStartReceivingResourceWithName")
//    }
//    
//}
