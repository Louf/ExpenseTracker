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
