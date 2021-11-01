//
//  AddViewController.swift
//  MyDiary
//
//  Created by 박연배 on 2021/11/01.
//

import UIKit

class AddViewController: UIViewController {
    
    
    
    //MARK: Property
    
    @IBOutlet weak var pictureImage: UIImageView!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var dateButton: UIButton!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    
    //MARK: Method
   
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    

    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func dateButtonClicked(_ sender: UIButton) {
    }
    
    
    
    //MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
