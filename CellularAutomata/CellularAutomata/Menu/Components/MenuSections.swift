// Copyright © 2020 Shawn James. All rights reserved.
// MenuSections.swift

protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
}

enum MenuSections: Int, CaseIterable, CustomStringConvertible {
    case presets
    case settings
    
    var description: String {
        switch self {
        case .presets: return "Presets"
        case .settings: return "Settings"
        }
    }
    
}

enum PresetOptions: Int, CaseIterable, SectionType {
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

enum SettingsOptions: Int, CaseIterable, SectionType {
    case setting1
    case setting2
    case setting3
    
    var containsSwitch: Bool {
        switch self {
        case .setting1: return true
        case .setting2: return true
        case .setting3: return false
        }
    }
    
    var description: String {
        switch self {
        case .setting1: return "Setting 1"
        case .setting2: return "Setting 2"
        case .setting3: return "Setting 3"
        }
    }
}
