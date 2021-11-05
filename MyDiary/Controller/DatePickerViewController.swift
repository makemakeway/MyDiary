//
//  DatePickerViewController.swift
//  MyDiary
//
//  Created by 박연배 on 2021/11/05.
//

import UIKit

class DatePickerViewController: UIViewController {

    
    //MARK: Property
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //MARK: Method
    
    func datePickerConfig() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
    }
    
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerConfig()

    }
}
