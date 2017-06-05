//
//  AccountViewController.swift
//  FOTF
//
//  Created by Sabrina Niklaus on 5/18/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AccountViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    var ref: DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePicture.layer.borderWidth = 2
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.white.cgColor
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
        loadCurrentUserInfo()
    }
    
    func loadCurrentUserInfo() {
        if var email = Auth.auth().currentUser?.email! {
//            print(email)
            self.ref = Database.database().reference()
            email = email.replacingOccurrences(of: ".", with: ",")
            email = email.replacingOccurrences(of: "$", with: ",")
            email = email.replacingOccurrences(of: "[", with: ",")
            email = email.replacingOccurrences(of: "]", with: ",")
            email = email.replacingOccurrences(of: "#", with: ",")
            email = email.replacingOccurrences(of: "/", with: ",")
            var name: String = ""
            var age: Int = 0
            var sex: String =  ""
            var weight: Int = 0 // for pounds
            var height: String = "" // convert from inches to string
    
            // get values
            self.ref?.observe(.value, with: { snapshot in
                let value = snapshot.value as! NSDictionary
                if let users = value["Users"] as? NSDictionary {
                    let profile = users[email] as! [String: Any]
                    name = profile["name"]! as! String
                    age = profile["age"]! as! Int
                    sex = profile["sex"] as! String
                    if let pounds: Int = profile["weight"] as? Int {
                        weight = pounds
                    }
                    if let totalInches: Int = profile["height"] as? Int {
                        let feet = totalInches / 12
                        let inches = totalInches % 12
                        height = "\(feet)' \(inches)\""
                    }
//                    print("name: \(name) age: \(age) sex: \(sex) weight: \(weight) height: \(height)")
                    self.name.text = "Name: \(name)"
                    self.age.text = "Age: \(age)"
                    self.Sex.text = "Sex: \(sex)"
                    self.weight.text = "Weight: \(weight)"
                    self.height.text = "Height: \(height)"
                }
                
            })
        } else { // do nothing, shouldnt reach here
            print("no current user")
        }
    }
    
    // source: http://www.appcoda.com/firebase-login-signup/
    @IBAction func signOutAction(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginView")
                present(vc, animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

    
    
    
    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var age: UILabel!
    
    
    @IBOutlet weak var Sex: UILabel!
    
    
    @IBOutlet weak var height: UILabel!
    
    @IBOutlet weak var weight: UILabel!
    
    
    
    
    
    
    
    
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
