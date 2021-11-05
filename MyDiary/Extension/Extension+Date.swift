//
//  Extension+Date.swift
//  MyDiary
//
//  Created by 박연배 on 2021/11/05.
//

import Foundation

extension DateFormatter {
    static var customFormat: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "yyyy년 MM월 dd일"
        df.locale = Locale(identifier: "ko-KR")
        df.timeZone = TimeZone(identifier: "KST")
        
        return df
    }
}
