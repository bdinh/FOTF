//
//  FoodDetailViewController.swift
//  FOTF
//
//  Created by Abhishek Chauhan on 6/1/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit

class FoodDetailViewController: UIViewController {
    
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var servingSize: UILabel!
    @IBOutlet weak var calorieField: UILabel!
    @IBOutlet weak var fatField: UILabel!
    @IBOutlet weak var sodiumField: UILabel!
    @IBOutlet weak var cholesterolField: UILabel!
    @IBOutlet weak var sugarField: UILabel!
    @IBOutlet weak var proteinField: UILabel!
    
    var foodObject: Food? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.populateWithData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneClick(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func populateWithData() {
        if self.foodObject != nil {
            self.titleField.text = self.foodObject!.title
            self.brandName.text = self.foodObject!.brand
            self.servingSize.text = self.foodObject!.servingSize + " " + self.foodObject!.servingUnit
            self.calorieField.text = self.foodObject!.calories + " kcal"
            self.fatField.text = self.foodObject!.fat + " grams"
            self.sodiumField.text = self.foodObject!.sodium + " milligrams"
            self.cholesterolField.text = self.foodObject!.cholesterol + " milligrams"
            self.sugarField.text = self.foodObject!.sugar + " grams"
            self.proteinField.text = self.foodObject!.protein + " grams"
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
