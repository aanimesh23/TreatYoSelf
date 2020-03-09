//
//  SignUpViewController.swift
//  TreatYoSelf
//
//  Created by Animesh Agrawal on 3/6/20.
//  Copyright © 2020 Animesh Agrawal. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var goal_weight: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var height_inch: UITextField!
    @IBOutlet weak var current_weight: UITextField!
    @IBOutlet weak var height_ft: UITextField!
    @IBOutlet weak var goalCalorieFeild: UISegmentedControl!
    @IBOutlet weak var passwordtextFeild: UITextField!
    @IBOutlet weak var emailTextFeild: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
        // Do any additional setup after loading the view.
    }
    
    @objc func DismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        let goal = [1000, 1200, 1500, 2000]
        user.password = passwordtextFeild.text
        user.email = emailTextFeild.text
        user.username = emailTextFeild.text
        user["daily_goal"] = goal[goalCalorieFeild.selectedSegmentIndex]
        user["height_ft"] = height_ft.text
        user["height_in"] = height_inch.text
        
        user["weight"] = current_weight.text
        user["goal_weight"] = goal_weight.text
        user["gender"] = gender.text
        user["age"] = age.text
        
        user.signUpInBackground { (success, error) in
            if success {
                UserDefaults.standard.set(true, forKey: "logedIn")
                self.performSegue(withIdentifier: "signupSegue", sender: nil)
            }
            else {
                print("Error occored \(error)")
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
