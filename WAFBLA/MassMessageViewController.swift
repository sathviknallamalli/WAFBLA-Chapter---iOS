//
//  MassMessageViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/25/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class MassMessageViewController: UIViewController {
    @IBAction func sendButton(_ sender: Any) {
        if(textInput.text.isEmpty || textInput.text == "Start typing here!"){
            let alertController = UIAlertController(title: "Notification", message: "Your message is empty", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else{
            
            let note = textInput.text
            
            let defaults = UserDefaults.standard
            let chapID = defaults.string(forKey:"chapID") ?? "noval"
            let fname = defaults.string(forKey:"firstName") ?? "noval"
            
            var ref: DatabaseReference!
            ref = Database.database().reference().child("Chapters").child(chapID)

            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if(snapshot.hasChild("Users")){
                    let date = Date()
                    let format = DateFormatter()
                    format.dateFormat = "MM/dd/yyyy HH:mm:ss"
                    let timestamp = format.string(from: date)
                    
                    let generalDict = snapshot.value as! [String: Any]
                    let allUsers = generalDict["Users"] as! [String: Any]
                    let allAdvisers = generalDict["Advisers"] as! [String: Any]
                    
                    //add to massmesages child
                    var massMessageRef: DatabaseReference!
                    massMessageRef = ref.child("MassMessages").childByAutoId();
                    
                    massMessageRef.child("todevice_tokens").setValue("tempval");
                    massMessageRef.child("Title").setValue("Mass Message from " + fname);
                    massMessageRef.child("Message").setValue(note);
                    massMessageRef.child("Timestamp").setValue(timestamp);
                    
                    
                    //create notification in each user uid
                    for rest in allUsers {
                        let userKey = rest.key
                       
                        var notifRef: DatabaseReference!
                        notifRef = ref.child("Users").child(userKey) .child("Notifications").childByAutoId();
                        notifRef.child("Title").setValue("Mass Message from " + fname);
                        notifRef.child("Message").setValue(note);
                        notifRef.child("Timestamp").setValue(timestamp);
                    }
                    
                    //create notification in each adviser uid
                    for rest in allAdvisers  {
                        
                        let adviserKey = rest.key as! String
                        if(adviserKey != "device_tokens"){
                            var notifRef: DatabaseReference!
                            notifRef = ref.child("Advisers").child(adviserKey) .child("Notifications").childByAutoId();
                            notifRef.child("Title").setValue("Mass Message from " + fname);
                            notifRef.child("Message").setValue(note);
                            notifRef.child("Timestamp").setValue(timestamp);
                        }
                        
                    }
                    
                    let alertController = UIAlertController(title: "Notification", message: "Message sent!", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                   
                }else{
                    let alertController = UIAlertController(title: "Unable to send", message: "You have no users in your chapter yet, unable to send", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBOutlet weak var textInput: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
