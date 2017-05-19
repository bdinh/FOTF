//
//  LoginViewController.swift
//  FOTF
//
//  Created by Bao Dinh on 5/18/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit


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
class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var loginQuote: UILabel!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        loginQuote.text = "Insert Cheesy Quote \n about being health here :)"
        
    
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
