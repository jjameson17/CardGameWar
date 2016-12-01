//
//  SocketIOManager.swift

//  SocketChat
//
//  Created by Sivan Mehta on 11/16/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    static var inProgress = false
    var battlePressed: Bool = false
    var playerTurn: Int = 0
    
    override init() {
        super.init()
    }
    
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "https://cardgamewar.herokuapp.com")! as URL)
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func connectToServerWithNickname(nickname: String, completionHandler: @escaping (_ userList: [[String: AnyObject]]?) -> Void) {
        socket.emit("connectUser", nickname)
        print(nickname)
        
        // if we can connect we will receive the userList event
        socket.on("userList") { ( dataArray, ack) -> Void in
            completionHandler(dataArray[0] as? [[String: AnyObject]])
        }
        
        // if cannot connect we will receive the denyAccess event
        socket.on("denyAccess") { (data, ack) -> Void in
            completionHandler(nil)
        }
        
        // someone else started the game
        socket.on("startedGame") { (dataArray, ack) -> Void in
            SocketIOManager.inProgress = true
            let empty = [[String: AnyObject]]()
            completionHandler(empty)
        }
    }
    
    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
        socket.emit("disconnect")
        completionHandler()
    }
    
    func getChatMessage(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
        socket.on("newChatMessage") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
            messageDictionary["nickname"] = dataArray[0] as! String as AnyObject?
            messageDictionary["message"] = dataArray[1] as! String as AnyObject?
            messageDictionary["date"] = dataArray[2] as! String as AnyObject?
            
            completionHandler(messageDictionary)
        }
    }
    
    func makeBattleMove() {
        socket.emit("made battle move")
        //print("bbb")
        //self.playerTurn += 1
    }

    func makeWarMove() {
        socket.emit("made war move")
    }
    
    func startGame(completionHandler: @escaping (_ hand:  [[String: AnyObject]]?) -> Void) {
        socket.emit("startedGame")
        
        socket.on("startedGame") { (hand, ack) -> Void in
            completionHandler(hand[0] as? [[String: AnyObject]])
        }
        
        socket.on("join game") { (hand, ack) -> Void in
            print(hand)
            completionHandler(hand[0] as? [[String: AnyObject]])
        }
    }
    
    func listenForMoves(completionHandler: @escaping (_ moveType: String) -> Void) {
        socket.on("made battle move") { (ack) -> Void in
            completionHandler("battle")
            print("aaa")
            self.playerTurn += 1
            print(self.playerTurn)
        }
        
        socket.on("made war move") { (ack) -> Void in
            completionHandler("war")
        }
    }
}
