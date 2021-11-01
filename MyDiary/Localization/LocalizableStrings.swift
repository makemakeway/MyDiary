//
//  LocalizableStrings.swift
//  MyDiary
//
//  Created by 박연배 on 2021/11/01.
//

import Foundation

enum LocalizableStrings: String {
    case welcome_text
    case backup_text
    case tab_home
    case tab_setting
    case tab_calendar
    case tab_search
    
    
    
    var localized: String {
        return self.rawValue.localized() // Localizable.strings 사용
    }
    
    var localizedWithTable: String {
        return self.rawValue.localized(tableName: "Setting") // Setting.strings에 있는 테이블 사용
    }
}
