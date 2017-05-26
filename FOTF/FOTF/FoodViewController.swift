//
//  FoodViewController.swift
//  FOTF
//
//  Created by Sabrina Niklaus on 5/18/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit
import Alamofire

class FoodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var jsonResponse: NSDictionary = [:]
    var searchResults: [Food] = []//[String: [String:Any]] = [:]
    let apiID: String = "d09f36f1"
    let apiKey: String = "fc4200e582f9de3d0b19ef0716196032"
    
    func attemptRequest(query: String) {
        let parameters = [
            "appId" : apiID,
            "appKey" : apiKey,
            "fields" : ["item_name", "brand_name", "keywords", "usda_fields"],
            "limit" : "50",
            "query" : query,
            "filters" : ["exists" :["usda_fields": true]]] as [String : Any]
        
        Alamofire.request("https://api.nutritionix.com/v1_1/search/", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                self.processResponse(response: response)
//                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func processResponse(response: DataResponse<Any>) {
        print("got here")
        let dictionary = response.result.value as! NSDictionary
        
        let hits = dictionary["hits"] as! [[String:Any]]
        for hit in hits {
            let info = hit["fields"] as! [String:Any]
            let name = info["item_name"] as! String
            let usda = info["usda_fields"] as! [String:Any]
            let foodItem = Food()
            foodItem.title = name
            foodItem.usda_fields = usda
            searchResults.append(foodItem)
   
//            let calories = usda["ENERC_KCAL"] as! [String:String]
//            foodItem.calories = "\(calories["value"]) \(calories["uom"])"
//            let fat = usda["FAMS"] as! [String:String]
//            foodItem.fat = "\(fat["value"]) \(fat["uom"])"
//            let cholestrol = usda["CHOLE"] as! [String:String]
//            foodItem.cholestrol = "\(cholestrol["value"]) \(cholestrol["uom"])"
//            let sodium = usda["NA"] as! [String:String]
//            foodItem.sodium = "\(sodium["value"]) \(sodium["uom"])"
//            let potassium = usda["K"] as! [String:String]
//            foodItem.potassium = "\(potassium["value"]) \(potassium["uom"])"
//            let fiber = usda["FIBTG"] as! [String:String]
//            foodItem.fiber = "\(fiber["value"]) \(fiber["uom"])"
//            let sugar = usda["SUGAR"]as! [String:String]
//            foodItem.sugar = "\(sugar["value"]) \(sugar["uom"])"
//            let protein = usda["PROCNT"] as! [String:String]
//            foodItem.protein = "\(protein["value"]) \(protein["uom"])"
//            
//            self.searchResults.append(foodItem)
//        }
//        print("search results: \(searchResults)") 
        }
        print(self.searchResults)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // will have it based on dates
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.attemptRequest(query: "apple")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

