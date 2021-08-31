//
//  CompEventViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/23/21.
//

import UIKit
import FirebaseDatabase

import FirebaseAuth

class NotificationTableViewController: UITableViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var notifs = [NotificationDetails]()
    

    @IBOutlet var massMessageButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleMeals()
        
        let defaults = UserDefaults.standard
        let role = defaults.string(forKey:"role") ?? "noval"

        if(role == "Member"){
            massMessageButton = nil
            self.navigationItem.rightBarButtonItem = nil
        }

        // Do any additional setup after loading the view.
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toSpecificNotification", sender: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    if segue.identifier == "toSpecificNotification" {
        let indexPath = self.tableView.indexPathForSelectedRow
        let detailVC:NotificationSelectedViewController = segue.destination as! NotificationSelectedViewController
        detailVC.item = notifs[indexPath!.row] as NotificationDetails
    }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notifs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Notif"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NotificationTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CompEventCell.")
        }
        let meal = notifs[indexPath.row]
        cell.titleText.text = meal.title
        cell.messageText.text = meal.message
        cell.timestampText.text = meal.timestamp

        
        return cell
    }
    
    private func loadSampleMeals() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let defaults = UserDefaults.standard
        let chapID = defaults.string(forKey:"chapID") ?? "noval"
        let childID = defaults.string(forKey:"childID") ?? "noval"

        ref.child("Chapters").child(chapID)
            .child(childID).child(Auth.auth().currentUser?.uid ?? "nouid").child("Notifications").observeSingleEvent(of: .value, with: { (snapshot) in
                if(snapshot.exists()){
                    for rest in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        let dict = rest.value as! [String: Any]
                        let notifMessage = dict["Message"] as! String
                        let notifTimestamp = dict["Timestamp"] as! String
                        let notifTitle = dict["Title"] as! String

                        guard let updateItem = NotificationDetails(title: notifTitle, message: notifMessage, timestamp: notifTimestamp)  else {
                                        fatalError("Unable to instantiate meal2")
                                  }
                        self.notifs += [updateItem]
                        self.tableView.reloadData()
                       }
                }
           
         
        })
    
    }

}
