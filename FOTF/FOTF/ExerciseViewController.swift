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
    var exerciseDetail = Exercise()
    
    @IBOutlet weak var totalDistance: UILabel!
    @IBOutlet weak var totalMinutes: UILabel!
    @IBOutlet weak var maxWeight: UILabel!
    @IBOutlet weak var maxReps: UILabel!

    func finishNewAerobic(exercise newExercise: Exercise) { }
    
    func finishNewStrength(exercise newExercise: Exercise) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseTableView.delegate = self
        exerciseTableView.dataSource = self
        
        exerciseTableView.allowsMultipleSelectionDuringEditing = true
        
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
            self.exerciseTableView.reloadData()
            self.updateStatistics()
        })

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func updateStatistics() {
        var distance = 0.0
        var duration = 0.0
        var weight = 0.0
        var reps = 0.0
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        let TodayDate = formatter.string(from: currentDate)
        for date in self.userExerciseJournal {
            if date.date == TodayDate {
                let currentDateExerciseList = date.exerciseList
                for entry in currentDateExerciseList {
                    if entry.distance != ""{
                        distance += Double(entry.distance)!
                    }
                    if entry.duration != "" {
                        duration += Double(entry.duration)!
                    }
                    if entry.weight != "" {
                        if Double(entry.weight)! > weight {
                            weight = Double(entry.weight)!
                        }
                    }
                    if entry.reps != "" {
                        if Double(entry.reps)! > reps {
                            reps = Double(entry.reps)!
                        }
                    }
                }
                
            }
        }
        self.totalDistance.text = String(distance) + " miles"
        self.totalMinutes.text = String(duration) + " minutes"
        self.maxReps.text = String(reps) + " reps"
        self.maxWeight.text = String(weight) + " lbs"
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var currentUser = (Auth.auth().currentUser?.email)!
            currentUser = currentUser.replacingOccurrences(of: ".", with: ",")
            let exerciseItem = userExerciseJournal[indexPath.section].exerciseList[indexPath.row].description
            let deletedate = userExerciseJournal[indexPath.section].date
            
            let query = ref?.child("exerciseEntry").child(currentUser).child(deletedate).queryOrdered(byChild: "description").queryEqual(toValue: exerciseItem)
            
            
            
            query?.observeSingleEvent(of: .value, with: { (snapshot) in
                if let deleteSnap = snapshot.value as? [String: AnyObject] {
                    var deleteID = ""
                    for (key, value) in deleteSnap {
                        deleteID = key
                        print(deleteID)
                    }
                    self.ref?.child("exerciseEntry").child(currentUser).child(deletedate).child(deleteID).removeValue()
                }
            })
        }
        self.updateStatistics()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.exerciseDetail = self.userExerciseJournal[indexPath.section].exerciseList[indexPath.row]
        performSegue(withIdentifier: "exerciseSegue", sender: self)
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
        } else if segue.identifier == "exerciseSegue" {
            let detailExerciseVC = segue.destination as! ExerciseDetailViewController
            detailExerciseVC.exerciseObj = self.exerciseDetail
        } else {
            let vc = segue.destination as! StrengthExerciseViewController
            vc.delegate = self
        }
    }

}

