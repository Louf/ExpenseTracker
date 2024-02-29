import Foundation

//Decimal formatter for text input
var formatterInput: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    return formatter
}


//Decimal formatter for text
var formatterText: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    return formatter
}

var dateFormatterShort: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}
