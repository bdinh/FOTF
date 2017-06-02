//
//  StrengthExerciseViewController.swift
//  FOTF
//
//  Created by Sabrina Niklaus on 6/1/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit

class StrengthExerciseViewController: UIViewController {
    var exerciseItem = Exercise()

    @IBOutlet weak var exerciseTitle: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var reps: UITextField!
    
    @IBAction func cancelCompose(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishCompose(_ sender: Any) {
        exerciseItem.description = exerciseTitle.text!
        exerciseItem.reps = reps.text!
        exerciseItem.weight = reps.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
