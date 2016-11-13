//
//  ViewController.swift
//  CardGameWar1
//
//  Created by Jimmy Jameson on 11/7/16.
//  Copyright © 2016 Jimmy Jameson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let game = Game()

    override func viewDidLoad() {
        super.viewDidLoad()
        warTieButtonPress.enabled = game.isWar
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBOutlet weak var P1CardTotal: UILabel!
    @IBOutlet weak var P2CardTotal: UILabel!
    @IBOutlet weak var P1CardImage: UIImageView!
    @IBOutlet weak var P2CardImage: UIImageView!
    @IBAction func warButton(sender: UIButton){
        game.battle()
        warButtonPress.enabled = !game.isWar
        warTieButtonPress.enabled = game.isWar
        updateLabels()
    }
    @IBOutlet weak var warButtonPress: UIButton!
    @IBAction func warTieButton(sender: UIButton) {
        game.war(game.p1CardDraw, p2CardDraw: game.p2CardDraw)
        warTieButtonPress.enabled = game.isWar
        warButtonPress.enabled = !game.isWar
        updateLabels()
    }
    @IBOutlet weak var warTieButtonPress: UIButton!
    @IBOutlet weak var roundCountLabel: UILabel!
    

    
    
    func loadImageFromUrl(url: String, view: UIImageView){
        let url = NSURL(string: url)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            if let data = responseData{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        }
        task.resume()
    }
    

    func updateLabels() {
        P1CardTotal.text = String(game.p1Cards.count)
        P2CardTotal.text = String(game.p2Cards.count)
        loadImageFromUrl(game.p1CardImage, view: P1CardImage)
        loadImageFromUrl(game.p2CardImage, view: P2CardImage)
        roundCountLabel.text = String(game.roundCount)
        gameOver()
    }
    
    func gameOver() {
        if game.p1Win == true {
            //let game = Game()
            P1CardTotal.text = "Player 1 Wins"
            warButtonPress.enabled = false
            warTieButtonPress.enabled = false
        }
        if game.p2Win == true {
            P2CardTotal.text = "Player 2 Wins"
            warButtonPress.enabled = false
            warTieButtonPress.enabled = false
        }
        if game.draw == true {
            P1CardTotal.text = "Draw"
            P2CardTotal.text = "Draw"
            warButtonPress.enabled = false
            warTieButtonPress.enabled = false
        }
    }
    

        

    


}

