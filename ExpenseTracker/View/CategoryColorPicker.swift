//
//  CategoryColorPicker.swift
//  ExpenseTracker
//
//  Created by Louis Farmer on 12/12/23.
//

import SwiftUI

struct CategoryColorPicker: View {
    @Binding var selectedColor: Color
    
    private let colors: [Color] = [.red, .yellow, .blue, .indigo, .purple, .green, .mint, .orange]
    
    var body: some View {
        ScrollView(.horizontal){
            HStack {
                ForEach(colors, id: \.self) { color in
                    Circle()
                        .foregroundColor(color)
                        .frame(width: 45, height: 45)
                        .opacity(color == selectedColor ? 0.5 : 1.0)
                        .overlay {
                            if color == selectedColor {
                                Image(systemName: "checkmark")
                            }
                        }
                        .onTapGesture {
                            selectedColor = color
                        }
                }
            }
        }
    }
}
