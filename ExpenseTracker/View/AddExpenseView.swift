//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Louis Farmer on 12/11/23.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    //View properties
    @State private var title: String = ""
    @State private var subTitle: String = ""
    @State private var date: Date = .init()
    @State private var amount: CGFloat = 0
    @State private var category: Category?
    @State private var isIncome: Bool = false
    
    //Categories
    @Query(animation: .snappy) private var allCategories: [Category]
    
    var body: some View {
        NavigationStack {
            List {
                Section("Title") {
                    TextField("Magic Keyboard", text: $title)
                }
                
                Section("Description") {
                    TextField("Bought a keyboard at the Apple Store", text: $subTitle)
                }
                
                Section("Amount Spent") {
                    HStack (spacing: 4) {
                        Text("$")
                            .fontWeight(.semibold)
                        //Could also do code USD
                        TextField("0.0", value: $amount, formatter: formatterInput)
                            .keyboardType(.numberPad)
                    }
                }
                
                //Category Picker
                if !allCategories.isEmpty {
                    HStack {
                        Text("Category")
                        
                        Spacer()
                        
                        //Moved from a picker to a menu instead so that the UI is how we want it
                        Menu {
                            ForEach(allCategories) { category in
                                Button(category.categoryName) {
                                    self.category = category
                                }
                            }
                            
                            Button("None") {
                                category = nil
                            }
                        } label: {
                            if let categoryName = category?.categoryName {
                                Text(categoryName)
                            } else {
                                Text("None")
                            }
                        }
                    }
                }
                
                Section("Date") {
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
                
                
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                //Cancel and add button
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.red)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add", action: addExpense)
                        .disabled(isAddButtonDisabled)
                }
            }
        }
    }
    
    //Disabling add button until all data has been entered
    var isAddButtonDisabled: Bool {
        return title.isEmpty || subTitle.isEmpty || amount == .zero
    }
    
    //Adding expense to the SwiftData
    func addExpense(){
        let expense = Expense(title: title, subTitle: subTitle, amount: amount, date: date, category: category)
        context.insert(expense)
        
        //Close the view
        dismiss()
    }
}

#Preview {
    AddExpenseView()
}
