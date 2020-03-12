//
//  AddFoodViewController.swift
//  TreatYoSelf
//
//  Created by Animesh Agrawal on 3/8/20.
//  Copyright © 2020 Animesh Agrawal. All rights reserved.
//

import UIKit
import Parse

class AddFoodViewController: UIViewController {

    @IBOutlet weak var CalorieField: UITextField!
    @IBOutlet weak var FoodNameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        print("trying to submit")
        let foodJournalObject = PFObject(className:"FoodJournalObject")
        foodJournalObject["calorie"] = CalorieField.text as! String
        foodJournalObject["name"] = FoodNameField.text as! String
        foodJournalObject["user"] = PFUser.current()
        foodJournalObject.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
                self.dismiss(animated: true, completion: nil)
            } else {
                // There was a problem, check error.description
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
