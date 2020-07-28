// Copyright © 2020 Shawn James. All rights reserved.
// MenuSections.swift

protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
}

enum MenuSections: Int, CaseIterable, CustomStringConvertible {
    case user
    case standard
    
    var description: String {
        switch self {
        case .user: return "User"
        case .standard: return "Standard"
        }
    }
    
}

enum UserPresetOptions: Int, CaseIterable, SectionType {
    case preset1
    case preset2
    
    var containsSwitch: Bool { return false }
    
    var description: String {
        switch self {
        case .preset1: return "Preset 1"
        case .preset2: return "Preset 2"
        }
    }
    
}

enum StandardPresetOptions: Int, CaseIterable, SectionType {
    case glider
    case pulsar
    case spaceShip
    case random
    
    var containsSwitch: Bool { return false }
        // do this if want switches
//        switch self {
//        case .glider: return true
//        case .pulsar: return true
//        case .random: return false
//        }
//    }
    
    var description: String {
        switch self {
        case .glider: return "Glider"
        case .pulsar: return "Pulsar"
        case .spaceShip: return "Spaceship"
        case .random: return "Random"
        }
    }
}
