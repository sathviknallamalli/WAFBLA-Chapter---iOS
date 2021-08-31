//
//  SecondViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/20/21.
//

import UIKit
import FirebaseMessaging
import FirebaseDatabase
import FirebaseAuth


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var loginBut: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeButton(buttonName: loginBut)
        self.emailText.keyboardType = UIKeyboardType.emailAddress
        self.hideKeyboardWhenTappedAround()

       

        self.emailText.delegate = self
            self.passwordText.delegate = self
        // Do any additional setup after loading the view.
      
    }
    
    private func tagBasedTextField(_ textField: UITextField) {
        let nextTextFieldTag = textField.tag + 1

        if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tagBasedTextField(textField)
        return true
    }
    

  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isUserLoggedIn() {
            updateUI()
            
        }
      }

    func isUserLoggedIn() -> Bool {
      return Auth.auth().currentUser != nil
    }
    
    func updateUI(){
        let defaults = UserDefaults.standard

        var ref: DatabaseReference!
        ref = Database.database().reference()
                
        let chapID = defaults.string(forKey:"chapID") ?? "noval"
        let childID = defaults.string(forKey:"childID") ?? "noval"
        print(childID + "HELLO")
        ref.child("Chapters").child(chapID).child(childID).child(Auth.auth().currentUser?.uid ?? "nouid").observeSingleEvent(of: .value, with: { (snapshot) in
            let userDict = snapshot.value as! [String: Any]
            let fname = userDict["fname"] as! String
            let lname = userDict["lname"] as! String
            let fullname = fname + " " + lname
            let email = userDict["email"] as! String
          
            defaults.set(fname, forKey: "firstName")
            defaults.set(lname, forKey: "lastName")
            defaults.set(fullname, forKey: "fullname")
            defaults.set(email, forKey: "email")


        })
        
        Messaging.messaging().subscribe(toTopic: "1111Advisers") { error in
          print("Subscribed to weather topic")
        }

        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "SWRevealViewController") as! SWRevealViewController
        controller.view.layoutIfNeeded() //avoid Snapshotting error

        self.present(controller, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func secondlevelauth(){
        print("second level auth started")
        
        let alert = UIAlertController(title: "Chapter ID", message: "Enter", preferredStyle: .alert)
        alert.addTextField { (textField) in
           
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            textField!.keyboardType = UIKeyboardType.numberPad

            let eneterdchapID = textField!.text
            
            if((eneterdchapID?.isEmpty) == nil){
                
                self.signOut()
                
                let alertController = UIAlertController(title: "Login Fail", message: "Enter an ID", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }else{
                self.isuserexists(enteredID: eneterdchapID!, callback: {(data: Bool) -> Void in
                    if(data){
                        print("callback true")
                        self.updateUI()
                    }else{
                        print("callback false")
                        //didnt exist, so callback false, and signout
                        self.signOut()
                    }
                    
                })
            }
            
         
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func isuserexists(enteredID: String, callback: @escaping ((_ data:Bool) ->Void )) {
        var ref: DatabaseReference!
        ref = Database.database().reference().child("Chapters").child(enteredID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if(snapshot.exists()){
                
                print("chapter exists")
                let chapDict = snapshot.value as! [String: Any]
                let setupDict = chapDict["Setup"] as! [String: Any]
                let chapName = setupDict["ChapterName"] as! String

                let defaults = UserDefaults.standard
                defaults.set(enteredID, forKey: "chapID")
                defaults.set(chapName, forKey: "chapName")

                if (snapshot.hasChild("Users/" + Auth.auth().currentUser!.uid)){
                    //exist in users, role is member
                    print("role is member, child is users")
                    defaults.set("Member", forKey: "role")
                    defaults.set("Users", forKey: "childID")
                    callback(true)

                }else if (snapshot.hasChild("Advisers/" + Auth.auth().currentUser!.uid)){
                    //exist in adviser, role is adviser
                    print("role is adviser, child is advisers")
                    defaults.set("Adviser", forKey: "role")
                    defaults.set("Advisers", forKey: "childID")
                    
                    callback(true)

                }else{
                    //dont exist in chapter, so signout
                    callback(false)
                }
              
               
            }else{
                //entered chapid doesnt exist, so signout
                callback(false)

                let alertController = UIAlertController(title: "Login Fail", message: "Invalid Chapter ID", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
          
        })
    }
    
    func signOut(){
        let firebaseAuth = Auth.auth()
      do {
        try firebaseAuth.signOut()
        
      } catch let signOutError as NSError {
        print ("Error signing out: %@", signOutError)
      }
    }

    @IBAction func login(sender: UIButton) {
        let email = emailText.text
        let password = passwordText.text
        
        if(email == "" || password == ""){
            let alertController = UIAlertController(title: "Error", message: "Incomplete field(s)", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else{
            
            Auth.auth().signIn(withEmail: email!, password: password!) { (authResult, error) in
              if let error = error as? NSError {

                switch AuthErrorCode(rawValue: error.code) {
                
                case .wrongPassword:
                    let alertController = UIAlertController(title: "Error", message: "Password incorrect", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    break;
                case .userNotFound:
                    let alertController = UIAlertController(title: "Error", message: "User with that email does not exist", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    break;
                case .invalidEmail:
                    let alertController = UIAlertController(title: "Error", message: "Email is malformed", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    break;
                default:
                    print("Error: \(error)")
                }
              } else {
                
                //need to do second level first
                self.secondlevelauth()

              }
            }
            
            
        }
        
      
       }
    func customizeButton(buttonName: UIButton){
        let borderColor = (UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0))
        buttonName.layer.cornerRadius = 10
        buttonName.layer.borderWidth = 1.0
        buttonName.titleEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        buttonName.layer.borderColor = UIColor.white.cgColor
        
    }
}
