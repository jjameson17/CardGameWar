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
        updateLabels()
    }
    
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
    }
    

        

    


}

