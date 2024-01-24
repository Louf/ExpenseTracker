//
//  CategoriesView.swift
//  ExpenseTracker
//
//  Created by Louis Farmer on 12/10/23.
//

import SwiftUI
import SwiftData

struct CategoriesView: View {
    @Query(animation: .snappy) private var allCategories: [Category]
    @Environment(\.modelContext) private var context
    //View properties
    @State private var addCategory: Bool = false
    @State private var categoryName: String = ""
    
    @State private var deleteRequest: Bool = false
    @State private var requestedCategory: Category?
    
    @State private var selectedColor: Color = .red
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(allCategories.sorted(by: {
                    //Display the categories that have the most items inside first.
                    ($0.expenses?.count ?? 0) > ($1.expenses?.count ?? 0)
                })) { category in
                    DisclosureGroup {
                        if let expenses = category.expenses, !expenses.isEmpty {
                            ForEach(expenses) { expense in
                                ExpenseCardView(expense: expense, displayTag: false)
                            }
                        } else {
                            ContentUnavailableView {
                                Label("No expenses", systemImage: "tray.fill")
                            }
                        }
                    } label: {
                        Text(category.categoryName)
                        
                        Circle()
                            .foregroundColor(Color(hex: category.tagColor))
                            .frame(width: 18, height: 18)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            deleteRequest.toggle()
                            requestedCategory = category
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }
                }
            }
            .navigationTitle("Categories")
            .toolbarTitleDisplayMode(.inlineLarge)
            .overlay {
                if allCategories.isEmpty {
                    ContentUnavailableView {
                        Label("No categories", systemImage: "tray.fill")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addCategory.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 32))
                            .padding(.top, 20)
                    }
                }
            }
            .sheet(isPresented: $addCategory) {
                categoryName = ""
            } content: {
                NavigationStack {
                    List {
                        Section("Title") {
                            TextField("General", text: $categoryName)
                        }
                        
                        Section("Tag color") {
                            CategoryColorPicker(selectedColor: $selectedColor)
                        }
                    }
                    .navigationTitle("Category Name")
                    .navigationBarTitleDisplayMode(.inline)
                    //Add and cancel
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel") {
                                addCategory = false
                            }
                            .tint(.red)
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Add") {
                                //add a new category
                                
                                let category = Category(categoryName: categoryName, tagColor: selectedColor.toHex() ?? "ff0000")
                                context.insert(category)
                                
                                categoryName = ""
                                
                                addCategory = false
                            }
                            .disabled(categoryName.isEmpty)
                        }
                    }
                }
                .presentationDetents([.height(280)])
                .presentationCornerRadius(20)
                .interactiveDismissDisabled()
            }

        }
        .alert("If you delete a category, all of the associated expenses will be deleted too.", isPresented: $deleteRequest) {
            Button(role: .destructive) {
                //Deleting a category
                if let requestedCategory {
                    context.delete(requestedCategory)
                    self.requestedCategory = nil
                }
            } label: {
                Text("Delete")
            }
            
            Button(role: .cancel) {
                requestedCategory = nil
            } label: {
                Text("Cancel")
            }


        }
    }
}

#Preview {
    CategoriesView()
}
