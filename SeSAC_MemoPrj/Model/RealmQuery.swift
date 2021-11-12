//
//  RealmQuery.swift
//  SeSAC_MemoPrj
//
//  Created by ChanhoHwang on 2021/11/09.
//

import Foundation
import UIKit
import RealmSwift

extension UIViewController {
    func searchTextFromUserMemo(text: String) -> Results<MemoList> {
        let localRealm = try! Realm()
        
        //String -> ' ', AND, OR
        let search = localRealm.objects(MemoList.self).filter("title CONTAINS[c] '\(text)' OR content CONTAINS[c] '\(text)'")
        
        return search
    }
    
    func searchFixedDataFromUserMemo() -> Results<MemoList> {
        let localRealm = try! Realm()
        
        //String -> ' ', AND, OR
        let search = localRealm.objects(MemoList.self).filter("fixed == true")
        
        return search
    }
    
    func searchNoneFixedDataFromUserMemo() -> Results<MemoList> {
        let localRealm = try! Realm()
        
        //String -> ' ', AND, OR
        let search = localRealm.objects(MemoList.self).filter("fixed == false")
        
        return search
    }
    
    func getAllMemoCountFromUserMemo() -> Int {
        let localRealm = try! Realm()
        
        return localRealm.objects(MemoList.self).count
    }
    
    func getFixedMemoCountFromUserMemo() -> Int {
        let localRealm = try! Realm()
        
        return localRealm.objects(MemoList.self).filter("fixed == true").count
    }
    
    func getNoneFixedMemoCountFromUserMemo() -> Int {
        let localRealm = try! Realm()
        
        return localRealm.objects(MemoList.self).filter("fixed == false").count
    }
    
    func getFixedPosition(index: Int) -> Bool {
        let localRealm = try! Realm()
        
        if let memo = localRealm.objects(MemoList.self).filter("id == \(index)").first {
            if memo.fixed {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func getFixed(index: Int) {
        let localRealm = try! Realm()
        
        if let memo = localRealm.objects(MemoList.self).filter("id == \(index)").first {
            try! localRealm.write {
                memo.fixed.toggle()
            }
        }
    }
    
    func addDataToRealm(id: Int, title: String, date: Date, fixed: Bool, content: String?) {
        let localRealm = try! Realm()
        
        let data = MemoList(id: id, title: title, date: date, fixed: fixed, content: content)
        
        try! localRealm.write {
            localRealm.add(data)
        }
    }
    
    func writeContentToRealm(index: Int, title: String, content: String?) {
        let localRealm = try! Realm()
        if let memo = localRealm.objects(MemoList.self).filter("id == \(index)").first {
            try! localRealm.write {
                memo.title = title
                memo.fixedDate = Date()
                memo.content = content
            }
        }
    }
    
    func getKey() -> Results<MemoList> {
        let localRealm = try! Realm()
        
        //String -> ' ', AND, OR
        let search = localRealm.objects(MemoList.self)
        
        return search
    }
    
    func removeDataFromRealm(index: Int) {
        let localRealm = try! Realm()
        
        let data = localRealm.objects(MemoList.self).filter("id == \(index)")
        
        print("deleted")
        print(data)
        
        for i in 0 ..< data.count {
            try! localRealm.write {
                localRealm.delete(data[i])
            }
        }
    }
    
    func removeAllData() {
        let localRealm = try! Realm()
        
        try! localRealm.write {
            localRealm.deleteAll()
        }
    }
}
