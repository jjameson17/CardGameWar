
//starter code source: www.appcoda.com/socket-io-chat-app/


import UIKit

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblUserList: UITableView!
    @IBOutlet weak var startGameButton: UIButton!
    
    var users = [[String: AnyObject]]() //list of users when they join game
    var nickname: String? = nil
    var configurationOK = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !configurationOK {
            configureNavigationBar()
            configureTableView()
            configurationOK = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(nickname == nil) { //players enter username upon opening app
            askForNickname()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateButton() { //updates button depending on if there is a player in the game
        if tblUserList.numberOfRows(inSection: 0) == 1 {
            startGameButton.isEnabled = false
        } else {
            startGameButton.isEnabled = true
        }
        
        if SocketIOManager.sharedInstance.inProgress {
            startGameButton.setTitle("Join Current Game", for: .normal)
        } else {
            startGameButton.setTitle("Start New Game", for: .normal)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //send nickname to game
        if let identifier = segue.identifier {
            if identifier == "idSegueStartGame" {
                let gameViewController = segue.destination as! GameViewController
                gameViewController.userNames = users.flatMap { String(describing: $0["nickname"]!) }
            }
        }
    }
    
    // MARK: Custom Methods
    func configureNavigationBar() {
        navigationItem.title = "War"
    }
    
    func askForNickname(message: String = "Please enter a nickname") { //alert when entering game
        let alertController = UIAlertController(title: "Welcome to CardConnect", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField(configurationHandler: nil)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
            let textfield = alertController.textFields![0]
            if textfield.text?.characters.count == 0 {
                self.askForNickname()
            }
            else {
                self.nickname = textfield.text
                
                SocketIOManager.sharedInstance.connectToServerWithNickname(nickname: textfield.text!, completionHandler: { (userList) -> Void in
                    DispatchQueue.main.async(execute: { () -> Void in
                        if userList != nil && (userList?.count)! > 0{
                            self.users = userList!
                            self.tblUserList.reloadData()
                            self.tblUserList.isHidden = false
                            self.updateButton()
                        } else if userList?.count == 0 {
                            self.updateButton()
                        } else { //if a 3rd player attempts to enter game
                            self.askForNickname(message: "Only 2 players can play at once")
                        }
                    })
                })
            }
        }
        
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func configureTableView() {
        tblUserList.delegate = self
        tblUserList.dataSource = self
        tblUserList.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "idCellUser")
        tblUserList.isHidden = true
        tblUserList.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    
    // MARK: UITableView Delegate and Datasource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellUser", for: indexPath as IndexPath) as! UserCell
        
        cell.textLabel?.text = users[indexPath.row]["nickname"] as? String
        cell.detailTextLabel?.text = (users[indexPath.row]["isConnected"] as! Bool) ? "Online" : "Offline"
        cell.detailTextLabel?.textColor = (users[indexPath.row]["isConnected"] as! Bool) ? UIColor.green : UIColor.red
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    
    
}
