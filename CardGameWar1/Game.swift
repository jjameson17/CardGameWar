//
//  Game.swift
//  CardGameWar1
//
//  Created by Jimmy Jameson on 11/7/16.
//  Copyright © 2016 Jimmy Jameson. All rights reserved.
//

import Foundation


class Game {
    var cardStackCount: Int = 0 //number of cards in stack during a tie
    var p1Cards = [JSONDictionary]()
    var p2Cards = [JSONDictionary]()
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
    
    
    init() {
        let api = APIParser()
        let newdeck = api.newDeck()
        self.deckID = String(newdeck!["deck_id"]!) //initialize a shuffled deck
        print(self.deckID)
        if let input = self.deckID {
            let p1Deal = api.deal(input)
            self.p1Cards = p1Deal!["cards"] as! [JSONDictionary] //deal cards for player 1
            let p2Deal = api.deal(input)
            self.p2Cards = p2Deal!["cards"] as! [JSONDictionary] //deal cards for player 2
        }

    }
    
    
    func battle() {
        self.roundCount += 1
        didLose()
        //let p1CardDraw = Int(arc4random_uniform(UInt32(self.p1Cards.count)))
        //let p2CardDraw = Int(arc4random_uniform(UInt32(self.p2Cards.count)))
        self.p1CardDraw = Int(arc4random_uniform(UInt32(self.p1Cards.count)))
        self.p2CardDraw = Int(arc4random_uniform(UInt32(self.p2Cards.count)))
        let p1CardVal = convertCardValue(self.p1Cards[self.p1CardDraw]["value"]! as! String) // change to Int
        let p2CardVal = convertCardValue(self.p2Cards[self.p2CardDraw]["value"]! as! String) //change to Int
        self.p1CardImage = self.p1Cards[self.p1CardDraw]["image"]! as! String
        self.p2CardImage = self.p2Cards[self.p2CardDraw]["image"]! as! String
        if p1CardVal > p2CardVal {
            self.p1Cards.append(self.p2Cards[self.p2CardDraw])
            self.p2Cards.removeAtIndex(self.p2CardDraw)
            didLose()
            self.p1Cards.appendContentsOf(self.warStack)
            self.warStack.removeAll()
            self.isWar = false
        } else if p1CardVal < p2CardVal {
            self.p2Cards.append(self.p1Cards[self.p1CardDraw])
            self.p1Cards.removeAtIndex(self.p1CardDraw)
            didLose()
            self.p2Cards.appendContentsOf(self.warStack)
            self.warStack.removeAll()
            self.isWar = false
        } else {
            self.isWar = true
            //war(p1CardDraw, p2CardDraw: p2CardDraw)
        }
        didLoseRounds()
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
    
    
    func war(p1CardDraw: Int, p2CardDraw: Int) {
        didLose()
        self.warStack.append(self.p1Cards[self.p1CardDraw])
        self.warStack.append(self.p2Cards[self.p2CardDraw])
        didLose()
        self.p1Cards.removeAtIndex(self.p1CardDraw)
        self.p2Cards.removeAtIndex(self.p2CardDraw)
        battle()
        self.roundCount -= 1
        didLoseRounds()
    }
    
    func didLoseRounds() {
        if self.roundCount == 100 {
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
    
    func determineTitle() -> String {
        if self.p1Win == true {
            return "Player 1 Wins!"
        } else if self.p2Win == true {
            return "Player 2 Wins!"
        } else {
            return "Draw"
        }
    }
    
    func generateMessage() -> String {
        if self.p1Win == true {
            return "Player 1 wins: \(self.p1Cards.count) - \(self.p2Cards.count)"
        } else if self.p2Win == true {
            return "Player 2 wins: \(self.p2Cards.count) - \(self.p1Cards.count)"
        } else {
            return "Draw: \(self.p1Cards.count) - \(self.p2Cards.count)"
        }
    }


}
