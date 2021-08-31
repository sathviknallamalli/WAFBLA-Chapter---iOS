//
//  NewsViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/23/21.
//

import UIKit
import FirebaseDatabase

class GeneralInfoViewController: UIViewController {

   
    @IBOutlet var themeLogo: UIImageView!
    @IBOutlet var chapterLogo: UIImageView!
    @IBOutlet var chapname: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let chapID = defaults.string(forKey:"chapID") ?? "noval"
        
        var ref: DatabaseReference!
        ref = Database.database().reference()

        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as! [String: Any]
            let themeVal = dict["ThemeLogo"] as! String
            
            let generalDict = dict["Chapters"] as! [String: Any]
            let chapDict = generalDict[chapID] as! [String: Any]

            let imageDict = chapDict["Images"] as! [String: Any]
            let setupDict = chapDict["Setup"] as! [String: Any]
            let imageVal = imageDict["ChapterLogo"] as! String
            let name = setupDict["ChapterName"] as! String

            self.chapname.text = name + " FBLA"
            
            let url = URL(string: imageVal)
            let data = try? Data(contentsOf: url!)
            self.chapterLogo.image = UIImage(data: data!)
            var profilePicture = UIImage(data: data!)
            profilePicture = profilePicture?.circleMasked
            self.chapterLogo.image = profilePicture

            
            let themeUrl = URL(string: themeVal)
            let themeData = try? Data(contentsOf: themeUrl!)
            self.themeLogo.image = UIImage(data: themeData!)
        })

        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"

           // revealViewController().rightViewRevealWidth = 150
           
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        
        }
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

}
extension UIImage {
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
    var breadthRect: CGRect  { .init(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        guard let cgImage = cgImage?
            .cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
                                              y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
                                size: breadthSize)) else { return nil }
        let format = imageRendererFormat
        format.opaque = false
        return UIGraphicsImageRenderer(size: breadthSize, format: format).image { _ in
            UIBezierPath(ovalIn: breadthRect).addClip()
            UIImage(cgImage: cgImage, scale: format.scale, orientation: imageOrientation)
            .draw(in: .init(origin: .zero, size: breadthSize))
        }
    }
}
