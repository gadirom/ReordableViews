import SwiftUI

extension ReordableForEach{
    func moveAction(from: Int, to: Int){
        switch moveStyle{
        case .simple:
            simpleMoveAction(from: from, to: to)
            DispatchQueue.main.async {
                reorderCallback(from, to)
            }
        case .fancy(let delay): 
            reorderIteration(from: from, to: to, delay: delay)
            DispatchQueue.main.async {
                reorderCallback(from, to)
            }
        }
    }
    func reorderIteration(from: Int, to: Int, delay: Double){
        if from == to { return }
        else {
            let step = (to-from)/abs(to-from)
            self.simpleMoveAction(from: from, to: from+step)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay){ 
                reorderIteration(from: from + step, to: to, delay: delay)
            }
        }
    }
    func simpleMoveAction(from: Int, to: Int){
        withAnimation(self.moveAnimation){
            self.elements.wrappedValue.simpleMove(from: from, to: to) 
        } 
    }
}
