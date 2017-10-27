//
//  DCToolbox.swift
//  Treez.io
//
//  Created by Dan on 14.12.15.
//  Copyright (c) 2017 STRV. All rights reserved.
//

import Foundation
import UIKit

class DCToolbox {

    ////////////////////////////////////////////////////////////////
    // Screen

    class func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }

    class func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    ////////////////////////////////////////////////////////////////
    // Device Screen Types
    
    class func is3_5InchDisplay() -> Bool {
        return (Int(screenWidth()) == 320) && (Int(screenHeight()) == 480)
    }
    
    class func is4_0InchDisplay() -> Bool {
        return (Int(screenWidth()) == 320) && (Int(screenHeight()) == 568)
    }
    
    class func is4_7InchDisplay() -> Bool {
        return (Int(screenWidth()) == 375) && (Int(screenHeight()) == 667)
    }
    
    class func is5_5InchDisplay() -> Bool {
        return (Int(screenWidth()) == 414) && (Int(screenHeight()) == 736)
    }

    ////////////////////////////////////////////////////////////////
    // Environment

    class func isSimulator() -> Bool {
        #if IOS_SIMULATOR
            return true
        #else
            return false
        #endif
    }

    class func isDebugEnvironment() -> Bool
    {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    ////////////////////////////////////////////////////////////////
    // Size interpolation

    class func interpolateValue(_ value: CGFloat, valueX1: CGFloat, valueY1: CGFloat, valueX2: CGFloat, valueY2: CGFloat) -> CGFloat {
        return valueY1 + ((valueY2-valueY1)/(valueX2-valueX1)) * (value - valueX1)
    }

    class func roundInterpolateValue(_ value: CGFloat, valueX1: CGFloat, valueY1: CGFloat, valueX2: CGFloat, valueY2: CGFloat) -> CGFloat {
        return round(valueY1 + ((valueY2-valueY1)/(valueX2-valueX1)) * (value - valueX1))
    }
  
    ////////////////////////////////////////////////////////////////
    // System Folders

    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

func delay(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

////////////////////////////////////////////////////////////////
// MARK: - Asserts

func assertMainThread() {
    assert(Thread.current.isMainThread, "This method must be called on the main thread.")
}

func assertNotMainThread() {
    assert(!Thread.current.isMainThread, "This method must not be called on the main thread.")
}
