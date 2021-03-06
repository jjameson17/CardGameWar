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
    var inProgress = false
    var playerTurn: Int = 0
    
    override init() {
        super.init()
    }
    
    // MARK: Connection Management
    
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "https://cardgamewar.herokuapp.com")! as URL)

    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    /**
     Connect to server with a given name
     
     - parameters:
        - nickname: nickname that user to chose to identify with, will display when user connects
        - completionHandler: callback function to be called when the appropriate socket events are emitted by the server
    */
    func connectToServerWithNickname(nickname: String, completionHandler: @escaping (_ userList: [[String: AnyObject]]?) -> Void) {
        socket.emit("connectUser", nickname)
        
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
            self.inProgress = true
            let empty = [[String: AnyObject]]()
            completionHandler(empty)
        }
    }
    
    // MARK: Battle Functionality
    
    func makeBattleMove() {
        socket.emit("made battle move")
    }

    func makeWarMove() {
        socket.emit("made war move")
    }
    
    // MARK: Manage Game States
    
    func endGame() {
        closeConnection()
        establishConnection()
        self.inProgress = false
    }
    
    /**
        Start game and listen for socket events with the given completionHandler
     
        - parameters:
            - completionHandler: callback function that is called when socket events are emitted by the server
     */
    func startGame(completionHandler: @escaping (_ hand: Array<Any>) -> Void) {
        socket.emit("startedGame")
        
        socket.on("startedGame") { (hands, ack) -> Void in
            completionHandler((hands as Array<Any>))
        }
        
        socket.on("join game") { (hands, ack) -> Void in
            print("joined: ", hands)
            completionHandler((hands as Array<Any>))
        }
    }
    
    /**
     Listen for socket events corresponding to battle, war, and ending a game
     
     - parameters:
         - completionHandler: callback function that is called when socket events are emitted by the server
     */
    func listenForMoves(completionHandler: @escaping (_ moveType: String) -> Void) {
        socket.on("made battle move") { (ack) -> Void in
            self.playerTurn += 1
            completionHandler("battle")
            print("player Turn:", self.playerTurn)
        }
        
        socket.on("made war move") { (ack) -> Void in
            completionHandler("war")
        }
        
        // someone left the game
        socket.on("end games") { (ack) -> Void in
            self.playerTurn = 0
            self.inProgress = false
            completionHandler("end game")
        }
    }
}
