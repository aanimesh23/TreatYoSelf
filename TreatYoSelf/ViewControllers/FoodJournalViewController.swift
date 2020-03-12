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
    
    @IBOutlet weak var calorieBurnt: UILabel!
    var log = [PFObject]()
    
    let healthStore = HKHealthStore()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hey")
        
        journalTable.delegate = self
        journalTable.dataSource = self
        //calorieBurnt.text = try healthStore.activeEnergyBurned()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "FoodJournalObject")
        query.whereKey("user", equalTo: PFUser.current())
        query.limit = 20
        
        query.findObjectsInBackground { (log, error) in
        if log != nil {
            self.log = log!
            self.journalTable.reloadData()
            let c:String = String(format:"%.0f", self.calculateCalorieConsumed())
            self.consumedCalorieLabel.text =  c
            }
        }
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
