//
//  EditAccountViewController.swift
//  FOTF
//
//  Created by Brandon Chen on 6/3/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class EditAccountViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var age: UITextField!
    
    @IBOutlet weak var sex: UITextField!
    
    @IBOutlet weak var weight: UITextField!
    
    @IBOutlet weak var height: UITextField!
    
    
    @IBAction func savePressed(_ sender: Any) {
        
    }
    
    
    var ref: DatabaseReference?
    
    
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
