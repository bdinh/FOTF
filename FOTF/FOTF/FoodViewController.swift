//
//  FoodViewController.swift
//  FOTF
//
//  Created by Sabrina Niklaus on 5/18/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseDatabase

class FoodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var entryData = [String]()
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    
    @IBOutlet weak var foodTableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = foodTableView.dequeueReusableCell(withIdentifier: "foodEntryCell")
        cell?.textLabel?.text = entryData[indexPath.row]
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            // remove from firebase
//            entryData.remove(at: indexPath.row)
//            
//            let entry = self.entryData[indexPath.row]
//                
//            
//            Database.database().reference().child("foodEntry").child(<#T##pathString: String##String#>)
//            foodTableView.reloadData()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        foodTableView.delegate = self
        foodTableView.dataSource = self
        
        
        ref = Database.database().reference()
        databaseHandle = ref?.child("foodEntry").observe(.childAdded, with: { (snapshot) in
            let entry = snapshot.value as? String
            
            if let actualEntry = entry {
                self.entryData.append(actualEntry)
                self.foodTableView.reloadData()
            }

        })
        
//        
//        retrieveDataFromDatabase(ref!)
        
        foodTableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


//    func retrieveDataFromDatabase(reference: DatabaseReference) {
//        databaseHandle = reference.child("foodEntry").observe(.childAdded) { (snapshot) in
//            <#code#>
//        }
//        
//    }
}

