//
//  Category.swift
//  ExpenseTracker
//
//  Created by Louis Farmer on 12/10/23.
//

import Foundation
import SwiftData

@Model
class Category {
    var categoryName: String
    var tagColor: String
    
    @Relationship(deleteRule: .cascade, inverse: \Expense.category)
    var expenses: [Expense]?
    
    init(categoryName: String, tagColor: String) {
        self.categoryName = categoryName
        self.tagColor = tagColor
    }
}
