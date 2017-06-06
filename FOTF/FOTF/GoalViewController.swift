//
//  GoalViewController.swift
//  FOTF
//
//  Created by Abhishek Chauhan on 6/6/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class GoalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var goalTableView: UITableView!
    
    var ref: DatabaseReference?
    var userGoalJournal = [Goal]()
    
    var goalObjects = [Goal]()
    var userExerciseJournal: [DateEntryExercise] = []
    var userFoodJournal: [DateEntryFood] = []
    var lastExerciseDay: String = ""
    var lastNutritionDay: String = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGoalJournal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let goalObject = self.userGoalJournal[indexPath.row]//self.goalObjects[indexPath.row]
        let cell = goalTableView.dequeueReusableCell(withIdentifier: "goalCell") as! GoalTableViewCell
        cell.typeGoal.text = goalObject.type
        cell.start_date.text = goalObject.start_date
        cell.end_date.text = goalObject.end_date
        if goalObject.type == "Nutrition" {
            cell.goalName.text = "Calories"
            cell.goalValue.text = goalObject.progress + " / " + goalObject.calories
        } else {
            cell.goalName.text = "Distance"
            cell.goalValue.text = goalObject.progress + " / " + goalObject.distance
        }
        cell.status.text = goalObject.status
        return cell
        
    }
    
    func processExercises() {
        var currentUser = (Auth.auth().currentUser?.email)!
        currentUser = currentUser.replacingOccurrences(of: ".", with: ",")
        
        ref = Database.database().reference()
        ref?.child("exerciseEntry").child(currentUser).observe(.value, with: { (snapshot) in
            self.userExerciseJournal = []
            if let dictionary = snapshot.value as? [String: AnyObject] {
                for dateEntry in dictionary {
                    let newDate = DateEntryExercise()
                    newDate.date = dateEntry.key
                    if let exerciseEntry = dateEntry.value as? [String: AnyObject] {
                        for exerciseItem in exerciseEntry {
                            let newExerciseEntry = Exercise()
                            if let exerciseDetail = exerciseItem.value as? [String: String] {
                                newExerciseEntry.type = exerciseDetail["type"]!
                                newExerciseEntry.description = exerciseDetail["description"]!
                                newExerciseEntry.distance = exerciseDetail["distance"]!
                                newExerciseEntry.duration = exerciseDetail["duration"]!
                                newExerciseEntry.reps = exerciseDetail["reps"]!
                                newExerciseEntry.weight = exerciseDetail["weight"]!
                                newDate.exerciseList.append(newExerciseEntry)
                            }
                            
                        }
                    }
                    self.userExerciseJournal.append(newDate)
                }
            }
            self.processGoals()
            self.goalTableView.reloadData()
        })
    }
    
    func processNutrition() {
        var currentUser = (Auth.auth().currentUser?.email)!
        currentUser = currentUser.replacingOccurrences(of: ".", with: ",")
        
        ref = Database.database().reference()
        ref?.child("foodEntry").child(currentUser).observe(.value, with: { (snapshot) in
            self.userFoodJournal = []
            if let dictionary = snapshot.value as? [String: AnyObject] {
                for dateEntry in dictionary {
                    let newDate = DateEntryFood()
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
                                newFoodEntry.qty = foodDetail["qty"]!
                                newDate.foodList.append(newFoodEntry)
                            }
                            
                        }
                    }
                    self.userFoodJournal.append(newDate)
                }
            }
            self.processGoals()
            self.goalTableView.reloadData()
        })
    }
    
    func processGoals() {
        // Process goalObjecs data
        var newGoalObjects = [Goal]()
        for goalObject in self.goalObjects {
            if goalObject.type == "Exercise" {
                if (goalObject.end_date > self.lastExerciseDay) {
                    self.lastExerciseDay = goalObject.end_date
                }
                var progress = 0.0
                for data in self.userExerciseJournal {
                    if (goalObject.start_date <= data.date && data.date <= goalObject.end_date) {
                        let currentExerciseList = data.exerciseList
                        for entry in currentExerciseList {
                            if entry.distance != "" {
                                progress += Double(entry.distance)!
                            }
                        }
                    }
                }
                goalObject.progress = String(progress)
                if (progress >= Double(goalObject.distance)!) {
                    goalObject.status = "Complete"
                }
            } else {
                if (goalObject.end_date > self.lastNutritionDay) {
                    self.lastNutritionDay = goalObject.end_date
                }
                var progress = 0.0
                for data in self.userFoodJournal {
                    if (goalObject.start_date <= data.date && data.date <= goalObject.end_date) {
                        let currentFoodList = data.foodList
                        for entry in currentFoodList {
                            if entry.calories != "<null>" {
                                let addedCal = Double(entry.qty)! * Double(entry.calories)!
                                progress += addedCal
                            }
                        }
                    }
                }
                goalObject.progress = String(progress)
                if (progress >= Double(goalObject.calories)!) {
                    goalObject.status = "Complete"
                }
            }
            newGoalObjects.append(goalObject)
        }
        self.goalObjects = newGoalObjects
    }
    
    // GET RID OF THIS WHEN THERE IS A LINK WITH THE DATABASE
    func createMockData() {
        let newGoal = Goal()
        newGoal.type = "Exercise"
        newGoal.distance = "20"
        newGoal.start_date = "June 6, 2017"
        newGoal.end_date = "June 8, 2017"
        self.goalObjects.append(newGoal)
        
        let newGoal2 = Goal()
        newGoal2.type = "Nutrition"
        newGoal2.calories = "200"
        newGoal2.start_date = "June 7, 2017"
        newGoal2.end_date = "June 9, 2017"
        self.goalObjects.append(newGoal2)
    }
    
    
    @IBAction func composeNewGoal(_ sender: Any) {
        let alertController = UIAlertController(title: "Goal Type", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Nutrition", style:.default, handler: { (_) in
            self.performSegue(withIdentifier: "nutritionSegue", sender: self)
        }))
        
        alertController.addAction(UIAlertAction(title: "Exercise", style:.default, handler: { (_) in
            self.performSegue(withIdentifier: "exerciseSegue", sender: self)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style:.cancel))
        
        self.present(alertController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "exerciseSegue" {
            let vc = segue.destination as! ExerciseGoalViewController
            vc.earliestDate = self.lastExerciseDay
        } else {
            let vc = segue.destination as! NutritionGoalViewController
            vc.earliestDate = self.lastNutritionDay
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        self.lastExerciseDay = formatter.string(from: currentDate)
        self.lastNutritionDay = formatter.string(from: currentDate)
        
        var currentUser = (Auth.auth().currentUser?.email)!
        currentUser = currentUser.replacingOccurrences(of: ".", with: ",")
        
        ref = Database.database().reference()
        ref?.child("goalEntry").child(currentUser).observe(.value, with: { (snapshot) in
            self.userGoalJournal = []
            if let dictionary = snapshot.value as? [String: AnyObject] {
                for entry in dictionary {
                    let newGoal = Goal()
                    if let goalDetail = entry.value as? [String: String] {
                        newGoal.calories = goalDetail["calories"]!
                        newGoal.distance = goalDetail["distance"]!
                        newGoal.end_date = goalDetail["enddate"]!
                        newGoal.start_date = goalDetail["startdate"]!
                        newGoal.progress = goalDetail["progress"]!
                        newGoal.status = goalDetail["status"]!
                        newGoal.type = goalDetail["type"]!
                    }
                    self.userGoalJournal.append(newGoal)
                }
                print(self.userGoalJournal)
            }
            self.goalTableView.reloadData()
        })
        
        // CREATE MOCK DATA
        self.createMockData()
        // REPLACE MOCK DATA WITH DATA FROM THE DATABASE
        self.processExercises()
        self.processNutrition()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
