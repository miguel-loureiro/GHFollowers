//
//  String+Extension.swift
//  GHFollowers
//
//  Created by António Loureiro on 02/04/2024.
//

import Foundation

extension String {

    func convertToDate() -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "pt_PT")
        dateFormatter.timeZone = .current

        return dateFormatter.date(from: self)
    }

    func convertToDisplayFormat() -> String {

        guard let date = self.convertToDate() else { return "N/A" }

        return date.convertToMonthYearFormat()
    }
}

