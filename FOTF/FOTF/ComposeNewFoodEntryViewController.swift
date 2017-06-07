//
//  ComposeNewFoodEntryViewController.swift
//  FOTF
//
//  Created by Bao Dinh on 5/30/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Alamofire
import FirebaseAuth

class ComposeNewFoodEntryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var jsonResponse: NSDictionary = [:]
    var searchResults: [Food] = []
    let apiID: String = "d09f36f1"
    let apiKey: String = "fc4200e582f9de3d0b19ef0716196032"
    var currentDate: String = ""
    var selectedItem = Food()
    var ref: DatabaseReference?

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var newEntry: UITextField!
    
    @IBOutlet weak var currentQuantity: UILabel!
    
    
    
    
    
    @IBAction func stepperQuantity(_ sender: UIStepper) {
        currentQuantity.text = String(Int(sender.value))
    }
    
    
    @IBAction func searchFood(_ sender: Any) {
        self.attemptRequest(query: newEntry.text!)
    }
    
    @IBAction func finishCompose(_ sender: Any) {
        if self.selectedItem.brand != "" {
            var currentUser = (Auth.auth().currentUser?.email)!
            currentUser = currentUser.replacingOccurrences(of: ".", with: ",")
            selectedItem.qty = self.currentQuantity.text!
            self.ref?.child("foodEntry").child(currentUser).child(currentDate).childByAutoId().setValue(selectedItem.toAnyObject())

            presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Error", message: "Please select an item", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func cancelCompose(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func attemptRequest(query: String) {
        self.searchResults = []
        let parameters = [
            "appId":apiID,
            "appKey":apiKey,
            "query":query,
            "fields":["item_name","brand_name","nf_calories","nf_serving_size_qty","nf_serving_size_unit", "nf_total_fat", "nf_sodium", "nf_sugars", "nf_protein", "nf_cholesterol"],
            "sort":[
                "field":"_score",
                "order":"desc"
            ],
            "filters":[
                "item_type":2
            ]] as [String : Any]
        
        Alamofire.request("https://api.nutritionix.com/v1_1/search/", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                self.processResponse(response: response)
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func processResponse(response: DataResponse<Any>) {
        let dictionary = response.result.value as! NSDictionary
        
        let hits = dictionary["hits"] as? [[String:Any]]
        if hits == nil {
            // present view controller
            let alertController = UIAlertController(title: "Error", message: "No results found", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            for hit in hits! {
                let foodItem = Food()
                let info = hit["fields"] as! [String:Any]
                foodItem.title = info["item_name"] as! String
                foodItem.brand = info["brand_name"] as! String
                foodItem.calories = "\(info["nf_calories"]!)"
                foodItem.fat = "\(info["nf_total_fat"]!)"
                foodItem.sodium = "\(info["nf_sodium"]!)"
                foodItem.cholesterol = "\(info["nf_cholesterol"]!)"
                foodItem.sugar = "\(info["nf_sugars"]!)"
                foodItem.protein = "\(info["nf_protein"]!)"
                foodItem.servingSize = "\(info["nf_serving_size_qty"]!)"
                foodItem.servingUnit = "\(info["nf_serving_size_unit"]!)"
                searchResults.append(foodItem)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.searchResults[indexPath.row]
        self.selectedItem = item
        let alertController = UIAlertController(title: item.title, message: "\(item.servingSize) \(item.servingUnit) \ncalories: \(item.calories) kcal \nfat: \(item.fat) grams \nsodium: \(item.sodium) miligrams \ncholestrol: \(item.cholesterol) miligrams \nsugar: \(item.sugar) grams \nprotein: \(item.protein) grams", preferredStyle: UIAlertControllerStyle.actionSheet)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "searchResultCell")
        
        if self.searchResults.count > 0 {
            let food = searchResults[indexPath.row]
            cell.textLabel?.text = "\(food.title)"
            cell.detailTextLabel?.text = "\(food.brand)"
        }
        return cell
        
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tableView.delegate = self
        tableView.dataSource = self
        ref = Database.database().reference()
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        self.currentDate = formatter.string(from: currentDate)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    

}
