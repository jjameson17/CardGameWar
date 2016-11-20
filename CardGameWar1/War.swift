//
//  War.swift
//  CardGameWar1
//
//  Created by Jimmy Jameson on 11/20/16.
//  Copyright © 2016 Jimmy Jameson. All rights reserved.
//

import Foundation

class War {
    
    init() {
        SocketIOManager.sharedInstance.startGame() { (hand) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                print(hand)
                print(hand?[0]["value"] ?? "oh no")
            })
        }
    }
}
