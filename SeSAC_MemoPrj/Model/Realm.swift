//
//  Realm.swift
//  SeSAC_MemoPrj
//
//  Created by ChanhoHwang on 2021/11/08.
//

import Foundation

import RealmSwift

class MemoList: Object {
    @Persisted var title: String // column
    @Persisted var date = Date()
    @Persisted var fixedDate: Date?
    @Persisted var content: String?
    @Persisted var fixed: Bool
    
    // PK
    // @Persisted var objectId: ObjectId
    @Persisted(primaryKey: true) var id: Int
    
    convenience init(id: Int, title: String, date: Date, fixed: Bool, content: String?) {
        self.init()
        self.id = id
        self.title = title
        self.date = date
        self.fixed = fixed
        self.content = content
    }
}

