//
//  FormatHelper.swift
//  GooDic
//
//  Created by ttvu on 5/28/20.
//  Copyright © 2020 paxcreation. All rights reserved.
//

import Foundation

struct FormatHelper {
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.dateStyle = .medium
        return formatter
    }
    
    static var dateFormatterOnServer: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-ddTHH:mm:ssZ"
        return formatter
    }
    
    static var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        return formatter
    }
}

extension Date {
    var toString: String {
        return FormatHelper.dateFormatter.string(from: self)
    }
}
