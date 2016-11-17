//
//  APIparser.swift
//  CardGameWar1
//
//  Created by Jimmy Jameson on 11/7/16.
//  Copyright © 2016 Jimmy Jameson. All rights reserved.
//

import Foundation

import Foundation

typealias JSONDictionary = [String: AnyObject]

class APIParser {
    
    func newDeck() -> JSONDictionary? { //create new deck
        let url = NSURL(string: "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        var response: URLResponse?
        let error:NSErrorPointer = nil
        var data: NSData?
        do {
            data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response) as NSData?
        } catch let error1 as NSError {
            //
            //error?.memory = error1
            data = nil
        }
        if let jsonData = data {
            do {
                let json = try JSONSerialization
                    .jsonObject(with: jsonData as Data, options: .allowFragments)
                return json as? JSONDictionary
            } catch {
                print ("Error")
                return nil
            }
        } else {
            return nil
        }
    }
    
    func deal(deckID: String?) -> JSONDictionary? {
        print(deckID)
        let url = NSURL(string: "https://deckofcardsapi.com/api/deck/\(deckID!)/draw/?count=26")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        var response: URLResponse?
        let error:NSErrorPointer = nil
        var data: NSData?
        do {
            data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response) as NSData?
        } catch let error1 as NSError {
            //error?.memory = error1
            data = nil
        }
        if let jsonData = data {
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments)
                return json as? JSONDictionary
            } catch {
                print ("Error")
                return nil
            }
        } else {
            return nil
        }
    }

    

}
