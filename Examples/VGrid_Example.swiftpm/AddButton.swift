import SwiftUI


struct AddButton: View {
    
    let proc: () -> ()
    
    var body: some View {
        Button {
            proc()
        } label: {
            Image(systemName: "plus.square")
                .font(.system(size: 50))
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
        .scaleEffect(configuration.isPressed ? 0.8 : 1)
        //.rotationEffect(Angle(degrees: configuration.isPressed ? -45 : 0))
            .animation(.easeOut(duration: configuration.isPressed ? 0.05 : 0.2), value: configuration.isPressed)
    }
}
