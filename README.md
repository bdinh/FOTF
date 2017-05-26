# FOTF

## Last Change

5/19 1:15 AM Added Login Screen and Put together the majority of storyboard. Still need to conform viewcontroller classes to uitableview. (Bao)

5/23 7:00 PM Added uitableview datasource and delegate for each tab view with tableview inside.

5/24 3:40 PM Added nutrionix api request code in FoodViewController.swift. Still needs to be connected to a text box and search button. 

5/25 10:33 AM Added Alamofire to make API request. Created Food.swift class which currently stores a food description as a String and a dictionary of usda fields. As of now, when the nutrition view loads it automatically calls the api to look for "apple" and creates an array of Food objects based on the response. 
