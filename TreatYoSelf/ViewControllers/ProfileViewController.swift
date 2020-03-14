//
//  ProfileViewController.swift
//  TreatYoSelf
//
//  Created by Animesh Agrawal on 3/13/20.
//  Copyright © 2020 Animesh Agrawal. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var dailyGoalLabel: UILabel!
    var image = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded")
        let query = PFQuery(className: "User_Image")
        query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.current())
        query.limit = 1
        
        query.findObjectsInBackground { (img, error) in
            print("here")
            if img != nil {
                self.image = img!
                self.image.reversed()
                let img1 = self.image[0]
                let imagefile = img1["image"] as! PFFileObject
                let urlstring = imagefile.url!
                let url = URL(string: urlstring)!
                print(url)
                self.profileImage.af_setImage(withURL: url)
            }
            else {
                print(error)
            }
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Appearing")
        
    }
    @IBAction func onImageTap(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        profileImage.image = scaledImage
        
        dismiss(animated: true, completion: nil)
        
        let userImage = PFObject(className: "User_Image")
        let imageData = profileImage.image!.pngData()!
        let file = PFFileObject(name: "image.png", data: imageData)
        
        userImage["image"] = file
        userImage["author"] = PFUser.current()
        
        userImage.saveInBackground { (success, error) in
            if success {
                print("Uploaded")
            } else {
                print(error)
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
