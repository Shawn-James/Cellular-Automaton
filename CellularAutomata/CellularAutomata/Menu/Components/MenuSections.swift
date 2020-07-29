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

struct UserPresetOptions: SectionType {
    var description: String
    var containsSwitch: Bool { return false }
}

enum StandardPresetOptions: Int, CaseIterable, SectionType {
    case glider
    case jellyfish
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
        case .jellyfish: return "Jellyfish"
        case .spaceShip: return "Spaceship"
        case .random: return "Random"
        }
    }
}
