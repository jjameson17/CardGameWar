//
//  ViewController.swift
//  CardGameWar1
//
//  Created by Jimmy Jameson on 11/7/16.
//  Copyright © 2016 Jimmy Jameson. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var game = Game()
    var userNames: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        warTieButtonPress.isEnabled = game.isWar
        updateLabels()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.listenforOpponentMoves()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBOutlets and IBActions
    
    @IBOutlet weak var P1CardTotal: UILabel!
    @IBOutlet weak var P2CardTotal: UILabel!
    @IBOutlet weak var P1CardImage: UIImageView!
    @IBOutlet weak var P2CardImage: UIImageView!
    @IBAction func warButton(sender: UIButton) {
        game.battle()
        warButtonPress.isEnabled = !game.isWar
        warTieButtonPress.isEnabled = game.isWar
        updateLabels()
    }
    @IBOutlet weak var warButtonPress: UIButton!
    @IBAction func warTieButton(sender: UIButton) {
        game.war()
        warTieButtonPress.isEnabled = game.isWar
        warButtonPress.isEnabled = !game.isWar
        updateLabels()
    }
    @IBOutlet weak var warTieButtonPress: UIButton!
    @IBOutlet weak var roundCountLabel: UILabel!
    @IBOutlet weak var scoreboardPlayer1Label: UILabel!
    @IBOutlet weak var scoreboardPlayer2Label: UILabel!
    
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //if player exits game
        if let identifier = segue.identifier {
            if identifier == "idSegueExitGame" {
                SocketIOManager.sharedInstance.endGame()
            }
        }
        
    }

    // MARK: Update View
    func loadImageFromUrl(url: String, view: UIImageView){
        let url = NSURL(string: url)!
        let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
            if let data = responseData{
                DispatchQueue.main.async(execute: { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        }
        task.resume()
    }
    
    func showAlert() {
        let title = game.determineTitle(player: scoreboardPlayer1Label.text!, player2: scoreboardPlayer2Label.text!)
        let message = game.generateMessage(player: scoreboardPlayer1Label.text!, player2: scoreboardPlayer2Label.text!)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default,
                                   handler: { action in
                                    self.newGame()
        })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

    func updateLabels() {
        P1CardTotal.text = String(game.p1Cards.count) //load card count
        P2CardTotal.text = String(game.p2Cards.count)
        loadImageFromUrl(url: game.p1CardImage, view: P1CardImage) //load player 1 card
        loadImageFromUrl(url: game.p2CardImage, view: P2CardImage) //load player 2 card
        scoreboardPlayer1Label.text = userNames[0] //load player 1 nickname
        scoreboardPlayer2Label.text = userNames[1] //load player 2 nickname
        roundCountLabel.text = String(game.roundCount) //load roundCount
        if SocketIOManager.sharedInstance.playerTurn >= (game.localPlayerMove * 2) {
            if game.isWar { //check if player can move
                warButtonPress.isEnabled = false
            } else {
                warButtonPress.isEnabled = true
            }
        } else {
            warButtonPress.isEnabled = false
        }
        gameOver()
    }
    
    
    // MARK: Socket Connection
    func listenforOpponentMoves() { //if either player makes a move
        SocketIOManager.sharedInstance.listenForMoves { (typeOfMove: String) -> Void in
            //print(typeOfMove)
            self.updateLabels()
            
            if(typeOfMove == "end game") {
                self.performSegue(withIdentifier: "idSegueExitGame", sender: nil)
            }
        }
    }
    
    // MARK: Game Functionality
    
    func gameOver() {
        if game.p1Win == true {
            showAlert()
            warButtonPress.isEnabled = false
            warTieButtonPress.isEnabled = false
        }
        if game.p2Win == true {
            showAlert()
            warButtonPress.isEnabled = false
            warTieButtonPress.isEnabled = false
        }
        if game.draw == true {
            showAlert()
            warButtonPress.isEnabled = false
            warTieButtonPress.isEnabled = false
        }
    }
    
    func newGame() {
        // reset game
        self.game = Game()
    }
    
}

