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
        query.limit = 20
        
        query.findObjectsInBackground { (log, error) in
        if log != nil {
            self.log = log!
            self.journalTable.reloadData()
            }
        }
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = journalTable.dequeueReusableCell(withIdentifier: "PersonalJournalTableViewCell", for: indexPath) as! PersonalJournalTableViewCell
        
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
