//
//  FoodJournalViewController.swift
//  TreatYoSelf
//
//  Created by Animesh Agrawal on 2/12/20.
//  Copyright © 2020 Animesh Agrawal. All rights reserved.
//

import UIKit
import HealthKit
import MapKit
class FoodJournalViewController: UIViewController, CLLocationManagerDelegate{
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var calorieBurnt: UILabel!
    let healthStore = HKHealthStore()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hey")
        //calorieBurnt.text = try healthStore.activeEnergyBurned()
        // Do any additional setup after loading the view.
        
        //location info
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    //responisble for obtaining and printing user current coordinates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    @IBAction func onLogout(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onAuth(_ sender: Any) {
        requestAuth()
    }
    func requestAuth()
    {
        let readType = Set([
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!])
        
        if !HKHealthStore.isHealthDataAvailable() {
            print("Came here")
            return
        
        }
        healthStore.requestAuthorization(toShare: readType, read: readType) { (success, error) in
        if !success {
            print("Error: \(String(describing: error))")
        }
        }
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
