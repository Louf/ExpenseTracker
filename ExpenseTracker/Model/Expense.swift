//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Louis Farmer on 12/10/23.
//

import Foundation
import SwiftData

@Model
class Expense {
    //Expense properties
    var title: String
    var subTitle: String
    var amount: Double
    var date: Date
    var category: Category?
    
    init(title: String, subTitle: String, amount: Double, date: Date, category: Category? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.amount = amount
        self.date = date
        self.category = category
    }
    
    //Currency String
    //Transienet avoids storing properties on the disk
    @Transient
    var currencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(for: amount) ?? ""
    }
}
