import SwiftUI
import ContainerGeometry

/// Same as SwiftUI's LazyVGrid, but with elements that can be selected and reordable by dragging
public struct ReordableVGrid<Item: Equatable,
                 ItemView: View,
                 AddButton: View,
                             ID: Hashable>: View {
    /// ReordableVGrid Initializer
    /// - Parameters:
    ///   - items: binding to array of items
    ///   - activeItem: binding to an active item
    ///   - maxItems: maximum items in the grid (used to hide the "Add Button" when the grid is full)
    ///   - columns: colums - the same as for  SwiftUI's LazyVGrid
    ///   - alignment: alignment in the grid
    ///   - spacing: spacing between views
    ///   - moveAnimation: animation that will be used for reordering views of the grid
    ///   - selectAnimation: animation that will be used for selecting an active item of the grid
    ///   - reorderDelay: a delay after a view is hovered above another one before items will be reordered
    ///   - id: keypath to hashable identifier of the grid item
    ///   - addButton: a view, with which a user interacts to add new elements (e.g. "+" button). Pass Color.clear if you don't want to use it.
    ///   - itemView: a view that will appear in the grid for each item in the `items` array.
    ///   It takes the following arguments:
    ///    Binding<Item> - binding to the displayed item
    ///    Bool - indicate if the item is active
    ///    Bool - indicate if the item is being dragged
    ///    Bool - indicate if the item is under a dragged item
    ///    Bool - indicate if the item is onTop of other items
    ///   - orderChanged: a closure that is called after reordering took place; takes two Int arguments (from, to) - indices of the `items` array. The reordering of the items is performed by the grid. In this closure you do additional actions if needed.
    public init(items: Binding<[Item]>,
                activeItem: Binding<Item?>,
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
    
    @Binding var items: [Item]
    
    @Binding var activeItem: Item?
    
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
            .reorderDelay(reorderDelay)
            .moveStyle(.simple)
            let hideAddButton = items.count == maxItems
            if !hideAddButton{
                addButton
            }
        }.container()
    }
}

