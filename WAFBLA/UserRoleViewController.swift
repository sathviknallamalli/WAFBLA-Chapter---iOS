//
//  UserRoleViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/21/21.
//

import UIKit
import FirebaseDatabase

class UserRoleViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    @IBOutlet var contButton: UIButton!
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        selectedRole = pickerData[row]
       return pickerData[row]
    }
    
    func customizeButton(buttonName: UIButton){
        let borderColor = (UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0))
        buttonName.layer.cornerRadius = 10
        buttonName.layer.borderWidth = 1.0
        buttonName.titleEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        buttonName.layer.borderColor = UIColor.white.cgColor
        
    }

    @IBOutlet weak var enteredKey: UITextField!
    var chapterID: String = "Anonymous"
    var selectedRole = ""
    var chapName = ""
    var logo = ""
    var childID = ""

    @IBOutlet weak var picker: UIPickerView!
    var pickerData: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeButton(buttonName: contButton)

        // Do any additional setup after loading the view.
        
        self.picker.delegate = self
               self.picker.dataSource = self

        pickerData = ["Select your role", "Member", "Adviser"]

    }
    
    
    @IBAction func verifyKey(_ sender: Any) {
        let key = enteredKey.text
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        if(selectedRole == "Select your role"){
            let alertController = UIAlertController(title: "Error", message: "Select a valid role", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else{
            let selectedRoleKey = selectedRole + "Code"
            
            ref.child("Chapters").child(chapterID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let chapDict = snapshot.value as! [String: Any]
                let codeDict = chapDict["JoinCodes"] as! [String: Any]
                let setupDict = chapDict["Setup"] as! [String: Any]
                let imgDict = chapDict["Images"] as! [String: Any]
                self.logo = imgDict["ChapterLogo"] as! String

                let roleKey = codeDict[selectedRoleKey] as! String
                self.chapName = setupDict["ChapterName"] as! String

                if(key == roleKey){
                  

                    if( self.selectedRole=="Member"){
                        self.childID = "Users"
                    }else if( self.selectedRole == "Adviser"){
                        self.childID = "Advisers"
                    }
                    self.performSegue(withIdentifier: "toCreateAccount", sender: self)
                }else{
                    let alertController = UIAlertController(title: "Error", message: "Keys dont match", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
                
            })
        }

       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toCreateAccount") {
            let vc = segue.destination as! CreateAccountViewController
            
            vc.chapterID = self.chapterID
            vc.role = self.selectedRole
            vc.chapName = self.chapName
            vc.chapLogo = self.logo
            vc.childID = self.childID
        }
    }

}
