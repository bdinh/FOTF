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

class EditAccountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var age: UITextField!
    
    @IBOutlet weak var sex: UITextField!
    
    @IBOutlet weak var weight: UITextField!
    
    @IBOutlet weak var height: UITextField!
    
    
    @IBAction func savePressed(_ sender: Any) {
        
        
        if name.text == "" || age.text == "" || sex.text == "" || weight.text == "" || height.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please fill in all values", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let newName = name.text
            let newAge = Int(age.text!)!
            let newSex = sex.text
            let newWeight = Int(weight.text!)!
            let newHeight = Int(height.text!)!
            if var email = Auth.auth().currentUser?.email! {
                self.ref = Database.database().reference()
                let users = self.ref?.child("Users") // gets user table
                email = email.replacingOccurrences(of: ".", with: ",")
                email = email.replacingOccurrences(of: "$", with: ",")
                email = email.replacingOccurrences(of: "[", with: ",")
                email = email.replacingOccurrences(of: "]", with: ",")
                email = email.replacingOccurrences(of: "#", with: ",")
                email = email.replacingOccurrences(of: "/", with: ",")
                let updated = User(name: newName!, email: email, age: newAge, sex: newSex!, weight: newWeight, height: newHeight)
                let newUser = users?.ref.child(email) // create child for email
                newUser?.setValue(updated.toAnyObject()) // populate information for child
                self.performSegue(withIdentifier: "editAccountSegue", sender: sender) // go to profile
                
            }
        }
        
        
    }
    
    
    var ref: DatabaseReference?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.age.delegate = self
        self.weight.delegate = self
        self.height.delegate = self
        self.age.keyboardType = .numberPad
        self.weight.keyboardType = .numberPad
        self.height.keyboardType = .numberPad
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // makes age field keyboard valid characters only numeric
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
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
