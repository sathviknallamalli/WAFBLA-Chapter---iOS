//
//  SettingsViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/24/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SettingsViewController: UIViewController {
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var roleField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roleField.isEnabled = false
        emailField.isEnabled = false
        
        let defaults = UserDefaults.standard
        let chapID = defaults.string(forKey:"chapID") ?? "noval"
        let role = defaults.string(forKey:"role") ?? "noval"
        let childID = defaults.string(forKey:"childID") ?? "noval"

        var ref: DatabaseReference!
       
            ref = Database.database().reference().child("Chapters").child(chapID).child(childID)
       

        ref.child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let userDict = snapshot.value as! [String: Any]
            let fname = userDict["fname"] as! String
            let lname = userDict["lname"] as! String
            let email = userDict["email"] as! String
            
            self.roleField.text = role
            self.firstNameField.text = fname
            self.lastNameField.text = lname
            self.emailField.text = email
            
            let lblNameInitialize = UILabel()
            lblNameInitialize.font = lblNameInitialize.font.withSize(40)

              lblNameInitialize.frame.size = CGSize(width: 100.0, height: 100.0)
              lblNameInitialize.textColor = UIColor.white
            lblNameInitialize.text = String(fname.uppercased().first!) + String(lname.uppercased().first!)
              lblNameInitialize.textAlignment = NSTextAlignment.center
              lblNameInitialize.backgroundColor = UIColor.black

              UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
              lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
            self.avatarImage.layer.cornerRadius = 20
            self.avatarImage.image = UIGraphicsGetImageFromCurrentImageContext()
              UIGraphicsEndImageContext()
        })

      
        // Do any additional setup after loading the view.
    }
    

    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
      do {
        try firebaseAuth.signOut()
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        self.present(controller, animated: true, completion: nil)
      } catch let signOutError as NSError {
        print ("Error signing out: %@", signOutError)
      }
    }
    
    @IBAction func save(_ sender: Any) {
        let defaults = UserDefaults.standard
        let role = defaults.string(forKey:"role") ?? "noval"
        let chapID = defaults.string(forKey:"chapID") ?? "noval"


        var ref: DatabaseReference!
        if(role == "Member"){
            ref = Database.database().reference().child("Chapters").child(chapID).child("Users").child(Auth.auth().currentUser!.uid)
        }else if(role == "Adviser"){
            ref = Database.database().reference().child("Chapters").child(chapID).child("Advisers").child(Auth.auth().currentUser!.uid)
        }
        
        ref.child("fname").setValue(firstNameField.text)
        ref.child("lname").setValue(lastNameField.text)
        ref.child("email").setValue(emailField.text)
        
        defaults.set(firstNameField.text, forKey: "firstName")
        defaults.set(lastNameField.text, forKey: "lastName")
        defaults.set(emailField.text, forKey: "email")

        let alertController = UIAlertController(title: "Chapter Settings", message: "Updated!", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
