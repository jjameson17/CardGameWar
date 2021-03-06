
//
//  Game.swift
//  CardGameWar1
//
//  Created by Jimmy Jameson on 11/7/16.
//  Copyright © 2016 Jimmy Jameson. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: AnyObject]

class Game {
    var cardStackCount: Int = 0 //number of cards in stack during a tie
    var p1Cards = [JSONDictionary]() //player 1 cards
    var p2Cards = [JSONDictionary]() //player 2 cards
    var p1CardImage: String = ""
    var p2CardImage: String = ""
    var warStack: [JSONDictionary] = []
    var isWar: Bool = false
    var p1CardDraw: Int = 0
    var p2CardDraw: Int = 0
    var p1Win: Bool = false
    var p2Win: Bool = false
    var roundCount: Int = 0
    var draw = false
    var deckID: String?
    var localPlayerMove: Int = 0 //counter for player's own moves
    
    init() {
        SocketIOManager.sharedInstance.startGame() { (socketHands) -> Void in
            let hands = (socketHands[0] as AnyObject) //receive hands from server
            
            self.p1Cards = hands[0] as! [JSONDictionary]
            self.p2Cards = hands[1] as! [JSONDictionary]
        }
    }
    
    // MARK: Player Move
    
    func battle() {
        self.localPlayerMove += 1
        self.roundCount += 1
        didLose()
        self.p1CardDraw = 0 //take card from top of deck
        self.p2CardDraw = 0
        let p1CardVal = convertCardValue(rawCard: self.p1Cards[self.p1CardDraw]["value"]! as! String)
        let p2CardVal = convertCardValue(rawCard: self.p2Cards[self.p2CardDraw]["value"]! as! String)
        self.p1CardImage = self.p1Cards[self.p1CardDraw]["image"]! as! String
        self.p2CardImage = self.p2Cards[self.p2CardDraw]["image"]! as! String
        if p1CardVal > p2CardVal {
            self.p1Cards.append(self.p2Cards[self.p2CardDraw])
            self.p1Cards.append(self.p1Cards[self.p1CardDraw])
            self.p1Cards.remove(at: self.p1CardDraw)
            self.p2Cards.remove(at: self.p2CardDraw)
            didLose()
            self.p1Cards.append(contentsOf: self.warStack) //if there was a war add cards
            self.warStack.removeAll()
            self.isWar = false
        } else if p1CardVal < p2CardVal {
            self.p2Cards.append(self.p1Cards[self.p1CardDraw])
            self.p2Cards.append(self.p2Cards[self.p2CardDraw])
            self.p2Cards.remove(at: self.p2CardDraw)
            self.p1Cards.remove(at: self.p1CardDraw)
            didLose()
            self.p2Cards.append(contentsOf: self.warStack)
            self.warStack.removeAll()
            self.isWar = false
        } else {
            self.isWar = true
        }
        didLoseRounds()
        SocketIOManager.sharedInstance.makeBattleMove() //send battle move to server
    }
    
    func war() {
        didLose()
        //add cards to war array
        self.warStack.append(self.p1Cards[self.p1CardDraw])
        self.warStack.append(self.p2Cards[self.p2CardDraw])
        didLose()
        //remove cards from each player
        self.p1Cards.remove(at: self.p1CardDraw)
        self.p2Cards.remove(at: self.p2CardDraw)
        battle()
        self.roundCount -= 1
        didLoseRounds()
        
        SocketIOManager.sharedInstance.makeWarMove() //send war move to server
    }
    
    func convertCardValue(rawCard: String) -> Int {
        if rawCard == "KING" {
            return 13
        } else if rawCard == "QUEEN" {
            return 12
        } else if rawCard == "JACK" {
            return 11
        } else if rawCard == "ACE" {
            return 1
        } else {
            return Int(rawCard)!
        }
    }
    

    // MARK: End Game
    
    func didLoseRounds() {
        if self.roundCount == 50 {
            if self.p1Cards.count > self.p2Cards.count {
                self.p1Win = true
            } else if self.p1Cards.count < self.p2Cards.count {
                self.p2Win = true
            } else {
                self.draw = true
            }
        }
    }
    
    func didLose() {
        if self.p1Cards.count == 0 {
            self.p2Win = true
        }
        if self.p2Cards.count == 0 {
            self.p1Win = true
        }
    }
    
    func determineTitle(player: String, player2: String) -> String {
        if self.p1Win == true {
            return "\(player) Wins!"
        } else if self.p2Win == true {
            return "\(player2) Wins!"
        } else {
            return "Draw"
        }
    }
    
    func generateMessage(player: String, player2: String) -> String {
        if self.p1Win == true {
            return "\(player) wins: \(self.p1Cards.count) - \(self.p2Cards.count)"
        } else if self.p2Win == true {
            return "\(player2) wins: \(self.p2Cards.count) - \(self.p1Cards.count)"
        } else {
            return "Draw: \(self.p1Cards.count) - \(self.p2Cards.count)"
        }
    }
}
