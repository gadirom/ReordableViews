import SwiftUI
import CGMath

extension ReordableForEach{
    var drag: some Gesture{
        DragGesture(minimumDistance: dragMinimumDistance, coordinateSpace: .named(geometryData.space))
            .updating($dragging){value, dragging, _ in 
                dragging = true
            }
            .onChanged{ value in
                
                location = value.location
                
                var constrain = false
                if draggedOutOfBounds { return }
                if !geometryData.containerFrame.contains(value.location){
                    switch boundaryBehavior{
                    case .release:
                        draggedOutOfBounds = true
                        endDragging()
                        return
                    case .constrain:
                        constrain = true
                    case .none: 
                        break
                    }
                }
                let currentTranslation = value.translation
                if let id = geometryData.frames(containing: location).first?.hashValue{
                    if draggedView == nil{
                        if currentTranslation.length() < initialTolerance{//prevent picking up on wide fast drags
                            draggedView = id
                            onTopView = id
                        }
                    }else{
                        hoverView = id
                    }
                }else{
                    hoverView = nil
                }
                offset = offset + (constrain ? CGSize() : (currentTranslation - prevTranslation))
                prevTranslation = currentTranslation
            }
            .onEnded{_ in
                endDragging()
                draggedOutOfBounds = false
            }
    }
    func endDragging(){
        DispatchQueue.main.async {
            withAnimation(releaseAnimation) {
                draggedView = nil
                hoverView = nil
                if !moveAnimating{
                    offset = CGSize()
                }
            }
            startReleaseAnimation()
            prevTranslation = CGSize()
        }
    }
}
