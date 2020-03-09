//
//  SignUpViewController.swift
//  TreatYoSelf
//
//  Created by Animesh Agrawal on 3/6/20.
//  Copyright © 2020 Animesh Agrawal. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var goal_weight: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var height_inch: UITextField!
    @IBOutlet weak var current_weight: UITextField!
    @IBOutlet weak var height_ft: UITextField!
    @IBOutlet weak var goalCalorieField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        performSegue(withIdentifier: "signupSegue", sender: nil)
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
