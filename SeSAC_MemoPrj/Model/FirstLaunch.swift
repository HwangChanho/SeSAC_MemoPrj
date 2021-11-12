//
//  FirstLaunch.swift
//  SeSAC_MemoPrj
//
//  Created by ChanhoHwang on 2021/11/08.
//

import Foundation

final class FirstLaunch {
    let wasLaunchedBefore: Bool
    var isFirstLaunch: Bool {
        return !wasLaunchedBefore
    }
    
    init(getWasLaunchedBefore: () -> Bool, setWasLaunchedBefore: (Bool) -> ()) {
        let wasLaunchedBefore = getWasLaunchedBefore()
        self.wasLaunchedBefore = wasLaunchedBefore
        if !wasLaunchedBefore {
            setWasLaunchedBefore(true)
        }
    }
    
    convenience init(userDefaults: UserDefaults, key: String) {
        self.init(getWasLaunchedBefore: { userDefaults.bool(forKey: key) },
                  setWasLaunchedBefore: { userDefaults.set($0, forKey: key) })
    }
    
    static func alwaysFirst() -> FirstLaunch {
        // let alwaysFirstLaunch = FirstLaunch.alwaysFirst() if alwaysFirstLaunch.isFirstLaunch { // will always execute }
        return FirstLaunch(getWasLaunchedBefore: { return false }, setWasLaunchedBefore: { _ in })
    }
    
    
    //let firstLaunch = FirstLaunch(userDefaults: .standard, key: "com.any-suggestion.FirstLaunch.WasLaunchedBefore")
    // if firstLaunch.isFirstLaunch { // do things }
}
