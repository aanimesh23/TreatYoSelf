//
//  foodRecomendationViewController.swift
//  TreatYoSelf
//
//  Created by Animesh Agrawal on 3/8/20.
//  Copyright © 2020 Animesh Agrawal. All rights reserved.
//

import UIKit
import HealthKit
import MapKit
import Parse

class foodRecomendationViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource
{
    
    //
    @IBOutlet weak var foodRecTable: UITableView!
    var log = [PFObject]()
    var locationManager = CLLocationManager()
    var location_data = [[String:Any]]()
    var curr_loc = CLLocationCoordinate2D()
    var distances = [PFObject:Double]()
    var sorted_items = [(key: PFObject, value: Double)]()
    var calorie_Consumed: Double = 0.0
    var food_items = [PFObject]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        foodRecTable.delegate = self
        foodRecTable.dataSource = self
        foodRecTable.estimatedRowHeight = 150
//        foodRecTable.rowHeight = 150
        //request location from user
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()

        // Do any additional setup after loading the view.
        }
        let query = PFQuery(className: "menuItem")
        query.limit = 20
        
        query.findObjectsInBackground { (log, error) in
        if log != nil {
            self.log = log!
            for item in self.log {
                self.get_address_distance(address: item["itemAddress"] as! String, objectId: item)
            }
            self.foodRecTable.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.foodRecTable.reloadData()
        let vc = FoodJournalViewController()
        self.calorie_Consumed = vc.calculateCalorieConsumed()
        self.calorie_filter()
    }
    func get_address_distance(address: String, objectId: PFObject){
        var distance = Double()
        let API_KEY = "AIzaSyCdTEVi4FSOoWaf8Qegq9ebmqE5YORK3nU"
         var urlComponents = URLComponents()
         urlComponents.scheme = "https"
         urlComponents.host = "maps.googleapis.com"
         urlComponents.path = "/maps/api/geocode/json"
         urlComponents.queryItems = [
             URLQueryItem(name: "key", value: API_KEY),
             URLQueryItem(name: "address", value: address)
        ]
         let url = urlComponents.url!
             let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
             let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
             let task = session.dataTask(with: request) { (data, response, error) in
                // This will run when the network request returns
            if let error = error {
               print(error.localizedDescription)
            } else if let data = data {
               let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
             
             self.location_data = dataDictionary["results"] as! [[String:Any]]
               // TODO: Get the array of movies
             let x = self.location_data[0]["geometry"] as! [String:Any]
             let store_loc = x["location"] as! [String:Any]
            distance = self.distance_between(x1: self.curr_loc.latitude, y1: self.curr_loc.longitude, x2: store_loc["lat"] as! Double, y2: store_loc["lng"] as! Double)

                self.distances[objectId] = distance
                let temp = self.distances.sorted{$0.1 > $1.1}
                self.sorted_items = temp
            }
            
         }
        
         task.resume()
    }
    
    func distance_between(x1: Double, y1: Double, x2: Double, y2: Double) -> Double {
        return sqrt(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)))
    }
    
    func calorie_filter() {
        let user = PFUser.current()
        let goal = Double(user?["daily_goal"] as! Int)
        for item in self.sorted_items {
            let food_item = item.key
            var calorie = Double(food_item["itemCalorie"] as! Int)
            if (calorie + self.calorie_Consumed) < goal {
                self.food_items.append(food_item)
            }
            else {
                print(item)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.food_items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.foodRecTable.dequeueReusableCell(withIdentifier: "foodRecommendationTableViewCell", for: indexPath) as! foodRecommendationTableViewCell
        
        let food_item = self.food_items[indexPath.row]
        var calorie = "\(food_item["itemCalorie"] as! Int)"
        cell.adressLabel.text = food_item["itemAddress"] as! String
        cell.calorieCount.text = calorie as! String
        cell.foodNameLabel.text = food_item["itemName"] as! String
        cell.foodDetails.text = food_item["itemDescription"] as! String
        return cell
        
    }
    //responisble for obtaining and printing user current coordinates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.curr_loc = locValue
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
