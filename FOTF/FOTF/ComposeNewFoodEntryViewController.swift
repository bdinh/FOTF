//
//  ComposeNewFoodEntryViewController.swift
//  FOTF
//
//  Created by Bao Dinh on 5/30/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ComposeNewFoodEntryViewController: UIViewController {

    var currentUser = "bdinh@uw.edu"
    
    @IBOutlet weak var newEntry: UITextField!
    
    var ref: DatabaseReference?
    
    @IBAction func finishCompose(_ sender: Any) {
//        if newEntry.text != "" {
//            ref?.child("users").child(currentUser).child("foodEntry").childByAutoId().setValue(newEntry.text)
//        }
        ref?.child("foodEntry").childByAutoId().setValue(newEntry.text)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelCompose(_ sender: Any) {
        
        presentingViewController?.dismiss(animated: true, completion: nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
