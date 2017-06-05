//
//  ExerciseViewController.swift
//  FOTF
//
//  Created by Sabrina Niklaus on 5/18/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ExerciseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AerobicDelegate, StrengthDelegate {
    
    var userExerciseJournal: [DateEntryExercise] = []
    var ref: DatabaseReference?

    var exerciseLog = [Exercise]()
    var weeklyStatistics: [String: Float] = [
        "distance": 0,
        "minutes": 0,
        "weight": 0,
        "reps": 0
    ]
    
    @IBOutlet weak var totalDistance: UILabel!
    @IBOutlet weak var totalMinutes: UILabel!
    @IBOutlet weak var maxWeight: UILabel!
    @IBOutlet weak var maxReps: UILabel!

    func finishNewAerobic(exercise newExercise: Exercise) {
//        if newExercise.distance != nil {
//            weeklyStatistics["distance"]! += newExercise.distance!
//        }
//        weeklyStatistics["minutes"]! += newExercise.duration!
//        
//        totalMinutes.text! = "\(weeklyStatistics["minutes"]!) minutes"
//        totalDistance.text! = "\(weeklyStatistics["distance"]!) miles"
//        
//        self.exerciseLog.append(newExercise)
//        exerciseTableView.reloadData()
    }
    
    func finishNewStrength(exercise newExercise: Exercise) {
//        if Float(newExercise.reps!) > weeklyStatistics["reps"]! {
//            weeklyStatistics["reps"] = newExercise.reps
//        }
//        if newExercise.weight != nil && Float(newExercise.weight!) > weeklyStatistics["weight"]! {
//            weeklyStatistics["weight"] = newExercise.weight
//        }
//        
//        maxWeight.text! = "\(weeklyStatistics["weight"]!) lbs"
//        maxReps.text! = "\(weeklyStatistics["reps"]!) reps"
//        
//        self.exerciseLog.append(newExercise)
//        exerciseTableView.reloadData()
    }
    
    @IBOutlet weak var exerciseTableView: UITableView!
    
    @IBAction func composeNewExercise(_ sender: Any) {
        let alertController = UIAlertController(title: "Exercise Type", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Aerobic", style:.default, handler: { (_) in
            self.performSegue(withIdentifier: "NewAerobicExercise", sender: self)
        }))
        
        alertController.addAction(UIAlertAction(title: "Strength", style:.default, handler: { (_) in
            self.performSegue(withIdentifier: "NewStrengthExercise", sender: self)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style:.cancel))

        self.present(alertController, animated: true)

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // will have it based on dates
        return userExerciseJournal.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userExerciseJournal[section].exerciseList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return userExerciseJournal[section].date
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let exercise = userExerciseJournal[indexPath.section].exerciseList[indexPath.row]
        let cell = exerciseTableView.dequeueReusableCell(withIdentifier: "exerciseCell") as! ExerciseTableViewCell
        
        cell.exerciseName.text = exercise.description
        if exercise.type == "Aerobic" {
            cell.exerciseAmount.text = exercise.duration + " minutes"
            cell.exerciseImage.image = #imageLiteral(resourceName: "Running_25")
        } else {
            cell.exerciseAmount.text = exercise.reps + " reps"
            cell.exerciseImage.image = #imageLiteral(resourceName: "strength")
        }
        return cell
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseTableView.delegate = self
        exerciseTableView.dataSource = self
        
        exerciseTableView.allowsMultipleSelectionDuringEditing = true

        var currentUser = Auth.auth().currentUser?.email as! String
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
            self.exerciseTableView.reloadData()
//            self.updateStatistics()
        })

        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "NewAerobicExercise" {
            let vc = segue.destination as! AerobicExerciseViewController
            vc.delegate = self
        } else {
            let vc = segue.destination as! StrengthExerciseViewController
            vc.delegate = self
        }
    }

}

