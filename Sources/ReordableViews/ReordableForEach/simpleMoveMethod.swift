import SwiftUI

extension Array{
    mutating func simpleMove(from: Int, to: Int){
    var fromID: Int
    var toID: Int
    if from>to{
        fromID = from
        toID = to
    }else{
        fromID = from
        toID = to+1
    }
    self.move(fromOffsets: IndexSet([fromID]), toOffset: toID)
    }
}
