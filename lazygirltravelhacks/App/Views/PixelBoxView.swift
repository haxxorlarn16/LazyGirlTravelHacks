import SwiftUI

// This modifier is now more flexible and accepts an image name.
struct PixelImageBorderStyle: ViewModifier {
    let imageName: String // <-- NEW: Parameter for the asset name

    func body(content: Content) -> some View {
        content
            .background(
                Image(imageName) // <-- MODIFIED: Uses the imageName parameter
                    .resizable(
                        capInsets: EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10),
                        resizingMode: .tile
                    )
                    .interpolation(.none)
            )
    }
}

extension View {
    // The helper now requires you to specify which image to use.
    func pixelImageBorderStyle(imageName: String) -> some View {
        self.modifier(PixelImageBorderStyle(imageName: imageName))
    }
}
