//
//  DrawerController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/23/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class DrawerController: UITableViewController {
    var items = [DrawerItemDetails]()
    var headerItem = [HeaderDetails]()


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        items.removeAll()
        headerItem.removeAll()
        loadSampleMeals()
    }
    override func viewDidLoad() {
        super.viewDidLoad()


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 242
        }else{
            return 56
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let defaults = UserDefaults.standard
        let role = defaults.string(forKey:"role") ?? "noval"
        let item = items[indexPath.row]
        if(item.title == "Competitive Events"){
            performSegue(withIdentifier: "compEventSegue", sender: tableView)
        }else if(item.title == "Choose your FBLA Event"){
            performSegue(withIdentifier: "chooseSegue", sender: tableView)
        }else if(item.title == "Updates"){
            performSegue(withIdentifier: "updateSegue", sender: tableView)
        }else if(item.title == "General Info"){
            performSegue(withIdentifier: "generalSegue", sender: tableView)
        }else if(item.title=="Check in to Meeting"){
            performSegue(withIdentifier: "meetingSegue", sender: tableView)
        }else if(item.title == "Manage Meetings"){
            performSegue(withIdentifier: "startMeetingSegue", sender: tableView)
        }else if(item.title == "Notifications"){
            performSegue(withIdentifier: "notificationSegue", sender: tableView)
        }else if(item.title == "Chapter Settings"){
            performSegue(withIdentifier: "chapterSettingsSegue", sender: tableView)
        }else if(item.title == "Chapter Stats"){
            performSegue(withIdentifier: "statsSegue", sender: tableView)
        } else if(item.title == "Privacy Policy"){
            performSegue(withIdentifier: "privacySegue", sender: tableView)
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cellIdentifier = "TestCell"
            
           

            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HeaderCell  else {
                fatalError("The dequeued cell is not an instance of TestCell.")
            }
            let meal = headerItem[0]
            cell.chapNameTitle.text = meal.chapName
            cell.nameTitle.text = meal.fname + " " + meal.lname
            cell.emailTitle.text = meal.email
            
            let lblNameInitialize = UILabel()
            lblNameInitialize.font = lblNameInitialize.font.withSize(40)

              lblNameInitialize.frame.size = CGSize(width: 100.0, height: 100.0)
              lblNameInitialize.textColor = UIColor.white
            lblNameInitialize.text = String(meal.fname.uppercased().first!) + String(meal.lname.uppercased().first!)
              lblNameInitialize.textAlignment = NSTextAlignment.center
              lblNameInitialize.backgroundColor = UIColor.black

              UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
              lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
            cell.userAvatar.layer.cornerRadius = 25
            cell.userAvatar.image = UIGraphicsGetImageFromCurrentImageContext()
              UIGraphicsEndImageContext()
            
            cell.viewController = self
            

            return cell
        }
        
        else{
            let cellIdentifier = "DrawerItem"

            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DrawerItem  else {
                fatalError("The dequeued cell is not an instance of DrawerCell.")
            }
            let meal = items[indexPath.row]
           
            cell.itemTitle.text = meal.title
            cell.itemImage.image = meal.imgval
            
            return cell
        }
        
    }
    
    
    private func loadSampleMeals() {
        
        let defaults = UserDefaults.standard
        let fname = defaults.string(forKey:"firstName") ?? "noval"
        let lname = defaults.string(forKey:"lastName") ?? "noval"
        let email = defaults.string(forKey:"email") ?? "noval"
        let chapName = defaults.string(forKey:"chapName") ?? "noval"

        guard let filler = HeaderDetails(chapName: chapName, fname: fname, lname: lname,  email: email)  else {
                        fatalError("Unable to instantiate headeritem")
                  }

        self.headerItem += [filler]
        
        
        guard let drawerFiller = DrawerItemDetails(title: "Filler", imgval: #imageLiteral(resourceName: "wafbla"))  else {
                        fatalError("Unable to instantiate draweritem")
                  }
        guard let updateItem = DrawerItemDetails(title: "Competitive Events", imgval:  UIImage(systemName: "creditcard.fill") ?? #imageLiteral(resourceName: "wafbla"))  else {
                        fatalError("Unable to instantiate draweritem")
                  }
        guard let updateItem2 = DrawerItemDetails(title: "Choose your FBLA Event", imgval: UIImage(systemName: "filemenu.and.selection") ?? #imageLiteral(resourceName: "wafbla"))  else {
                        fatalError("Unable to instantiate draweritem")
                  }
        guard let updateItem3 = DrawerItemDetails(title: "General Info", imgval: UIImage(systemName: "info.circle.fill") ?? #imageLiteral(resourceName: "wafbla"))  else {
                        fatalError("Unable to instantiate draweritem")
                  }
        guard let updateItem4 = DrawerItemDetails(title: "Updates", imgval: UIImage(systemName: "newspaper") ?? #imageLiteral(resourceName: "wafbla"))  else {
                        fatalError("Unable to instantiate draweritem")
                  }
        
        
        guard let updateItem6 = DrawerItemDetails(title: "Chapter Stats", imgval: UIImage(systemName: "number.circle.fill") ?? #imageLiteral(resourceName: "wafbla"))  else {
                        fatalError("Unable to instantiate draweritem")
                  }
        
        
        guard let updateItem7 = DrawerItemDetails(title: "Notifications", imgval: UIImage(systemName: "bell.fill") ?? #imageLiteral(resourceName: "wafbla"))  else {
                        fatalError("Unable to instantiate draweritem")
                  }
        guard let updateItem8 = DrawerItemDetails(title: "Privacy Policy", imgval: UIImage(systemName: "lock.fill") ?? #imageLiteral(resourceName: "wafbla"))  else {
                        fatalError("Unable to instantiate draweritem")
                  }
        self.items += [drawerFiller]
        self.items += [updateItem]
        self.items += [updateItem2]
        self.items += [updateItem3]
        self.items += [updateItem4]
        
        let role = defaults.string(forKey:"role") ?? "noval"
        if(role == "Adviser"){
            guard var updateItem5 = DrawerItemDetails(title: "Manage Meetings", imgval: UIImage(systemName: "wrench.and.screwdriver") ?? #imageLiteral(resourceName: "wafbla"))  else {
                            fatalError("Unable to instantiate draweritem")
                      }
            guard var settingsitem = DrawerItemDetails(title: "Chapter Settings", imgval: UIImage(systemName: "person.3.fill") ?? #imageLiteral(resourceName: "wafbla"))  else {
                            fatalError("Unable to instantiate draweritem")
                      }
            self.items += [updateItem5]
            self.items += [settingsitem]

        }else{
            guard var updateItem5 = DrawerItemDetails(title: "Check in to Meeting", imgval: UIImage(systemName: "checkmark.circle.fill") ?? #imageLiteral(resourceName: "wafbla"))  else {
                            fatalError("Unable to instantiate draweritem")
                      }
            self.items += [updateItem5]

        }
        self.items += [updateItem6]
        self.items += [updateItem7]
        self.items += [updateItem8]


        self.tableView.reloadData()
    
    }

}
