//
//  FoodDetailViewController.swift
//  FOTF
//
//  Created by Abhishek Chauhan on 6/1/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

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
    
    @IBOutlet weak var foodImage: UIImageView!
    
    
    var foodObject: Food? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let baseurl = "https://www.googleapis.com/customsearch/v1?"
        let apiKey = "key=AIzaSyChekpdvPC4houyNdtzyfGGkuTdZwf0DJE"
        let consoleID = "&cx=016670613649737080400:ky0c7sahduk"
        let foodTerm = String((foodObject?.title)!)!.replacingOccurrences(of: " ", with: "+")
        let searchTerm = "&q=" + foodTerm + "+food"
        let extraparam = "&searchType=image&filetype=jpg&num=1"
        var link = ""
        Alamofire.request(baseurl+apiKey+consoleID+searchTerm+extraparam).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
                if let JSON = response.result.value {
                    if let dictionary = JSON as? NSDictionary {
                        if let image = dictionary["items"] as? NSArray {
                            if let imageDict = image[0] as? NSDictionary {
                                link = imageDict["link"]! as! String
                                self.foodImage.sd_setImage(with: URL(string: link))
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)

                
            }
        }
        
//        let imageURL = URL(string: link)
//        self.foodImage.sd_setImage(with: URL(string: "https://images5.alphacoders.com/393/393394.jpg"))
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
            let quantity = self.foodObject!.qty
            var servingString = "serving"
            if Double(quantity)! > 1.0 {
                servingString = "servings"
            }
            
            self.titleField.text = self.foodObject!.title
            self.brandName.text = self.foodObject!.brand
            self.servingSize.text = "\(self.foodObject!.servingSize) \(self.foodObject!.servingUnit) - \(quantity) \(servingString)"
            
            if self.foodObject!.calories != "<null>" {
                self.calorieField.text = "\(Double(quantity)! * Double(self.foodObject!.calories)!) kcal"
            }
            if self.foodObject!.sugar != "<null>" {
                self.sugarField.text = "\(Double(quantity)! * Double(self.foodObject!.sugar)!) grams"
            }
            if self.foodObject!.cholesterol != "<null>" {
                self.cholesterolField.text = "\(Double(quantity)! * Double(self.foodObject!.cholesterol)!) milligrams"
            }
            if self.foodObject!.fat != "<null>" {
                self.fatField.text = "\(Double(quantity)! * Double(self.foodObject!.fat)!) grams"
            }
            if self.foodObject!.sodium != "<null>" {
                self.sodiumField.text = "\(Double(quantity)! * Double(self.foodObject!.sodium)!) milligrams"
            }
            if self.foodObject!.protein != "<null>" {
                 self.proteinField.text = "\(Double(quantity)! * Double(self.foodObject!.protein)!) grams"
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
