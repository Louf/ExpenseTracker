//
//  SummaryView.swift
//  ExpenseTracker
//
//  Created by Louis Farmer on 12/14/23.
//

import SwiftUI
import SwiftData
import Charts

struct SummaryView: View {
    @Query(sort: [
        SortDescriptor(\Expense.date, order: .reverse)
    ], animation: .snappy) private var allExpenses: [Expense]
    @Query(animation: .snappy) private var allCategories: [Category]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        var totalExpense: Double {
            var total: Double = 0
            for expense in allExpenses {
                total += expense.amount
            }
            
            return total
        }
        
        var expensesLast7Days: [Expense] {
            let keyDate = Date(timeIntervalSinceNow: -7 * 60 * 60 * 24)
            return allExpenses.filter{ $0.date > keyDate }
        }
        
        var totalExpenseSevenDays: Double {
            var total: Double = 0
            for expense in expensesLast7Days {
                total += expense.amount
            }
            
            return total
        }
        
        
        
        NavigationStack {
            List {
                
                Section("Overview"){
                    Chart(expensesLast7Days){expense in
                        BarMark(x: .value("date", expense.date, unit: .day), y: .value("value", expense.amount))
                            .foregroundStyle(by: .value("Product Category", expense.category!.categoryName))
                    }
                    .padding()
                }
                
                Section("Spending") {
                    
                    //Spending last 7 days
                    VStack (alignment: .leading){
                        HStack (spacing: 4) {
                            Text("$")
                                .fontWeight(.semibold)
                            Text(totalExpenseSevenDays as NSNumber, formatter: formatterText)
                        }
                        .font(.title.bold())
                        Text("7 day spending")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    
                    //Total spending
                    VStack (alignment: .leading){
                        HStack (spacing: 4) {
                            Text("$")
                                .fontWeight(.semibold)
                            Text(totalExpense as NSNumber, formatter: formatterText)
                        }
                        .font(.title.bold())
                        Text("Total spent")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    
                    
                }
                
                Section("Last 7 days") {
                    ForEach(expensesLast7Days) { expense in
                        ExpenseCardView(expense: expense, showDate: true)
                    }
                }
                
                //ADD SOME KIND OF FEATURE SO THAT THEY CAN PRESS THE 7 DAY THING AND CHOOSE WHAT TIME PERIOD THEY WANT TO SEE SPENDING WITHIN
                
                //ALSO INCORPORATE CHARTS TO VISUALIZE SPENDING
                
            }
            .navigationTitle("Summary")
        }
    }
}

#Preview {
    SummaryView()
}
