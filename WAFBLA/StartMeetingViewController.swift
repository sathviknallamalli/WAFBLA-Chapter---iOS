//
//  StartMeetingViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/24/21.
//

import UIKit
import FirebaseDatabase

class StartMeetingViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var showID: UIButton!
    @IBOutlet weak var liveDesc: UILabel!
    @IBOutlet weak var startDesc: UILabel!
    @IBOutlet weak var meetingName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        startDesc.isHidden = true
        liveDesc.isHidden = true
        showID.isHidden = true
        endButton.isHidden = true
        
        let defaults = UserDefaults.standard
        let chapID = defaults.string(forKey:"chapID") ?? "noval"
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("Chapters").child(chapID).child("Meetings")

        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.exists() && snapshot.childrenCount != 1){
        
                let meetingDict = snapshot.value as! [String: Any]
                let isActive = meetingDict["isActive"] as! Bool
                if(isActive){
                    self.startDesc.isHidden = false
                    self.liveDesc.isHidden = false
                    
                    let id = meetingDict["ID"] as! String
                    let title = meetingDict["Title"] as! String

                    
                    self.showID.setTitle("Meeting ID: " + id, for: .normal)
                    self.meetingName.text = title
                    self.meetingName.isEnabled = false
                    self.endButton.isEnabled = true
                    self.generateButton.isEnabled = false
                    
                    self.showID.isHidden = false
                    self.endButton.isHidden = false
                    
                    
                    let alertController = UIAlertController(title: "Meeting", message: "You have a meeting currently live and active", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        })
    }
    

    @IBAction func generate(_ sender: Any) {
        if (!generateButton.isEnabled) {
            let alertController = UIAlertController(title: "Meeting", message: "You must end current meeting to start a new one", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else{
            if (meetingName.text!.isEmpty) {
                let alertController = UIAlertController(title: "Meeting", message: "Enter meeting title", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }else{
                let date = Date()
                let format = DateFormatter()
                format.dateFormat = "MM/dd/yyyy HH:mm:ss"
                let timestamp = format.string(from: date)
                
                let defaults = UserDefaults.standard
                let chapID = defaults.string(forKey:"chapID") ?? "noval"
                
                var ref: DatabaseReference!
                ref = Database.database().reference().child("Chapters").child(chapID).child("Meetings")
                
                ref.child("Title").setValue(meetingName.text);
                ref.child("isActive").setValue(true);
                let id = randomString()
                ref.child("ID").setValue(id);
                ref.child("Attendance").setValue(0);
                ref.child("StartTime").setValue(timestamp);
                
                startDesc.isHidden = false;
                liveDesc.isHidden = false
                showID.isHidden = false;
                showID.setTitle("Meeting ID: " + id, for: .normal)
                endButton.isHidden = false
                endButton.isEnabled = true
                generateButton.isEnabled = false
                meetingName.isEnabled = false
            }
        }
    }
    
    func randomString() -> String {
      let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
      return String((0..<6).map{ _ in letters.randomElement()! })
    }
    
    @IBAction func end(_ sender: Any) {
        let defaults = UserDefaults.standard
        let chapID = defaults.string(forKey:"chapID") ?? "noval"
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("Chapters").child(chapID).child("Meetings")
        ref.child("isActive").setValue(false)
        startDesc.isHidden = true
        liveDesc.isHidden = true
        showID.isHidden = true
        endButton.isHidden = true
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MM/dd/yyyy HH:mm:ss"
        let timestamp = format.string(from: date)
        
        ref.child("EndTime").setValue(timestamp)
        
     
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            //sendemail with recap
            
            let meetingDict = snapshot.value as! [String: Any]
            let title = meetingDict["Title"] as! String
            let count = meetingDict["Attendance"] as! Int
            let starttime = meetingDict["StartTime"] as! String

            var pmref: DatabaseReference!
            pmref = ref.child("PastMeetings").childByAutoId()
            pmref.child("Title").setValue(title)
            pmref.child("Attendance").setValue(count)
            pmref.child("StartTime").setValue(starttime)

            ref.child("Attendance").removeValue();
            ref.child("ID").removeValue();
            ref.child("StartTime").removeValue();
            ref.child("Title").removeValue();
            ref.child("isActive").removeValue();
            ref.child("EndTime").removeValue();
            ref.child("Attendees").removeValue();
            
            
            
            self.meetingName.text = ""
            self.meetingName.isEnabled = true
            self.generateButton.isEnabled = true


        })
        
        let alertController = UIAlertController(title: "Meeting", message: "Meeting ended", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
}
