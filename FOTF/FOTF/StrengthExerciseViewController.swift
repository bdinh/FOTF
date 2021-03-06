//
//  StrengthExerciseViewController.swift
//  FOTF
//
//  Created by Sabrina Niklaus on 6/1/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

protocol StrengthDelegate {
    func finishNewStrength(exercise: Exercise)
}

class StrengthExerciseViewController: UIViewController {
    var delegate: StrengthDelegate?
    let type: String = "Strength"
    var currentDate: String = ""
    var ref: DatabaseReference?

    @IBOutlet weak var exerciseTitle: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var reps: UITextField!
    
    @IBAction func cancelCompose(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishCompose(_ sender: Any) {
        var currentUser = (Auth.auth().currentUser?.email)!
        currentUser = currentUser.replacingOccurrences(of: ".", with: ",")

        if validateInput() {
            let exerciseItem = Exercise()
            exerciseItem.type = self.type
            exerciseItem.description = exerciseTitle.text!
            exerciseItem.reps = reps.text!
            exerciseItem.weight = weight.text!
            
            self.ref?.child("exerciseEntry").child(currentUser).child(currentDate).childByAutoId().setValue(exerciseItem.toAnyObject())
            
            delegate?.finishNewStrength(exercise: exerciseItem)
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func validateInput() -> Bool {
        var valid = true
        let errorMessage: String = "Please enter a number in the"
        var errorFields: String = ""
        if !isStringFloat(string: weight.text!) && (weight.text!).characters.count > 0 {
            valid = false
            errorFields += "weight field "
        }
        if !isStringFloat(string: reps.text!) {
            if valid == false {
                errorFields += "and the "
            }
            valid = false
            errorFields += "reps field"
        }
        if !valid {
            let alertController = UIAlertController(title: nil, message: "\(errorMessage) \n\(errorFields)", preferredStyle: UIAlertControllerStyle.actionSheet)
            let OKAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true)
        }
        return valid
    }
    
    func isStringFloat(string: String) -> Bool {
        return Float(string) != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        self.currentDate = formatter.string(from: currentDate)


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
