//
//  SearchForm.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import Foundation

struct SearchForm: Equatable {
    var name = ""
    var surname = ""
    var year = ""
    var prefecture = ""
    var shipName = ""

    var validationMessage: String? {
        func trim(_ value: String) -> String {
            value.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        guard !trim(name).isEmpty, !trim(surname).isEmpty else {
            return "Name and surname are required."
        }

        let text = trim(year)
        guard !text.isEmpty else { return nil }
        guard text.count == 4,
              text.allSatisfy({ $0.isASCII && $0.isNumber }),
              Int(text) != nil else {
            return "Enter a four-digit year, or leave it blank."
        }
        return nil
    }

    var criteria: SearchCriteria {
        func trim(_ value: String) -> String {
            value.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return SearchCriteria(name: trim(name), surname: trim(surname),
                              year: Int(trim(year)), prefecture: trim(prefecture),
                              shipName: trim(shipName))
    }
}
