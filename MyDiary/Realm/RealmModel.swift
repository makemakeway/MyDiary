//
//  RealmModel.swift
//  MyDiary
//
//  Created by 박연배 on 2021/11/02.
//

import Foundation
import RealmSwift

class Diary: Object {
    @Persisted var title: String
    @Persisted var content: String?
    @Persisted var writtenDate: Date = Date()
    @Persisted var publishedDate: Date = Date()
    @Persisted var favorite: Bool
    
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(title: String, content: String?, writtenDate: Date, publishedDate: Date) {
        self.init()
        
        
        self.title = title
        self.content = content
        self.writtenDate = writtenDate
        self.publishedDate = publishedDate
        self.favorite = false
        
    }
}
