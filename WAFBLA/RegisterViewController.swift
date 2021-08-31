//
//  RegisterViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/22/21.
//

import UIKit
import FirebaseDatabase

class RegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var chapZip: UITextField!
    @IBOutlet weak var chapName: UITextField!
    @IBOutlet weak var chapID: UITextField!
    
    var selectedState = ""
    var stateData: [String] = [String]()


    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateData.count
    }
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var regButton: UIButton!
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        selectedState = stateData[row]
       return stateData[row]
    }
    func customizeButton(buttonName: UIButton){
        let borderColor = (UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0))
        buttonName.layer.cornerRadius = 10
        buttonName.layer.borderWidth = 1.0
        buttonName.titleEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        buttonName.layer.borderColor = UIColor.white.cgColor
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.showsVerticalScrollIndicator = false
        self.chapName.delegate = self
        self.chapID.delegate = self
        self.chapZip.delegate = self

        customizeButton(buttonName: regButton)
        self.hideKeyboardWhenTappedAround()


        // Do any additional setup after loading the view.
        self.statePicker.delegate = self
               self.statePicker.dataSource = self

        stateData = ["Select your state", "Alabama", "Alaska", "American Samoa", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia", "Guam", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Minor Outlying Islands", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Northern Mariana Islands", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "U.S. Virgin Islands", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
    
    
    @IBAction func registerChap(_ sender: Any) {
        let id = chapID.text
        let zip = chapZip.text
        let name = chapName.text
        var ref: DatabaseReference!
        ref = Database.database().reference()

        if(id == "" || zip == "" || name == "" || selectedState == "Select your state"){
            let alertController = UIAlertController(title: "Error", message: "Incomplete field(s)", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else{
            
            ref.child("Chapters").child(id!).observeSingleEvent(of: .value, with: { (snapshot) in
                if(snapshot.exists()){
                    let alertController = UIAlertController(title: "Error", message: "Chapter already exists, use the join code to join your chapter", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    ref = ref.child("Chapters").child(id!).child("Setup")
                    ref.child("ChapterName").setValue(name)
                    ref.child("ID").setValue(id)
                    ref.child("State").setValue(self.selectedState)
                    ref.child("Zip").setValue(zip)
                    
                    self.performSegue(withIdentifier: "regAdvAccount", sender: self)

                    
                }
                
            })
            
           
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "regAdvAccount") {
            let vc = segue.destination as! AdviserAccountViewController
            vc.chapterID = chapID.text!
            vc.chapName = chapName.text!
            
        }
    }
}
