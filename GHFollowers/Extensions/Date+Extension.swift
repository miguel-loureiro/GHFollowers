//
//  Date+Extension.swift
//  GHFollowers
//
//  Created by António Loureiro on 02/04/2024.
//

import Foundation

extension Date {

    func convertToMonthYearFormat() -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"

        return dateFormatter.string(from: self)
    }
}
