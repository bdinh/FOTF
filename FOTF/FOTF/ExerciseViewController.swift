//
//  ExerciseViewController.swift
//  FOTF
//
//  Created by Sabrina Niklaus on 5/18/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var exerciseLog = [Exercise]()

    
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
        let cell = exerciseTableView.dequeueReusableCell(withIdentifier: "exerciseCell")
        cell?.textLabel?.text = exerciseLog[indexPath.row].description
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
            vc.exerciseLog = self.exerciseLog
        } else {
            let vc = segue.destination as! StrengthExerciseViewController
            vc.exerciseLog = self.exerciseLog
        }
    }

}

