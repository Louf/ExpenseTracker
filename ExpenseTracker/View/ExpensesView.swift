import SwiftUI
import SwiftData

struct ExpensesView: View {
    //So we know in here which tab we are in currently
    @Binding var currentTab: String
    
    @Query(sort: [
        SortDescriptor(\Expense.date, order: .reverse)
    ], animation: .snappy) private var allExpenses: [Expense]
    
    @Query(animation: .snappy) private var allCategories: [Category]
    
    @Environment(\.modelContext) private var context
    
    @State private var groupedExpenses: [GroupedExpenses] = []
    @State private var originalGroupedExpenses: [GroupedExpenses] = []
    @State private var addExpense: Bool = false
    
    @State private var allCategoriesData: [Category] = []
    
    @State private var searchText: String = ""
    
    @State private var selectedCategories: [String] = []
    
    var body: some View {
        NavigationStack {
            CategoryFilterPicker(allCategories: $allCategoriesData, selectedCategories: $selectedCategories)
            
            List {
                ForEach($groupedExpenses) { $group in
                    Section(group.groupTitle) {
                        ForEach(group.expenses) { expense in
                            //Card view for expense
                            ExpenseCardView(expense: expense)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    //Delete button
                                    Button {
                                        //Deleting the data
                                        context.delete(expense)
                                        withAnimation {
                                            group.expenses.removeAll(where: {
                                                $0.id == expense.id
                                            })
                                            //Removing a group if it has no expenses in it.
                                            if group.expenses.isEmpty {
                                                groupedExpenses.removeAll(where: {
                                                    $0.id == group.id
                                                })
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .tint(.red)
                                }
                        }
                    }
                }
                
            }
            .navigationTitle("Expenses")
            .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: Text("Search"))
            .overlay {
                if allExpenses.isEmpty || groupedExpenses.isEmpty {
                    ContentUnavailableView("No Expenses", systemImage: "tray.fill")
                }
            }
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addExpense.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 32))
                            .padding(.top, 20)
                    }
                }
            }
        }
        //Filtering the results based on text or categories
        .onChange(of: searchText, initial: false) { oldValue, newValue in
            if !newValue.isEmpty {
                filterExpenses(newValue)
            } else {
                groupedExpenses = originalGroupedExpenses
            }
        }
        .onChange(of: selectedCategories, { oldValue, newValue in
            if !newValue.isEmpty {
                filterExpensesByCategory()
            } else {
                groupedExpenses = originalGroupedExpenses
            }
        })
        .onChange(of: allExpenses, initial: true) { oldValue, newValue in
            if newValue.count > oldValue.count || groupedExpenses.isEmpty || currentTab == "Categories" {
                createGroupedExpenses(newValue)
            }
        }
        //Three checks, one to see if something was added, the next to see if it's empty, meaning the initial check will fill the array with data (otherwise it'll be empty until we add something)
        .onChange(of: allCategories, initial: true) { oldValue, newValue in
            if newValue.count > oldValue.count || allCategoriesData.isEmpty || currentTab == "Categories" {
                allCategoriesData = allCategories
            }
        }
        
        .fullScreenCover(isPresented: $addExpense){
            AddExpenseView()
                .interactiveDismissDisabled()
        }
    }
    
    //Filtering expenses
    func filterExpenses(_ text: String) {
        Task.detached(priority: .high) {
            let query = text.lowercased()
            let filteredExpenses = originalGroupedExpenses.compactMap { group -> GroupedExpenses? in
                let expenses = group.expenses.filter({ $0.title.lowercased().contains(query) })
                if expenses.isEmpty {
                    return nil
                }
                return .init(date: group.date, expenses: expenses)
            }
            
            await MainActor.run {
                groupedExpenses = filteredExpenses
            }
        }
    }
    
    //Filtering expenses by category
    func filterExpensesByCategory() {
        Task.detached(priority: .high) {
            let filteredExpenses = originalGroupedExpenses.compactMap { group -> GroupedExpenses? in
                let expenses = group.expenses.filter({ selectedCategories.contains($0.category?.categoryName ?? "") })
                if expenses.isEmpty {
                    return nil
                }
                return .init(date: group.date, expenses: expenses)
            }
            
            await MainActor.run {
                groupedExpenses = filteredExpenses
            }
        }
    }
    
    //Grouping expenses by date
    func createGroupedExpenses(_ expenses: [Expense]) {
        Task.detached(priority: .high) {
            //This is a dictionary which is grouped by Date
            let groupedDict = Dictionary(grouping: expenses) { expense in
                let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: expense.date)
                
                //Returns to groupedDict
                return dateComponents
            }
            
            //Sorting the dictionary in descending order
            let sortedDict = groupedDict.sorted {
                let calendar = Calendar.current
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }
            
            //Adding to the Grouped Expenses array
            await MainActor.run {
                groupedExpenses = sortedDict.compactMap({ dict in
                    let date = Calendar.current.date(from: dict.key) ?? .init()
                    return .init(date: date, expenses: dict.value)
                })
                originalGroupedExpenses = groupedExpenses
            }
        }
    }
}

#Preview {
    ContentView()
}
