import SwiftUI

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}

extension CGPoint{
    static func +(lhs: CGPoint, rhs: CGSize) -> CGPoint{
        CGPoint(
            x: lhs.x + rhs.width,
            y: lhs.y + rhs.height
        )
    }
    
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint{
        CGPoint(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y
        )
    }
    
    static func +=(lhs: inout CGPoint, rhs: CGPoint) {
        lhs = CGPoint(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y
        )
    }
    
    static func -(lhs: CGPoint, rhs: CGSize) -> CGPoint{
        CGPoint(
            x: lhs.x - rhs.width,
            y: lhs.y - rhs.height
        )
    }
    
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint{
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGSize{
        CGSize(
            width: lhs.x - rhs.x,
            height: lhs.y - rhs.y
        )
    }
    
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGSize{
        CGSize(
            width: lhs.x + rhs.x,
            height: lhs.y + rhs.y
        )
    }
    
    static func  /(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        CGPoint(x: lhs.x / rhs,
                y: lhs.y / rhs)
    }
    
    func length() -> CGFloat{
        sqrt(x * x + y * y)
    }
    
    func normalized() -> CGPoint {
        let len = length()
        return len>0 ? self / len : .zero
    }
}

extension CGSize{
    
    init(p: CGPoint){
        self.init(width:p.x, height:p.y)
    }
    
    func length() -> CGFloat{
        sqrt(width * width + height * height)
    }
    
    func normalized() -> CGSize {
        let len = length()
        return len>0 ? self / len : .zero
    }
    
    static func +=(lhs: inout CGSize, rhs: CGSize) {
        lhs = CGSize(
            width: lhs.width + rhs.width,
            height: lhs.height + rhs.height
        )
    }
    
    static func +(lhs: CGSize, rhs: CGSize) -> CGSize{
        CGSize(
            width: lhs.width + rhs.width,
            height: lhs.height + rhs.height
        )
    }
    
    static func -(lhs: CGSize, rhs: CGSize) -> CGSize{
        CGSize(
            width: lhs.width - rhs.width,
            height: lhs.height - rhs.height
        )
    }
    
    static func  *(lhs: CGSize, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width * rhs,
               height: lhs.height * rhs)
    }
    
    static func  +(lhs: CGSize, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width + rhs,
               height: lhs.height + rhs)
    }
    
    static func  /(lhs: CGSize, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width / rhs,
               height: lhs.height / rhs)
    }
}

