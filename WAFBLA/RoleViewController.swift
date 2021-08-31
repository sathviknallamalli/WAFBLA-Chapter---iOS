//
//  RoleViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/22/21.
//

import UIKit
import FirebaseDatabase

class RoleViewController: UIViewController {
    
    var chapterID: String = "Anonymous"

    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contButton: UIButton!
    @IBOutlet weak var memberText: UILabel!
    @IBOutlet weak var adviserText: UILabel!
    
    @IBAction func pressedContinue(_ sender: Any) {
        self.performSegue(withIdentifier: "toLastStep", sender: self)

    }
    var memberKey = ""
    var adviserKey = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeButton(buttonName: contButton)
        scrollView.showsVerticalScrollIndicator = false
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("Chapters").child(chapterID).observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.hasChild("JoinCodes")){
                
                let dict = snapshot.value as! [String: Any]
                let joindict = dict["JoinCodes"] as! [String: Any]

                self.adviserKey = joindict["AdviserCode"] as! String
                self.memberKey = joindict["MemberCode"] as! String
                
                self.memberText.text = "Member code: " + self.memberKey
                self.adviserText.text = "Adviser code: " + self.adviserKey
            }else{
                self.adviserKey = self.randomString()
                self.memberKey = self.randomString()
                self.memberText.text = "Member code: " + self.memberKey
                self.adviserText.text = "Adviser code: " + self.adviserKey
                
                ref = ref.child("Chapters").child(self.chapterID).child("JoinCodes")
                ref.child("AdviserCode").setValue(self.adviserKey)
                ref.child("MemberCode").setValue(self.memberKey)
            }
        })
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
    func randomString() -> String {
      let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
      return String((0..<6).map{ _ in letters.randomElement()! })
    }
    
    func customizeButton(buttonName: UIButton){
        let borderColor = (UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0))
        buttonName.layer.cornerRadius = 10
        buttonName.layer.borderWidth = 1.0
        buttonName.titleEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        buttonName.layer.borderColor = UIColor.white.cgColor
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toLastStep") {
            let vc = segue.destination as! LastStepViewController
            vc.chapterID = chapterID
        }
    }
}
