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
    
    @IBOutlet weak var foodRecTable: UITableView!
    var log = [PFObject]()
    var locationManager = CLLocationManager()
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "menuItem")
        query.limit = 20
        
        query.findObjectsInBackground { (log, error) in
        if log != nil {
            self.log = log!
            self.foodRecTable.reloadData()
            }
            print(self.log)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.log.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.foodRecTable.dequeueReusableCell(withIdentifier: "foodRecommendationTableViewCell", for: indexPath) as! foodRecommendationTableViewCell
        var calorie = "\(log[indexPath.row]["itemCalorie"] as! Int)"
        cell.adressLabel.text = log[indexPath.row]["itemAddress"] as! String
        cell.calorieCount.text = calorie as! String
        cell.foodNameLabel.text = log[indexPath.row]["itemName"] as! String
        cell.foodDetails.text = log[indexPath.row]["itemDescription"] as! String
        return cell
        
    }
    //responisble for obtaining and printing user current coordinates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
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
