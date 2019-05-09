
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
    
    func invitationWasReceived(_ fromPeer: String,level:Int)
    
    func connectedWithPeer(_ peerID: MCPeerID)
    
//    func disconnectedWithPeer(peerID: MCPeerID)
    
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
        
        if(UserDefaults.standard.integer(forKey: "multiLevel") > 0){
            myLevel = UserDefaults.standard.integer(forKey: "multiLevel") - 200 + 1
        }
        let displayN = "\(UIDevice.current.name)"+" : Level \(myLevel)"
        peer = MCPeerID(displayName: displayN)
        
        session = MCSession(peer: peer)
        session.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: ["level":"\(myLevel)"], serviceType: "mika")
        advertiser.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "mika")
        browser.delegate = self
        
    }
    
    func refreshStatus(){
        if(UserDefaults.standard.integer(forKey: "multiLevel") > 0){
            myLevel = UserDefaults.standard.integer(forKey: "multiLevel") - 200 + 1
        }
        if(advertiser != nil){
            advertiser.stopAdvertisingPeer()
            browser.stopBrowsingForPeers()
        }
        
        let displayN = "\(UIDevice.current.name)"+" : Level \(myLevel)"
        peer = MCPeerID(displayName: displayN)
        
        session = MCSession(peer: peer)
        session.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: ["level":"\(myLevel)"], serviceType: "mika")
        advertiser.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "mika")
        browser.delegate = self
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        foundPeers.append(peerID)
        
        delegate?.foundPeer()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for (index, aPeer) in foundPeers.enumerated(){
            if aPeer == peerID {
                foundPeers.remove(at: index)
                break
            }
        }
        
//        if(peerID == connectedPeer){
//            let messageDictionary: [String: String] = ["message": "_end_chat_"]
        
//            sendData(dictionaryWithData: messageDictionary, toPeer: connectedPeer)
//        }
        
        delegate?.lostPeer()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print(error.localizedDescription)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(error.localizedDescription)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state{
        case MCSessionState.connected:
            print("Connected to session: \(session)")
            connectedPeer = peerID
            delegate?.connectedWithPeer(peerID)
            
        case MCSessionState.connecting:
            print("Connecting to session: \(session)")
            
        default:
            print("Did not connect to session: \(session)")
            if(connectedPeer != nil){
                if(connectedPeer == peerID){
                    print("Lost peer: \(session)")
                    
                    let messageDictionary: [String: String] = ["message": "_end_chat_"]
                    
                    let dataToSend = NSKeyedArchiver.archivedData(withRootObject: messageDictionary)
                    
                    let dictionary: [String: AnyObject] = ["data": dataToSend as AnyObject, "fromPeer": peerID]
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "receivedMPCDataNotification"), object: dictionary)
                    
                }
            }
            
        }
    }
    
    func sendData(dictionaryWithData dictionary: Dictionary<String, AnyObject>, toPeer targetPeer: MCPeerID) -> Bool {
        let dataToSend = NSKeyedArchiver.archivedData(withRootObject: dictionary)
        let peersArray = NSArray(object: targetPeer)
        var error: NSError?
        
        do {
        try
        session.send(dataToSend, toPeers: peersArray as! [MCPeerID], with: MCSessionSendDataMode.reliable)
        }catch{
            return false
        }
        return true
    }
    
    
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        self.invitationHandler = invitationHandler
        
        var fullNameArr = peerID.displayName.components(separatedBy: ":")
        var numText=fullNameArr[1].replacingOccurrences(of: "Level", with: "")
        numText=numText.replacingOccurrences(of: " ", with: "")
        var askLevel = Int(numText)
        if(askLevel==nil){
            askLevel = 1
        }
        
        delegate?.invitationWasReceived(peerID.displayName,level: askLevel!)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let dictionary: [String: AnyObject] = ["data": data as AnyObject, "fromPeer": peerID]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "receivedMPCDataNotification"), object: dictionary)
    }
    
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    

}
