//
//  ViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/19/21.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet var joinButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        customizeButton(buttonName: joinButton)
        customizeButton(buttonName: registerButton)
        customizeButton(buttonName: loginButton)
        scrollView.showsVerticalScrollIndicator = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func customizeButton(buttonName: UIButton){
        let borderColor = (UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0))
        buttonName.layer.cornerRadius = 10
        buttonName.layer.borderWidth = 1.0
        buttonName.titleEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        buttonName.layer.borderColor = UIColor.white.cgColor
        
    }
    
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
