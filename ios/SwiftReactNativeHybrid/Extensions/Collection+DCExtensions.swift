//
//  Collection+DCExtensions.swift
//  Treez.io
//
//  Created by Dan on 29.09.2017.
//  Copyright (c) 2017 STRV. All rights reserved.
//  Based on: https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings

import Foundation

extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
