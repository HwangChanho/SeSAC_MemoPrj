//
//  Date+Extension.swift
//  SeSAC_MemoPrj
//
//  Created by ChanhoHwang on 2021/11/10.
//

import Foundation

extension DateFormatter {
    var dateTimeFormat: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier:"ko_KR")
        date.dateFormat = "a hh:mm"
        return date
    }
    
    var weekFormat: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier:"ko_KR")
        date.dateFormat = "E요일"
        return date
    }
    
    var fullDateFormat: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier:"ko_KR")
        date.dateFormat = "yyyy. MM. dd. a hh:mm"
        return date
    }
    
    //  let format = DateFormatter(), let value = format.weekFormat
}
