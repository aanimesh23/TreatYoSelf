//
//  FoodJournalViewController.swift
//  TreatYoSelf
//
//  Created by Animesh Agrawal on 2/12/20.
//  Copyright © 2020 Animesh Agrawal. All rights reserved.
//

import UIKit
import HealthKit
import Parse
class FoodJournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var consumedCalorieLabel: UILabel!
    @IBOutlet weak var journalTable: UITableView!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var calorieBurnt: UILabel!
    var log = [PFObject]()
    
    let healthStore = HKHealthStore()
    var totalSteps = 0
    private let StepCountQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hey")
        
        //Making the image a circle
        userImage.layer.masksToBounds = false
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
        journalTable.delegate = self
        journalTable.dataSource = self
        //calorieBurnt.text = try healthStore.activeEnergyBurned()
        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestAuth()
        var steps = [HKQuantitySample]()
        let stepsCount = HKQuantityType.quantityType(
            forIdentifier: .stepCount)!
         
        let stepsSampleQuery = HKSampleQuery(sampleType: stepsCount,
            predicate: nil,
            limit: 100,
            sortDescriptors: nil)
            { [unowned self] (query, results, error) in
                if let results = results as? [HKQuantitySample] {
                    steps = results
                    for step in results {
                        let numberOfSteps = Int(step.quantity.doubleValue(for: HKUnit.count()))
                        self.totalSteps += numberOfSteps
                    }
                }
        }
         
        // Don't forget to execute the Query!
        healthStore.execute(stepsSampleQuery)
        let query = PFQuery(className: "FoodJournalObject")
        query.whereKey("user", equalTo: PFUser.current())
        query.limit = 20
        
        query.findObjectsInBackground { (log, error) in
        if log != nil {
            self.log = log!
            self.journalTable.reloadData()
            let c:String = String(format:"%.0f", self.calculateCalorieConsumed())
            let d:String = String(format:"-%.0f", self.calculateCaloriesBurned())
            self.consumedCalorieLabel.text =  c
            self.calorieBurnt.text = d
            }
        }
    }
    func calculateCaloriesBurned() -> Double{
        let val = Double(self.totalSteps) * 0.063
        return Double(val)
    }
    func calculateCalorieConsumed() -> Double{
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        var total = 0.0
        
        for object in log{
            if object["month"] as! Int == month && object["day"] as! Int == day{
                total += (object["calorie"] as! NSString).doubleValue
            }
        }
        return Double(total)
    }
    
    @IBAction func onLogout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "logedIn")
        PFUser.logOutInBackground { (error) in
            print(error)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func requestAuth()
    {
        print("Clicked! and Here")
        let readType = Set([StepCountQuantityType])
        let shareType = Set([StepCountQuantityType])
        
        if !HKHealthStore.isHealthDataAvailable() {
            print("Came here")
            return
        }
        healthStore.requestAuthorization(toShare: shareType, read: readType) { (success, error) in
            if !success {
                print("error!!! \(error)")
            } else {
                print("Success")
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return log.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = journalTable.dequeueReusableCell(withIdentifier: "PersonalJournalTableViewCell", for: indexPath) as! PersonalJournalTableViewCell
        cell.timeLabel.text = log[indexPath.row]["time"] as! String
        cell.calorieLabel.text = log[indexPath.row]["calorie"] as! String
        cell.foodItemLabel.text = log[indexPath.row]["name"] as! String
        print(log[indexPath.row])
        return cell
    }
    
    
    /*
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
