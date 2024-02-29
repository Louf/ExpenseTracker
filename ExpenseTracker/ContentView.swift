import SwiftUI

struct ContentView: View {
    @State private var currentTab: String = "Summary"
    
    var body: some View {
        TabView(selection: $currentTab) {
            SummaryView()
                .tag("Summary")
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Summary")
                }
            
            ExpensesView(currentTab: $currentTab)
                .tag("Expenses")
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("Expenses")
                }
            
            CategoriesView()
                .tag("Categories")
                .tabItem {
                    Image(systemName: "list.clipboard.fill")
                    Text("Categories")
                }
        }
    }
}

#Preview {
    ContentView()
}
