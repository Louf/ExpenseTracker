import SwiftUI
import SwiftData

struct ExpenseCardView: View {
    @Bindable var expense: Expense
    
    var displayTag: Bool = true
    
    var showDate: Bool = false
    
    @State private var showExpense: Bool = false
    
    @Query(animation: .snappy) private var allCategories: [Category]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.title)
                
                Text(expense.subTitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                //Statements separated by a means they all must be true
                if let categoryName = expense.category?.categoryName, let categoryColor = expense.category?.tagColor, displayTag {
                    Text(categoryName)
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(hex: "\(categoryColor)")!.gradient, in: .capsule)
                }
                
                //If we pass in showDate as true, show the purchase date on the expense card
                
            }
            .lineLimit(1)
            
            Spacer(minLength: 5)
            
            VStack(alignment: .trailing) {
                
                if showDate {
                    Text(dateFormatterShort.string(from: expense.date))
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                //Currency String
                Text(expense.currencyString)
                    .font(.title3.bold())
                
                
            }
        }
        //contentShape allows us to touch anywhere in the HStack and have onTapGesture respond
        .contentShape(Rectangle())
        .onTapGesture {
            showExpense.toggle()
        }
        .sheet(isPresented: $showExpense) {
            
        } content: {
            NavigationStack {
                ZStack(alignment: .bottom){
                    List {
                        Section("Title") {
                            TextField("Magic Keyboard", text: $expense.title)
                        }
                        
                        Section("Description") {
                            TextField("Bought a keyboard at the Apple Store", text: $expense.subTitle)
                        }
                        
                        Section("Amount") {
                            HStack (spacing: 4) {
                                Text("$")
                                    .fontWeight(.semibold)
                                //Binding the $amount will automatically update everything in SwiftData
                                TextField("0.0", value: $expense.amount, formatter: formatterInput)
                                    .keyboardType(.numberPad)
                            }
                            .font(.title.bold())
                        }
                        
                        Section("Category") {
                            if !allCategories.isEmpty {
                                HStack {
                                    Text("Category")
                                    
                                    Spacer()
                                    
                                    //Moved from a picker to a menu instead so that the UI is how we want it
                                    Menu {
                                        ForEach(allCategories) { category in
                                            Button(category.categoryName) {
                                                expense.category = category
                                            }
                                        }
                                        
                                        Button("None") {
                                            expense.category = nil
                                        }
                                    } label: {
                                        if let categoryName = expense.category?.categoryName {
                                            Text(categoryName)
                                        } else {
                                            Text("None")
                                        }
                                    }
                                }
                            }
                        }
                        
                        Section("Date") {
                            DatePicker("", selection: $expense.date, displayedComponents: [.date])
                                .datePickerStyle(.graphical)
                                .labelsHidden()
                                .padding(.bottom, 56)
                        }
                        
                        
                    }
                    .environment(\.defaultMinListRowHeight, 20)
                    .navigationTitle("Edit expense")
                    
                    
                    
                    Button {
                        showExpense = false
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .font(.headline.bold())
                            .foregroundStyle(.white)
                            .background((expense.title.isEmpty || expense.subTitle.isEmpty) ? AnyShapeStyle(.gray.gradient) : AnyShapeStyle(.blue.gradient), in: .capsule)
                            .padding()
                    }
                    .disabled(expense.title.isEmpty)
                }
            }
            .presentationCornerRadius(20)
            .interactiveDismissDisabled()
            
        }
        
        
    }
}
