//
//  Item.swift
//  lazygirltravelhacks
//
//  Created by Lauren Jones on 7/17/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
