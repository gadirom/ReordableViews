import SwiftUI
import ReordableViews

struct ContentView: View {
    
    let moveAnimation: Animation = .spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0)
    let selectAnimation: Animation = .spring(response: 0.1, dampingFraction: 0.7, blendDuration: 0)
    
    let  columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State var items: [Int] = []
    @State var activeItem: Int?
    
    var body: some View {
        VStack{
            Spacer()
            VStack{
                ReordableVGrid(items: $items,
                               activeItem: $activeItem,
                               maxItems: 12,
                               columns: columns,
                               alignment: .center,
                               spacing: 2,
                               moveAnimation: moveAnimation,
                               selectAnimation: selectAnimation,
                               reorderDelay: 0.3,
                               id: \.self,
                               addButton: AddButton{
                    withAnimation {
                        items.append(items.count)
                    }
                }) {$item, active, dragged, hovered, onTop, onRemove, onSelect in
                    ZStack{
                        Rectangle()
                            .fill(Color.blue)
                        Text("\(item)")
                            .font(.system(size: 45))
                        Rectangle()
                            .stroke(.white, lineWidth: 5)
                            .opacity(active ? 1 : 0)
                        Rectangle()
                            .fill(.white)
                            .opacity(dragged ? 0.5 : 0)
                        Rectangle()
                            .fill(.black)
                            .opacity(hovered ? 0.5 : 0)
                    }.frame(height: 50)
                        .padding()
                        .onTapGesture {
                            onSelect()
                        }
                        .transition(.modifier(active: Rotation3DModifier(angle: 90), identity: Rotation3DModifier(angle: 0)).combined(with: .opacity))
                }
            orderChanged: {_,_ in }
                Spacer()
            }
                .frame(height: 500)
            Button {
                erase(.linear(duration: 0.5), delay: 50)
            } label: {
                Text("Clear")
            }
            Spacer()
        }
    }
    func erase(_ a: Animation, delay: Double){
            _ = items.enumerated().map{ (d, item) in
                withAnimation(a.delay(Double(d)/delay)){
                    items.removeLast()
                }
            }
        }
}

struct Rotation3DModifier: ViewModifier{
    let angle: Double
    
    func body(content: Content) -> some View {
        content.rotation3DEffect(Angle(degrees: angle), axis: (0, 1, 0))
    }
}
