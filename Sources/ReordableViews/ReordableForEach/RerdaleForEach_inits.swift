import SwiftUI

extension ReordableForEach{
    init(_ elements: Binding<[Element]>,
         id: KeyPath<Element, ID>,
         boundaryBehavior: BoundaryBehavior = .release,
         dragMinimumDistance: Double = 10,
         @ViewBuilder content:
         @escaping (Binding<Element>, Bool, Bool, Bool) //dragged, hovered, onTop
         -> Content){
        self.elements = elements
        self.id = id
        self.boundaryBehavior = boundaryBehavior
        self.dragMinimumDistance = dragMinimumDistance
        self.content = content
    }
}
