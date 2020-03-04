//
//  FoodJournalViewController.swift
//  TreatYoSelf
//
//  Created by Animesh Agrawal on 2/12/20.
//  Copyright © 2020 Animesh Agrawal. All rights reserved.
//

import UIKit
import HealthKit
class FoodJournalViewController: UIViewController {
    
    @IBOutlet weak var calorieBurnt: UILabel!
    let healthStore = HKHealthStore()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hey")
        //calorieBurnt.text = try healthStore.activeEnergyBurned()
        // Do any additional setup after loading the view.
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
