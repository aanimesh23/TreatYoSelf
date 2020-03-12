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
    var menuItems = [Any]()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //request location from user
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()

        // Do any additional setup after loading the view.
        }
        
        //Deals with gathering info from Parse data base
        let query = PFQuery(className: "menuItem")
        query.findObjectsInBackground { (objects, error) in
            if error == nil
            {
                //no error in data fetch
                
                if let returnedObjects = objects
                {
                    //objects array isnt nil
                    for object in returnedObjects
                    {
                        //currently prints names of all menuItems
                        self.menuItems.append(object )
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.foodRecTable.dequeueReusableCell(withIdentifier: "foodRecommendationTableViewCell", for: indexPath) as! foodRecommendationTableViewCell
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
