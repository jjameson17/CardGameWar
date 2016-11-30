//
//  War.swift
//  CardGameWar1
//
//  Created by Jimmy Jameson on 11/20/16.
//  Copyright © 2016 Jimmy Jameson. All rights reserved.
//

import Foundation

class War {
    var playerDeck: [JSONDictionary] = []
    var warStack: [JSONDictionary] = []
    var roundCount: Int = 0
    
    init() {
        //SocketIOManager.sharedInstance.startGame() { (hand) -> Void in
          //  DispatchQueue.main.async(execute: { () -> Void in
                //print("///////")
                //print(hand)
                //print(hand?[0] ?? "oh no")
                //print("/////////")
                //self.playerDeck = hand!
            //})
        //}
    }
    
    func drawRandomCard() -> JSONDictionary {
        let ranNum = Int(arc4random_uniform(UInt32(self.playerDeck.count)))
        return self.playerDeck[ranNum]
        
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
    
    
    
    func battle(opposingCard: JSONDictionary) {
        let opposingCardVal = convertCardValue(rawCard: opposingCard["value"] as! String)
        let playerCardVal = convertCardValue(rawCard: drawRandomCard()["value"] as! String)
        if opposingCardVal > playerCardVal {
            //add card to opposing player cards
        } else if opposingCardVal < playerCardVal {
            //add card to player cards
        } else {
            war()
        }
        
    }
    
    func war() {
        //call battle
        //save index of cards to add/remove from warStack
    }
    func didLoseRounds() {
        if self.roundCount == 50 {
            //if self.p1Cards.count > self.p2Cards.count {
            //    self.p1Win = true
            //} else if self.p1Cards.count < self.p2Cards.count {
            //    self.p2Win = true
            //} else {
            //    self.draw = true
            //}
        }
    }
    
    func didLose() {
        if self.warStack.count == 0 {
            //opposing player wins
        } // else if oppsoing player cards == 0
    }
}
