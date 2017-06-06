//
//  ExerciseGoalViewController.swift
//  FOTF
//
//  Created by Abhishek Chauhan on 6/6/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ExerciseGoalViewController: UIViewController {
    
    var ref: DatabaseReference?
    @IBOutlet weak var exerciseField: UITextField!
    @IBOutlet weak var exerciseLabel: UILabel!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    var earliestDate: String = ""
    var exerciseType: String = ""
    
    @IBAction func cancelCompose(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func finishCompose(_ sender: Any) {
        if validateInput() == true {
            var currentUser = (Auth.auth().currentUser?.email)!
            currentUser = currentUser.replacingOccurrences(of: ".", with: ",")
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            let start_date = formatter.string(from: startDatePicker.date)
            let end_date = formatter.string(from: endDatePicker.date)
            // Save this data to the database as a GOAL OBJECT
            let goalItem = Goal()
            goalItem.type = self.exerciseType//"Exercise"
            goalItem.goalValue = self.exerciseField.text!
            goalItem.start_date = start_date
            goalItem.end_date = end_date
            
            self.ref?.child("goalEntry").child(currentUser).child(self.exerciseType).setValue(goalItem.toAnyObject())
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func validateInput() -> Bool {
        var isValid = false
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        let earlyDate = formatter.date(from: self.earliestDate)!
        let start_date = startDatePicker.date
        let end_date = endDatePicker.date
        if (start_date < end_date) {
            print("reached in")
            if ((exerciseField.text?.characters.count)! > 0) {// && (start_date >= Date())) {//earlyDate)) {
                isValid = true
            }
        }
        if (isValid == false) {
            let alertController = UIAlertController(title: nil, message: "Check your input", preferredStyle: UIAlertControllerStyle.actionSheet)
            let OKAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true)
        }
        return isValid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.exerciseType == "Distance" {
            self.exerciseLabel.text = "Distance (miles)"
        } else if self.exerciseType == "Time" {
            self.exerciseLabel.text = "Time (minutes)"
        } else if self.exerciseType == "Weight" {
            self.exerciseLabel.text = "Weight (lbs)"
        } else if self.exerciseType == "Reps" {
            self.exerciseLabel.text = "Reps"
        }
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
