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
import FirebaseAuth

class FoodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var entryData: [String] = []
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    var userFoodJournal: [DateEntry] = []
    var testJournal: [DateEntry] = []
    
    @IBOutlet weak var foodTableView: UITableView!

    
    // Throws an error need fixing
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MOCK DATA
        let foodObject = Food()
        foodObject.title = self.entryData[(tableView.indexPathForSelectedRow!.row)]
        foodObject.calories = "120"
        foodObject.fat = "4"
        foodObject.sodium = "70"
        foodObject.cholesterol = "5"
        foodObject.sugar = "13"
        foodObject.protein = "2"
        foodObject.brand = "Breyers"
        foodObject.servingSize = "0.5"
        foodObject.servingUnit = "cup"
        
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "FoodDetailVC") as! FoodDetailViewController
        detailController.foodObject = foodObject
        self.present(detailController, animated: true, completion: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        foodTableView.delegate = self
        foodTableView.dataSource = self
        let addingNewDate = DateEntry()
        addingNewDate.date = "June 5, 2017"
        let addingFood = Food()
        addingFood.title = "test"
        let addingFood2 = Food()
        addingFood2.title = "test2"
        addingNewDate.foodList.append(addingFood)
        addingNewDate.foodList.append(addingFood2)
        self.testJournal.append(addingNewDate)
        
        foodTableView.allowsMultipleSelectionDuringEditing = true
        
        var currentUser = Auth.auth().currentUser?.email as! String
        currentUser = currentUser.replacingOccurrences(of: ".", with: ",")
        
        ref = Database.database().reference()
        ref?.child("foodEntry").child(currentUser).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.userFoodJournal = []
                for dateEntry in dictionary {
                    let newDate = DateEntry()
                    newDate.date = dateEntry.key
                    if let foodEntry = dateEntry.value as? [String: AnyObject] {
                        for foodItem in foodEntry {
                            let newFoodEntry = Food()
                            if let foodDetail = foodItem.value as? [String: String] {
                                newFoodEntry.title = foodDetail["title"]!
                                newFoodEntry.calories = foodDetail["calories"]!
                                newFoodEntry.fat = foodDetail["fat"]!
                                newFoodEntry.sugar = foodDetail["sugar"]!
                                newFoodEntry.brand = foodDetail["brand"]!
                                newFoodEntry.protein = foodDetail["protein"]!
                                newFoodEntry.servingUnit = foodDetail["servingUnit"]!
                                newFoodEntry.servingSize = foodDetail["servingSize"]!
                                newFoodEntry.cholesterol = foodDetail["cholesterol"]!
                                newFoodEntry.sodium = foodDetail["sodium"]!
                                newDate.foodList.append(newFoodEntry)
                            }
                            
                        }
                    }
                    self.userFoodJournal.append(newDate)
                }
            }
            self.foodTableView.reloadData()

        })

        

    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return userFoodJournal.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return userFoodJournal[section].date
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userFoodJournal[section].foodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = foodTableView.dequeueReusableCell(withIdentifier: "foodEntryCell")
        cell?.textLabel?.text = userFoodJournal[indexPath.section].foodList[indexPath.row].title
        return cell!
        
        
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var currentUser = Auth.auth().currentUser?.email as! String
            currentUser = currentUser.replacingOccurrences(of: ".", with: ",")
            let foodItem = userFoodJournal[indexPath.section].foodList[indexPath.row].title
            let deletedate = userFoodJournal[indexPath.section].date
            
            let query = ref?.child("foodEntry").child(currentUser).child(deletedate).queryOrdered(byChild: "title").queryEqual(toValue: foodItem)
                
                
//                query.observe(.value, with: { (snapshot) in
//                    print(snapshot.value)
//                })
            
            query?.observeSingleEvent(of: .value, with: { (snapshot) in
                if let deleteSnap = snapshot.value as? [String: AnyObject] {
                    var deleteID = ""
                    for (key, value) in deleteSnap {
                        deleteID = key
                        print(deleteID)
                    }
                    self.ref?.child("foodEntry").child(currentUser).child(deletedate).child(deleteID).removeValue()
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

