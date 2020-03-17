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
import AlamofireImage

class FoodJournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var consumedCalorieLabel: UILabel!
    @IBOutlet weak var journalTable: UITableView!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var calorieBurnt: UILabel!
    var log = [PFObject]()
    
    let healthStore = HKHealthStore()
    var totalSteps = 0
    private let StepCountQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    var image = [PFObject]()
    var calories_burned: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Making the image a circle
        userImage.layer.masksToBounds = false
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
        
        let query = PFQuery(className: "User_Image")
        query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.current())
        query.limit = 1

        query.findObjectsInBackground { (img, error) in
            if img != nil {
                self.image = img!
                let img1 = self.image[0]
                let imagefile = img1["image"] as! PFFileObject
                let urlstring = imagefile.url!
                let url = URL(string: urlstring)!
                self.userImage.af_setImage(withURL: url)
            }
            else {
                print(error)
            }
        }
        
        journalTable.delegate = self
        journalTable.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestAuth()
        var steps = [HKQuantitySample]()
        let stepsCount = HKQuantityType.quantityType(
            forIdentifier: .stepCount)!
        let today = Date()
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let start = cal.startOfDay(for: today)
        let pridicate = HKQuery.predicateForSamples(withStart: start, end: today, options: HKQueryOptions.strictStartDate)
        let stepsSampleQuery = HKSampleQuery(sampleType: stepsCount,
            predicate: pridicate,
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
            self.log = self.log.reversed()
        }
        
    }
    func get_calorie_burned() -> String {
        return self.calories_burned
    }
    func calculateCaloriesBurned() -> Double{
        let step_cal = Double(self.totalSteps) * 0.063
        var avg_day = 0.0
        let user = PFUser.current()
        if user!["gender"] as! String == "M" {
            avg_day = 66.0 + (6.2 * Double(user!["weight"] as! String)!)
            avg_day = avg_day  + (12.7 * Double(user!["height_ft"] as! String)! * 12.0)
            avg_day = avg_day + (12.7 * Double(user!["height_in"] as! String)!)
            avg_day = avg_day  - (6.76 * Double(user!["age"] as! String)!)
        }
        if user!["gender"] as! String == "F" {
            avg_day = 655.1 + (4.35 * Double(user!["weight"] as! String)!)
            avg_day = avg_day  + (4.7 * Double(user!["height_ft"] as! String)! * 12.0)
            avg_day = avg_day + (4.7 * Double(user!["height_in"] as! String)!)
            avg_day = avg_day  - (4.7 * Double(user!["age"] as! String)!)
        }
        let val = step_cal + avg_day
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
        let readType = Set([StepCountQuantityType])
        let shareType = Set([StepCountQuantityType])
        
        if !HKHealthStore.isHealthDataAvailable() {
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
        return cell
    }
    
    
    // MARK: - Navigation


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let barViewControllers = segue.destination as! UITabBarController
//        let destinationViewController = barViewControllers.viewControllers?[1] as! foodRecomendationViewController
//        destinationViewController.calorie_Burened = self.calorieBurnt.text!
//    }


}
