import SwiftUI
import ContainerGeometry

public struct ReordableVGrid<Item: Equatable,
                 ItemView: View,
                 AddButton: View,
                    ID: Hashable>: View {
    public init(items: Binding<[Item]>,
                activeItem: Binding<Item>,
                maxItems: Int,
                columns: [GridItem],
                alignment: HorizontalAlignment,
                spacing: CGFloat,
                moveAnimation: Animation,
                selectAnimation: Animation,
                reorderDelay: Double, id: KeyPath<Item, ID>,
                addButton: AddButton,
                itemView: @escaping (Binding<Item>, Bool, Bool, Bool, Bool, @escaping () -> (), @escaping () -> ()) -> ItemView,
                orderChanged: @escaping (Int, Int) -> ()) {
        self._items = items
        self._activeItem = activeItem
        self.maxItems = maxItems
        self.columns = columns
        self.alignment = alignment
        self.spacing = spacing
        self.moveAnimation = moveAnimation
        self.selectAnimation = selectAnimation
        self.reorderDelay = reorderDelay
        self.id = id
        self.addButton = addButton
        self.itemView = itemView
        self.orderChanged = orderChanged
    }
    
    @EnvironmentObject var data: ContainerGeometry
    
    @Binding var items: [Item]
    
    @Binding var activeItem: Item
    
    let maxItems: Int
    
    let columns: [GridItem]
    
    let alignment: HorizontalAlignment
    let spacing: CGFloat
    
    let moveAnimation: Animation
    let selectAnimation: Animation
    
    let reorderDelay: Double
    
    let id: KeyPath<Item, ID>
    
    let addButton: AddButton
    
    let itemView: (Binding<Item>,
                   Bool,    //active
                   Bool,    //dragged
                   Bool,     //hovered
                   Bool,     //onTop
                  @escaping () -> (),//del action
                  @escaping () -> ())
    -> ItemView
    
    let orderChanged: (Int, Int)->()
    
    public var body: some View {
        LazyVGrid(columns: columns,
                  alignment: alignment,
                  spacing: spacing) {
            ReordableForEach($items,
                             id: id){ $item, isDragged, isHovered, isOnTop  in
                let isActive = item == activeItem
                
                itemView($item,
                         isActive,
                         isDragged,
                         isHovered,
                         isOnTop,
                         {
                    withAnimation(moveAnimation){ items.remove(at: items.firstIndex(where: {$0==item})!) }
                         },
                        {
                    withAnimation(selectAnimation){ activeItem = item }
                        })
            }.onReorder{ from, to in
                orderChanged(from, to)
            }
            .moveAnimation(moveAnimation)
            .releaseAnimation(selectAnimation)
            .reorderDelay(0.3)
            .moveStyle(.simple)
            let hideAddButton = items.count == maxItems
            if !hideAddButton{
                addButton
            }
        }
    }
}

