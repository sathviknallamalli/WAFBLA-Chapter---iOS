//
//  AdviserAccountViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/22/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AdviserAccountViewController: UIViewController, UITextFieldDelegate {
    
    var chapterID: String = "Anonymous"
    var chapName: String = "Anonymous"

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contButton: UIButton!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.showsVerticalScrollIndicator = false
        
        self.hideKeyboardWhenTappedAround()
        self.firstName.delegate = self
        self.lastName.delegate = self
        self.username.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        self.confirmPassword.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        customizeButton(buttonName: contButton)
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
    @IBAction func `continue`(_ sender: Any) {
        var ref: DatabaseReference!
        ref = Database.database().reference()

        let whiteSpace = " "
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if(email.text == "" || password.text == "" || confirmPassword.text == "" || firstName.text == "" || lastName.text == "" || username.text == ""){
            let alertController = UIAlertController(title: "Error", message: "Incomplete field(s)", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else if(confirmPassword.text != password.text){
            let alertController = UIAlertController(title: "Error", message: "Passwords must match", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
    
        }else if (username.text == firstName.text || username.text == lastName.text) {
            let alertController = UIAlertController(title: "Error", message: "Invalid username", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else if ((firstName.text!.contains(" ")) || lastName.text!.contains(" ")) {
            let alertController = UIAlertController(title: "Error", message: "Names cannot contain spaces", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else if(password.text!.rangeOfCharacter(from: characterset.inverted) == nil){
            let alertController = UIAlertController(title: "Error", message: "Password must contain a special character", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else if(password.text!.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil){
            let alertController = UIAlertController(title: "Error", message: "Password must contain a number", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else if(firstName.text!.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil || lastName.text!.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil){
            let alertController = UIAlertController(title: "Error", message: "Names cannot contain numbers", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else{
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { [self] authResult, error in
                // ...
               
                if error != nil {

                    if let errCode = AuthErrorCode(rawValue: error!._code) {

                        switch errCode {
                        case .invalidEmail:
                            let alertController = UIAlertController(title: "Error", message: "Invalid email ID", preferredStyle: UIAlertController.Style.alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        case .emailAlreadyInUse:
                            let alertController = UIAlertController(title: "Error", message: "Email ID already exists", preferredStyle: UIAlertController.Style.alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                            default:
                                print("Create Adviser Error: \(error!)")
                        }
                    }

                }else {
                   //all good, add to database
                    let user = Auth.auth().currentUser
                    ref = ref.child("Chapters").child(self.chapterID).child("Advisers").child(user!.uid)
                    ref.child("username").setValue(username.text)
                    ref.child("email").setValue(email.text)
                    ref.child("fname").setValue(firstName.text)
                    ref.child("lname").setValue(lastName.text)
                    ref.child("uid").setValue(user?.uid)
                    ref.child("role").setValue("Adviser")
                    ref.child("device_token").setValue("tempval")

                    
                    let defaults = UserDefaults.standard
                    defaults.set(firstName.text, forKey: "firstName")
                    defaults.set(lastName.text, forKey: "lastName")
                    defaults.set(firstName.text! + " " + lastName.text!, forKey: "fullname")
                    defaults.set(email.text, forKey: "email")
                    
                    defaults.set(self.chapterID, forKey: "chapID")
                    defaults.set(chapName, forKey: "chapName")
                    defaults.set("Adviser", forKey: "role")
                    defaults.set("Advisers", forKey: "childID")
                    
                    self.performSegue(withIdentifier: "toRoleKeys", sender: self)

                    

                }
            }
        }

        
      
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height/2)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func customizeButton(buttonName: UIButton){
        let borderColor = (UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0))
        buttonName.layer.cornerRadius = 10
        buttonName.layer.borderWidth = 1.0
        buttonName.titleEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        buttonName.layer.borderColor = UIColor.white.cgColor
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toRoleKeys") {
            let vc = segue.destination as! RoleViewController
            vc.chapterID = chapterID
        }
    }
}
