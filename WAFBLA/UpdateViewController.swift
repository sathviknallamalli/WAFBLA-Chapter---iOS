//
//  PhotoViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/23/21.
//

import UIKit
import FirebaseDatabase

class UpdateViewController: UITableViewController {
    var updates = [UpdateDetails]()

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return updates.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showUpdates", sender: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    if segue.identifier == "showUpdates" {
        let indexPath = self.tableView.indexPathForSelectedRow
        let detailVC:UpdateSelectedViewController = segue.destination as! UpdateSelectedViewController
        detailVC.item = updates[indexPath!.row] as UpdateDetails
    }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Update"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Update  else {
            fatalError("The dequeued cell is not an instance of UpdateCell.")
        }
        let meal = updates[indexPath.row]
        
        let boldText = "Update: "
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

        let normalText = meal.title
        let normalString = NSMutableAttributedString(string:normalText)

        attributedString.append(normalString)
        
        cell.titleText.attributedText = attributedString
        //cell.labelText.text = meal.label
        
        return cell
    }
    
    private func loadSampleMeals() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("Updates").observeSingleEvent(of: .value, with: { (snapshot) in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let value = rest.value
                let key = rest.key
             
                guard let updateItem = UpdateDetails(title: key, label: value as! String)  else {
                                fatalError("Unable to instantiate meal2")
                          }
                self.updates += [updateItem]
                print(self.updates)
                self.tableView.reloadData()
               }
         
        })
    
    }
}
