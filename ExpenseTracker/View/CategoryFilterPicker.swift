import Foundation
import SwiftUI

struct CategoryFilterPicker: View {
    
    @Binding var allCategories: [Category]
    
    @Binding var selectedCategories: [String]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(allCategories.sorted(by: {
                    //Display the categories that have the most items inside first.
                    ($0.categoryName.lowercased()) < ($1.categoryName.lowercased())
                })) { category in
                    Text(category.categoryName)
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(hex: category.tagColor)!.gradient, in: .capsule)
                        .overlay {
                            if selectedCategories.contains(category.categoryName) {
                                Image(systemName: "checkmark")
                            }
                        }
                        .onTapGesture {
                            if !selectedCategories.contains(category.categoryName) {
                                selectedCategories.append(category.categoryName)
                            } else {
                                selectedCategories.removeAll { $0 == category.categoryName }
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}
