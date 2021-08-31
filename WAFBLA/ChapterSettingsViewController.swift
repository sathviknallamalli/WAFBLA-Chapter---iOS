//
//  StatsViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/25/21.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class ChapterSettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {

    @IBOutlet var imageButton: UIButton!
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var adviser: UITextField!
    @IBOutlet var member: UITextField!
    @IBOutlet var state: UIPickerView!
    @IBOutlet var zip: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var id: UITextField!
    
    var selectedState = ""
    var stateData: [String] = [String]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    var imagePicker = UIImagePickerController()
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        selectedState = stateData[row]
       return stateData[row]
    }
    
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        imageButton.setImage(image, for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.state.delegate = self
        self.state.dataSource = self

        imagePicker.delegate = self
        stateData = ["Alabama", "Alaska", "American Samoa", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia", "Guam", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Minor Outlying Islands", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Northern Mariana Islands", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "U.S. Virgin Islands", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]

        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let defaults = UserDefaults.standard
        let chapID = defaults.string(forKey:"chapID") ?? "noval"
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("Chapters").child(chapID)

        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as! [String: Any]
            let setupDict = dict["Setup"] as! [String: Any]
            let roleDict = dict["JoinCodes"] as! [String: Any]
            let imageDict = dict["Images"] as! [String: Any]
            let chapName = setupDict["ChapterName"] as! String
            let chapZip = setupDict["Zip"] as! String
            let chapState = setupDict["State"] as! String
            let memberkey = roleDict["MemberCode"] as! String
            let adviserkey = roleDict["AdviserCode"] as! String
            let imageVal = imageDict["ChapterLogo"] as! String

            self.id.text = chapID
            self.name.text = chapName
            self.zip.text = chapZip
            let val = self.stateData.firstIndex(of: chapState)
            self.state.selectRow(val!, inComponent: 0, animated: true)
            self.member.text = "Member code: " + memberkey
            self.adviser.text = "Adviser code: " + adviserkey
           
                let url = URL(string: imageVal)
                let data = try? Data(contentsOf: url!)
                self.imageButton.setImage(UIImage(data: data!), for: .normal)
            
            

        })
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        let chapID = defaults.string(forKey:"chapID") ?? "noval"
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("Chapters").child(chapID)

        ref.child("Setup").child("ChapterName").setValue(name.text)
        ref.child("Setup").child("State").setValue(stateData[state.selectedRow(inComponent: 0)])
        ref.child("Setup").child("Zip").setValue(zip.text)
        
        defaults.set(name.text, forKey: "chapName")
      
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let uploadData = (self.imageButton.imageView?.image)!.pngData()!

        storageRef.child("\(chapID)ImageFolder/logo.png").putData(uploadData, metadata: nil, completion:  {_, error in
            guard error==nil else{
                           print("failed")
                           return
                }
            storageRef.child("\(chapID)ImageFolder/logo.png").downloadURL(completion: {url, error in
                guard let url = url, error == nil else{
                    return
                }
                let urlString = url.absoluteString
                ref.child("Images").child("ChapterLogo").setValue(urlString)

            })
        })
        
          

        let alertController = UIAlertController(title: "Chapter Settings", message: "Updated!", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func imgClick(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    

}
