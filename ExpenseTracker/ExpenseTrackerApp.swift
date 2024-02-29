import SwiftUI
import SwiftData

@main
struct ExpenseTrackerApp: App {
    let modelContainer: ModelContainer
    
    //AFTER MAKING CHANGES TO THE CATEGORY, ALLOWING FOR A COLOR TO BE ADDED (EVEN THOUGH ITS JUST A STRING THAT I ADDED)
    
    init() {
            do {
                modelContainer = try ModelContainer(for: Expense.self, Category.self)
            } catch {
                fatalError("Could not initialize ModelContainer")
            }
    }
        
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
