//
//  FoodViewController.swift
//  FOTF
//
//  Created by Sabrina Niklaus on 5/18/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var jsonResponse: NSDictionary!
    let apiID: String = "d09f36f1"
    let apiKey: String = "fc4200e582f9de3d0b19ef0716196032"
    
    // not connected to anything
    @IBOutlet weak var searchField: UITextField!
    
    // not connected to anything 
    @IBAction func searchClicked(_ sender: UIButton) {
        let query = searchField.text!
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.nutritionix.com/v1_1/search/")! as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        let params = [
            "appId" : apiID,
            "appKey" : apiKey,
            "fields" : ["item_name", "brand_name", "keywords", "usda_fields"],
            "limit" : "50",
            "query" : query,
            "filters" : ["exists" :["usda_fields": true]]] as [String : Any]
        
        var _: NSError?
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        } catch {
            print(error)
        }
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, err) -> Void in
            var conversionError: NSError?
            
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary
                print(jsonDictionary!)
                if conversionError != nil {
                    print(conversionError!.localizedDescription)
                    let errorString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("Error in Parsing \(String(describing: errorString))")
                }
                else {
                    if jsonDictionary != nil {
                        self.jsonResponse = jsonDictionary!
                        print(self.jsonResponse)
                    }
                    else {
                        let errorString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Error Could not Prase JSON \(String(describing: errorString))")
                    }
                }
                
            } catch {
                print(conversionError)
            }
            
        })
        task.resume()
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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

