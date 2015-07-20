import Foundation
import QuartzCore


public struct TextDrawingItem {
    public let textToDraw: CFMutableAttributedStringRef
    public let frameRect: CGRect
    public var height: Int {
        
        return  Int(frameRect.origin.y)
    }
  }
