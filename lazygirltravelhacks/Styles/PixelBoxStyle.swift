import SwiftUI

// The color palette for your new screen
struct DashboardTheme {
    static let text = Color(red: 0/255, green: 79/255, blue: 111/255)
    
    struct MainBox {
        static let fill = Color(red: 254/255, green: 244/255, blue: 225/255)
        static let border = Color(red: 234/255, green: 184/255, blue: 139/255)
        static let shadow = Color(red: 184/255, green: 121/255, blue: 71/255)
    }
    
    struct ActionButton {
        static let fill = Color(red: 241/255, green: 180/255, blue: 153/255)
        static let border = Color(red: 219/255, green: 133/255, blue: 99/255)
        static let shadow = Color(red: 171/255, green: 89/255, blue: 56/255)
    }
}

// The reusable style modifier
struct PixelBoxStyle: ViewModifier {
    var fillColor: Color
    var borderColor: Color
    var shadowColor: Color

    func body(content: Content) -> some View {
        content
            .background(fillColor)
            .border(borderColor, width: 3)
            .offset(y: -3)
            .background(shadowColor)
            .offset(y: 3)
    }
}

extension View {
    func pixelBoxStyle(fill: Color, border: Color, shadow: Color) -> some View {
        self.modifier(PixelBoxStyle(fillColor: fill, borderColor: border, shadowColor: shadow))
    }
}
