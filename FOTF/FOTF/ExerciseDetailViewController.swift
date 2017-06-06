//
//  ExerciseDetailViewController.swift
//  FOTF
//
//  Created by Abhishek Chauhan on 6/5/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit

class ExerciseDetailViewController: UIViewController {

    @IBOutlet weak var imageBlock: UIImageView!
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var typeField: UILabel!
    @IBOutlet weak var distanceField: UILabel!
    @IBOutlet weak var durationField: UILabel!
    @IBOutlet weak var distanceLabelText: UILabel!
    @IBOutlet weak var durationLabelText: UILabel!
    var exerciseObj: Exercise? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.populateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateData() {
        if self.exerciseObj != nil {
            self.titleField.text = self.exerciseObj!.description
            self.typeField.text = self.exerciseObj!.type
            let imageName = self.exerciseObj!.type + "-Cover.jpg"
            self.imageBlock.image = UIImage(named: imageName)
            if self.exerciseObj!.type == "Aerobic" {
                if (self.exerciseObj!.distance != "") {
                    self.distanceField.text = self.exerciseObj!.distance + " miles"
                }
                if (self.exerciseObj!.duration != "") {
                    self.durationField.text = self.exerciseObj!.duration + " minutes"
                }
            } else {
                self.distanceLabelText.text = "Weight"
                self.durationLabelText.text = "Reps"
                if (self.exerciseObj!.weight != "") {
                    self.distanceField.text = self.exerciseObj!.weight + " lbs"
                }
                if (self.exerciseObj!.reps != "") {
                    self.durationField.text = self.exerciseObj!.reps
                }
            }
        }
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
