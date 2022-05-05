import SwiftUI

public extension ReordableForEach{
    
    func onReorder(_ proc: @escaping (Int, Int)->()) -> ReordableForEach{
        var newView = self
        newView.reorderCallback = proc
        return newView
    }
    
    func moveAnimation(_ animation: Animation) -> ReordableForEach{
        var newView = self
        newView.moveAnimation = animation
        return newView
    }
    func releaseAnimation(_ animation: Animation) -> ReordableForEach{
        var newView = self
        newView.releaseAnimation = animation
        return newView
    }
    func reorderDelay(_ delay: Double) -> ReordableForEach{
        var newView = self
        newView.reorderDelay = delay
        return newView
    }
    func moveStyle(_ style: MoveStyle) -> ReordableForEach{
        var newView = self
        newView.moveStyle = style
        return newView
    }
}
