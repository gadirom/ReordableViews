import SwiftUI

extension ReordableForEach{
    func reorderTask() async{
        do{
            try await Task.sleep(seconds: reorderDelay)
            if !moveAnimating{
                reorder()
            }else{//if animating restart the task
                await reorderTask()
            }
        }catch{
            //hovered less than reorderDelay
        }
    }
    func reorder(){
        if let draggedItem = draggedView,
           let hoverItem = hoverView,
           let dragID = elements.wrappedValue.firstIndex(where: {$0[keyPath: id].hashValue==draggedItem}),
           let hoverID = elements.wrappedValue.firstIndex(where: {$0[keyPath: id].hashValue==hoverItem}),
           hoverID != dragID{
            
            moveAction(from: dragID, to: hoverID)
            hoverView = nil
            withAnimation(moveAnimation) {
                offset = CGSize()
            }
            startmoveAnimation()
        }
    }
    
}
