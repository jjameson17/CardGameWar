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
    var deckID: String?
    
    
    init() {
        let api = APIParser()
        let newdeck = api.newDeck()
        self.deckID = String(newdeck!["deck_id"]!) //initialize a shuffled deck
        print(self.deckID)
        if let input = self.deckID {
            let p1Deal = api.deal(input)
            //print(p1Deal!["cards"]![0])
            self.p1Cards = p1Deal!["cards"] as! [JSONDictionary] //deal cards for player 1
            //print(self.p1Cards[0])
            let p2Deal = api.deal(input)
            self.p2Cards = p2Deal!["cards"] as! [JSONDictionary] //deal cards for player 2
        }

    }
    
    
    func battle() {
        let p1CardDraw = Int(arc4random_uniform(UInt32(self.p1Cards.count)))
        let p2CardDraw = Int(arc4random_uniform(UInt32(self.p2Cards.count)))
        let p1CardVal = convertCardValue(self.p1Cards[p1CardDraw]["value"]! as! String) // change to Int
        let p2CardVal = convertCardValue(self.p2Cards[p2CardDraw]["value"]! as! String) //change to Int
        self.p1CardImage = self.p1Cards[p1CardDraw]["image"]! as! String
        self.p2CardImage = self.p2Cards[p2CardDraw]["image"]! as! String
        print(p1CardImage)
        print(p2CardImage)
        if p1CardVal > p2CardVal {
            self.p1Cards.append(self.p2Cards[p2CardDraw])
            self.p2Cards.removeAtIndex(p2CardDraw)
            print(p1Cards.count)
            print(p2Cards.count)
        } else if p1CardVal < p2CardVal {
            self.p2Cards.append(self.p2Cards[p2CardDraw])
            self.p1Cards.removeAtIndex(p1CardDraw)
            print(p1Cards.count)
            print(p2Cards.count)
        } else {
            print("none")
            
        }
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
    
    
    func war() {
        //possible option: draw index - 1, use parameters for previous index, make sure index isn't 0
        //>> add to a card stack, append number of cards in stack to total cards
        //>> possibly make separate battle function with random numbers as inputs
        //possible option: draw another random card, make sure it is different than previous
        
    }


}
