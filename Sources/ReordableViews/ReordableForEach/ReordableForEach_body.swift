import SwiftUI

extension ReordableForEach{
    public var body: some View {
        ForEach(elements, id: id){ $element  in
            let hashValue = element[keyPath: id].hashValue
            let isDragged = draggedView == hashValue
            let isHovered = (hoverView == hashValue) && !isDragged
            let isOnTop = onTopView == hashValue
            content($element,
                    isDragged, 
                    isHovered,
                    isOnTop)
                .subViewGeometry(id: element[keyPath: id])
            
                .zIndex(isOnTop ? 1 : 0)
                .offset(isDragged || isOnTop ? offset : CGSize())
        }
        .highPriorityGesture(drag, including: .all)
        
        .onAnimationCompleted(for: releaseAnimationDummy) { 
            if draggedView == nil{
                onTopView = nil
            }
        }
        .onAnimationCompleted(for: moveAnimationDummy) { 
            moveAnimating = false
            checkForHovered()
        }
        .task(id: hoverView) {
            if hoverView != nil && hoverView != draggedView{
                await reorderTask()
            }
        }
    }
    func checkForHovered(){
        if let id = geometryData.frames(containing: location).first?.hashValue{
            if draggedView != nil{
                hoverView = id
            }
        }else{
            hoverView = nil
        }
    }
}
