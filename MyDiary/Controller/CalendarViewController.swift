//
//  CalendarViewController.swift
//  MyDiary
//
//  Created by 박연배 on 2021/11/01.
//

import UIKit
import FSCalendar
import RealmSwift

class CalendarViewController: UIViewController {

    
    //MARK: Property
    
    let localRealm = try! Realm()
    
    var tasks: Results<Diary>!
    
    @IBOutlet weak var calendarView: FSCalendar!
    
    @IBOutlet weak var countLabel: UILabel!
    //MARK: Method
    
    func calendarViewConfig() {
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizableStrings.tab_calendar.localized
        
        calendarViewConfig()
        
        tasks = localRealm.objects(Diary.self)
        
        
        let count = localRealm.objects(Diary.self).count
        countLabel.text = "총 \(count)개의 일기를 작성함"
        
        let recent = localRealm.objects(Diary.self).sorted(byKeyPath: "writtenDate", ascending: false).first
        
        
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return tasks.filter("writtenDate = %@", date).count
    }
    
}
