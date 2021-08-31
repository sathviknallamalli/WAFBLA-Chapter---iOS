//
//  CreateAccountViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/20/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateAccountViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var gradPicker: UIPickerView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var createEmail: UITextField!
    @IBOutlet weak var createPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    var chapterID: String = "Anonymous"
    var chapName: String = "Anonymous"
    var childID: String = "Anonymous"
    var role: String = "AnonymousRole"
    var chapLogo: String = "AnonymousRole"

    var selectedGrad = ""
    
    @IBOutlet var chapNameText: UILabel!
    
    @IBOutlet var chapImg: UIImageView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gradData.count
    }

    @IBOutlet var createBut: UIButton!
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        selectedGrad = gradData[row]
       return gradData[row]
    }

    @IBOutlet var scrollView: UIScrollView!
    var gradData: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeButton(buttonName: createBut)
        scrollView.showsVerticalScrollIndicator = false
        // Do any additional setup after loading the view.
        self.gradPicker.delegate = self
               self.gradPicker.dataSource = self
        chapNameText.text = role + ": " + chapName
        
        if(role == "Adviser"){
            gradPicker.isHidden = true
        }
        
        self.hideKeyboardWhenTappedAround() 
        
        self.firstName.delegate = self
            self.lastName.delegate = self
        self.username.delegate = self
        self.createEmail.delegate = self
        self.createPassword.delegate = self
        self.confirmPassword.delegate = self
        
        let url = URL(string: chapLogo)
        let data = try? Data(contentsOf: url!)
        self.chapImg.image = UIImage(data: data!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       

        gradData = ["Graduation year", "2021", "2022", "2023", "2024"]
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
   
    
    @IBAction func createAccount(sender: UIButton) {
        let email = createEmail.text
        let password = createPassword.text
        var ref: DatabaseReference!
        let whiteSpace = " "
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")

        ref = Database.database().reference()
        if(email == "" || password == "" || confirmPassword.text == "" || selectedGrad == "Graduation year" || firstName.text == "" || lastName.text == "" || username.text == ""){
            let alertController = UIAlertController(title: "Error", message: "Incomplete field(s)", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else if(confirmPassword.text != password){
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
        } else if(password!.rangeOfCharacter(from: characterset.inverted) == nil){
            let alertController = UIAlertController(title: "Error", message: "Password must contain a special character", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else if(password!.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil){
            let alertController = UIAlertController(title: "Error", message: "Password must contain a number", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else if(firstName.text!.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil || lastName.text!.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil){
            let alertController = UIAlertController(title: "Error", message: "Names cannot contain numbers", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else{
            
            
            let alertController = UIAlertController(
                title: "Privacy Policy", message: "This app utilizes the Firebase Services. It includes utilizing the Firebase Database and Authentication and Notification Services. It will collect personal information such as name, email, username, password, and device ID to complete the necessary actions. If you agree to these terms, click Agree below to proceed.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Agree",  style: UIAlertAction.Style.default, handler: { // Also action dismisses AlertController when pressed.
                        action in

                Auth.auth().createUser(withEmail: email!, password: password!) { [self] authResult, error in
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
                                              print("Create User Error: \(error!)")
                                      }
                                  }

                              }else {
                                 //all good, add to database
                                  let user = Auth.auth().currentUser
                                  ref = ref.child("Chapters").child(self.chapterID).child(childID).child(user!.uid)
                                  ref.child("username").setValue(username.text)
                                  ref.child("email").setValue(email)
                                  ref.child("fname").setValue(firstName.text)
                                  ref.child("lname").setValue(lastName.text)
                                  ref.child("uid").setValue(user?.uid)
                                  ref.child("role").setValue(role)
                                  
                                  if(role == "Member"){
                                      ref.child("graduationyear").setValue(selectedGrad)
                                  }
                                  ref.child("device_token").setValue("tempval")
                                  
                                  let defaults = UserDefaults.standard
                                  defaults.set(firstName.text, forKey: "firstName")
                                  defaults.set(lastName.text, forKey: "lastName")
                                  defaults.set(firstName.text! + " " + lastName.text!, forKey: "fullname")
                                  defaults.set(email, forKey: "email")
                                  
                                  defaults.set(self.chapterID, forKey: "chapID")
                                  defaults.set(chapName, forKey: "chapName")
                                  defaults.set(role, forKey: "role")
                                  defaults.set(childID, forKey: "childID")
                                
                              
                                  let story = UIStoryboard(name: "Main", bundle: nil)
                                  let controller = story.instantiateViewController(identifier: "SWRevealViewController") as! SWRevealViewController

                                  self.present(controller, animated: true, completion: nil)


                              }
                          }

            })
           
            alertController.addAction(action)// add action to alert
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            self.present(alertController, animated: true, completion: nil)
            
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
