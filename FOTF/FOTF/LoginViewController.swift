//
//  LoginViewController.swift
//  FOTF
//
//  Created by Bao Dinh on 5/18/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


//extension UIColor {
//    convenience init(red: Int, green: Int, blue: Int) {
//        let newRed = CGFloat(red)/255
//        let newGreen = CGFloat(green)/255
//        let newBlue = CGFloat(blue)/255
//        
//        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
//    }
//}

@IBDesignable
class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var sex: UITextField!
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var loginQuote: UILabel!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    // source: http://www.appcoda.com/firebase-login-signup/
    @IBAction func createAccountAction(_ sender: AnyObject) {
        if self.age.isHidden { // unhide fields, otherwise try to create account
            age.isHidden = false
            name.isHidden = false
            sex.isHidden = false
        } else {
            // check if age, name, and sex are filled in
            if (checkFilled()) {
                // check if email already exists
                Auth.auth().fetchProviders(forEmail: userName.text!, completion:{(providers, error) in
                    if error != nil {
                        print(error!)
                    } else {
                        //If there are no errors and there are providers, the email exists
                        if providers != nil {
                            let alertController = UIAlertController(title: "Error", message: "Email already in use", preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                            print("Bad email used for signup")
                        } else { //The email does not exist, proceed to create account
                            print("Email is okay")
                            self.signUp(sender) // let signup handle the creation
                        }
                    }
                })
            } else {
                print("age name and sex fields not filled in")
                let alertController = UIAlertController(title: "Error", message: "Please Enter Name, age, and sex", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // checks whether fields filled
    func checkFilled() -> Bool {
        return (sex.text != "" && name.text != "" && age.text != "")
    }
    
    let apiID: String = "d09f36f1"
    let apiKey: String = "fc4200e582f9de3d0b19ef0716196032"
    var ref: DatabaseReference?

    // creates account
    func signUp(_ sender: AnyObject) {
        if userName.text == "" || userName.text == "Username" { // all fields must be filled
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let name = self.name.text!
            let age = Int(self.age.text!)!
            let sex = self.sex.text!
            var email = self.userName.text!
            let password = self.password.text!
            
            // try to create user
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if error == nil { // account creation successful
                    print("You have successfully signed up")
                    
                    //try to sign in, add profile values for name age sex
                    Auth.auth().signIn(withEmail: email, password: password)
                    self.ref = Database.database().reference()

                    // clean key, firebase doesnt accept special characters like '.$[]#/' for key (email)
                    email = email.replacingOccurrences(of: ".", with: ",")
                    email = email.replacingOccurrences(of: "$", with: ",")
                    email = email.replacingOccurrences(of: "[", with: ",")
                    email = email.replacingOccurrences(of: "]", with: ",")
                    email = email.replacingOccurrences(of: "#", with: ",")
                    email = email.replacingOccurrences(of: "/", with: ",")
                    
                    let user = User(name: name, email: email, age: age, sex: sex, weight: 0, height: 0) // create json with name age sex and email filled in
                    let users = self.ref?.child("Users") // gets user table
                    let newUser = users?.ref.child(email) // create child for email
                    newUser?.setValue(user.toAnyObject()) // populate information for child
                    self.performSegue(withIdentifier: "loginSegue", sender: sender) // go to profile
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // source: http://www.appcoda.com/firebase-login-signup/
    @IBAction func loginAction(_ sender: AnyObject) {
        if self.userName.text == "" || self.password.text == "" {
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().signIn(withEmail: self.userName.text!, password: self.password.text!) { (user, error) in
        
                if error == nil {
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    self.performSegue(withIdentifier: "loginSegue", sender: sender)
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // makes age field keyboard valid characters only numeric
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        age.delegate = self
        age.keyboardType = .numberPad
        
        // hide the new account creation fields until signup pressed
        age.isHidden = true
        name.isHidden = true
        sex.isHidden = true
        
        let gradient: CAGradientLayer = CAGradientLayer()
        let colorTop = UIColor(red: 101.0/255.0, green: 110.0/255.0, blue: 121.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        
        gradient.colors = [colorTop, colorBottom]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = loginButton.bounds
        gradient.cornerRadius = 15
        loginButton.layer.addSublayer(gradient)
        loginTitle.text = "INFO 449 Final Project \n Fitness On The Fly"
        loginQuote.text = "It's not about having time \nIt's about making time"
        
    
//        self.userName.layer.cornerRadius = 15
//        self.userName.layer.borderWidth = 1
//        self.userName.layer.borderColor = UIColor(red: 101, green: 110, blue: 121, alpha: 0.75).cgColor

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
