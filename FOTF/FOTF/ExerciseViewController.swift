//
//  ExerciseViewController.swift
//  FOTF
//
//  Created by Sabrina Niklaus on 5/18/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AerobicDelegate, StrengthDelegate {
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
        if newExercise.distance != nil {
            weeklyStatistics["distance"]! += newExercise.distance!
        }
        weeklyStatistics["minutes"]! += newExercise.duration!
        
        totalMinutes.text! = "\(weeklyStatistics["minutes"]!) minutes"
        totalDistance.text! = "\(weeklyStatistics["distance"]!) miles"
        
        self.exerciseLog.append(newExercise)
        exerciseTableView.reloadData()
    }
    
    func finishNewStrength(exercise newExercise: Exercise) {
        if Float(newExercise.reps!) > weeklyStatistics["reps"]! {
            weeklyStatistics["reps"] = newExercise.reps
        }
        if newExercise.weight != nil && Float(newExercise.weight!) > weeklyStatistics["weight"]! {
            weeklyStatistics["weight"] = newExercise.weight
        }
        
        maxWeight.text! = "\(weeklyStatistics["weight"]!) lbs"
        maxReps.text! = "\(weeklyStatistics["reps"]!) reps"
        
        self.exerciseLog.append(newExercise)
        exerciseTableView.reloadData()
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseLog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let exercise = exerciseLog[indexPath.row]
        let cell = exerciseTableView.dequeueReusableCell(withIdentifier: "exerciseCell")
        cell?.textLabel?.text = exercise.description
        if exercise.type == "Aerobic" {
            cell?.detailTextLabel?.text = "\(exercise.duration!) minutes"
            cell?.imageView?.image = #imageLiteral(resourceName: "Running_25")
        } else {
            cell?.detailTextLabel?.text = "\(exercise.reps!) reps"
            cell?.imageView?.image = #imageLiteral(resourceName: "strength")
        }
        return cell!
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseTableView.delegate = self
        exerciseTableView.delegate = self 
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

