//
//  LastStepViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/22/21.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class LastStepViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {

    var chapterID: String = "Anonymous"

    @IBOutlet var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeButton(buttonName: finishBut)
        imagePicker.delegate = self
        scrollView.showsVerticalScrollIndicator = false

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
   
    @IBOutlet var logoImgBut: UIButton!
    @IBOutlet var finishBut: UIButton!
    var imagePicker = UIImagePickerController()

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("here")
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        logoImgBut.setImage(image, for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoClick(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func finishClick(_ sender: Any) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref = ref.child("Chapters").child(chapterID).child("Images")
        
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        if(self.logoImgBut.imageView?.image == nil){
            
            let alertController = UIAlertController(title: "Setup Fail", message: "Choose a valid logo for your chapter", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else{
            let uploadData = (self.logoImgBut.imageView?.image)!.pngData()!

            storageRef.child("\(chapterID)ImageFolder/logo.png").putData(uploadData, metadata: nil, completion:  {_, error in
                guard error==nil else{
                               print("failed")
                               return
                    }
                storageRef.child("\(self.chapterID)ImageFolder/logo.png").downloadURL(completion: {url, error in
                    guard let url = url, error == nil else{
                        return
                    }
                    let urlString = url.absoluteString
                    ref.child("ChapterLogo").setValue(urlString)
                })
            })

            self.performSegue(withIdentifier: "toAllDone", sender: self)
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
        if (segue.identifier == "toAllDone") {
            let vc = segue.destination as! AllDoneViewController
        }
    }
    
}
