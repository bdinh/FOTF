//
//  ComposeNewExerciseViewController.swift
//  FOTF
//
//  Created by Sabrina Niklaus on 6/1/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol AerobicDelegate {
    func finishNewAerobic(exercise: Exercise)
}

class AerobicExerciseViewController: UIViewController {
    var delegate: AerobicDelegate?
    let type:String = "Aerobic"
    var currentDate: String = ""
    var ref: DatabaseReference?

    
    @IBOutlet weak var exerciseTitle: UITextField!
    @IBOutlet weak var distance: UITextField!
    @IBOutlet weak var duration: UITextField!
    
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
            exerciseItem.distance = distance.text!
            exerciseItem.duration = duration.text!
            
            self.ref?.child("exerciseEntry").child(currentUser).child(currentDate).childByAutoId().setValue(exerciseItem.toAnyObject())
            
            delegate?.finishNewAerobic(exercise: exerciseItem)
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func validateInput() -> Bool {
        var valid = true
        let errorMessage: String = "Please enter a number in the"
        var errorFields: String = ""
        if !isStringFloat(string: distance.text!) && (distance.text!).characters.count > 0 {
            valid = false
            errorFields += "distance field "
        }
        if !isStringFloat(string: duration.text!) {
            if valid == false {
                errorFields += "and the "
            }
            valid = false
            errorFields += "duration field"
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
