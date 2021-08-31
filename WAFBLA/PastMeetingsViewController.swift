//
//  PastMeetingsViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/25/21.
//

import UIKit
import FirebaseDatabase

class PastMeetingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var products: [PastMeeting] = [PastMeeting]()

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        createProducts()
        tableView.allowsSelection = false

        tableView.delegate = self
            tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingCell") as! MeetingCell
        let currentItem = products[indexPath.row]
        cell.field1.text = "Meeting: " + currentItem.title
        cell.field2.text = "Attendance: \(currentItem.count)"
        cell.field3.text = "Start time: " + currentItem.time

           

            return cell
    }
    
    func createProducts(){
       
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let defaults = UserDefaults.standard
        let chapID = defaults.string(forKey:"chapID") ?? "noval"
        
        
        ref.child("Chapters").child(chapID).child("Meetings").child("PastMeetings").observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.exists()){
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let meetingDict = rest.value as! [String: Any]
                    let title = meetingDict["Title"] as! String
                    let attendance = meetingDict["Attendance"] as! Int
                    let time = meetingDict["StartTime"] as! String

                    self.products.append(PastMeeting(title: title, time: time, count: attendance)!)

                    self.tableView.reloadData()
                   }
            }
           
         
        })

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
