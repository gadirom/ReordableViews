import SwiftUI
import ContainerGeometry

let dispatchDelay = 0.005
let defaultReorderDelay = 0.3

public struct ReordableForEach<Element, ID, Content>: View
where Element : Equatable,
      ID : Hashable,
      Content: View{
    
    @EnvironmentObject internal var geometryData: ContainerGeometry
    
    public var elements: Binding<[Element]>
    
    var moveStyle: MoveStyle = .simple
    
    var reorderDelay: Double = defaultReorderDelay
    
    let dragMinimumDistance: Double
    var initialTolerance: Double {
        dragMinimumDistance * 3
    }
    
    let boundaryBehavior: BoundaryBehavior
    
    let id: KeyPath<Element, ID>
    
    let content: (Binding<Element>,
                  Bool, Bool, Bool)    //dragged, hovered, onTop
    
    -> Content
    
    var reorderCallback: (Int, Int)->() = {_, _ in }
    
    var releaseAnimation: Animation = .default
    var moveAnimation: Animation = .default
    
    @State var releaseAnimationDummy: CGFloat = 0
    func startReleaseAnimation(){
        releaseAnimationDummy = 1
        withAnimation(releaseAnimation) { 
            releaseAnimationDummy = 0
        }
    }
    @State var moveAnimationDummy: CGFloat = 0
    @State var moveAnimating = false
    func startmoveAnimation(){
        moveAnimating = true
        moveAnimationDummy = 1
        withAnimation(moveAnimation) { 
            moveAnimationDummy = 0
        }
    }
    
    @GestureState internal var dragging = false
    @State internal var offset = CGSize()
    @State internal var prevTranslation = CGSize()
    @State internal var location = CGPoint()
    
    @State internal var draggedView: Int? = nil
    @State internal var hoverView: Int? = nil
    @State internal var onTopView: Int? = nil
    
    @State internal var draggedOutOfBounds = false
}
