//
//  CompEventViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/23/21.
//

import UIKit
import FirebaseDatabase

class CompEventViewController: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    var events = [CompEventDetails]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleMeals()

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
        performSegue(withIdentifier: "toCompEvent", sender: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    if segue.identifier == "toCompEvent" {
        let indexPath = self.tableView.indexPathForSelectedRow
        let detailVC:CompEventSelectedViewController = segue.destination as! CompEventSelectedViewController
        detailVC.item = events[indexPath!.row] as CompEventDetails
    }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CompEvent"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CompEventTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CompEventCell.")
        }
        let meal = events[indexPath.row]
        cell.eventname.text = meal.eventname
        cell.eventtitle.text = meal.eventtitle
        cell.eventcategory.text = meal.eventcategory

        
        return cell
    }
    
    private func loadSampleMeals() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("Events").observeSingleEvent(of: .value, with: { (snapshot) in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                
                let dict = rest.value as! [String: Any]
                let eventName = dict["eventname"] as! String
                let eventType = dict["eventtype"] as! String
                let eventCategory = dict["eventcategory"] as! String

                guard let updateItem = CompEventDetails(eventtitle: eventName, eventname: eventType, eventcategory: eventCategory)  else {
                                fatalError("Unable to instantiate meal2")
                          }
                self.events += [updateItem]
                self.tableView.reloadData()
               }
         
        })
    
    }

}
