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

class ComposeNewFoodEntryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var jsonResponse: NSDictionary = [:]
    var searchResults: [Food] = []
    let apiID: String = "d09f36f1"
    let apiKey: String = "fc4200e582f9de3d0b19ef0716196032"
    var currentUser = "bdinh@uw.edu"
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var newEntry: UITextField!
    
    var ref: DatabaseReference?
    
    @IBAction func searchFood(_ sender: UIButton) {
        self.attemptRequest(query: newEntry.text!)
    }
    
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
    
    func attemptRequest(query: String) {
        self.searchResults = []
        let parameters = [
            "appId":apiID,
            "appKey":apiKey,
            "query":query,
            "fields":["item_name","brand_name","nf_calories","nf_serving_size_qty","nf_serving_size_unit", "nf_total_fat", "nf_sodium", "nf_sugars", "nf_protein"],
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
        
        let hits = dictionary["hits"] as! [[String:Any]]
        for hit in hits {
            let foodItem = Food()
            let info = hit["fields"] as! [String:Any]
            foodItem.title = info["item_name"] as! String
            foodItem.brand = info["brand_name"] as! String
            foodItem.calories = "\(info["nf_calories"]!)"
            foodItem.fat = "\(info["nf_total_fat"]!)"
            foodItem.sodium = "\(info["nf_sodium"]!)"
            foodItem.sugar = "\(info["nf_sugars"]!)"
            foodItem.protein = "\(info["nf_protein"]!)"
            foodItem.servingSize = "\(info["nf_serving_size_qty"]!)"
            foodItem.servingUnit = "\(info["nf_serving_size_unit"]!)"
            searchResults.append(foodItem)
        }
        print(self.searchResults.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.searchResults[indexPath.row]
        
        let alertController = UIAlertController(title: item.title, message: "\(item.servingSize) \(item.servingUnit) \ncalories: \(item.calories) kcal \nfat: \(item.fat) grams \nsodium: \(item.sodium) miligrams \nsugar: \(item.sugar) grams \nprotein: \(item.protein) grams", preferredStyle: UIAlertControllerStyle.actionSheet)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
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
