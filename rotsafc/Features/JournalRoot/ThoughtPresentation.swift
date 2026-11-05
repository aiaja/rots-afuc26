//
//  ThoughtPresentation.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//
import SwiftUI

extension Mood {
    var title: Text {
        switch self {
        case .drained: Text("Drained", bundle: .module)
        case .down: Text("Down", bundle: .module)
        case .okay: Text("Okay", bundle: .module)
        case .good: Text("Good", bundle: .module)
        case .amazing: Text("Amazing", bundle: .module)
        }
    }

    var chickRemark: Text {
        switch self {
        case .drained: Text("You felt drained this day.", bundle: .module)
        case .down: Text("You felt down this day.", bundle: .module)
        case .okay: Text("You felt okay this day.", bundle: .module)
        case .good: Text("You felt good this day.", bundle: .module)
        case .amazing: Text("You felt amazing this day.", bundle: .module)
        }
    }

    var sticker: Image {
        Image("mood-\(rawValue)", bundle: .module)
    }

    var color: Color {
        switch self {
        case .drained: DSColor.moodDrained
        case .down: DSColor.moodDown
        case .okay: DSColor.moodOkay
        case .good: DSColor.moodGood
        case .amazing: DSColor.moodAmazing
        }
    }
}

extension NoteColor {
    var swatch: Color {
        switch self {
        case .yellow: DSColor.noteYellow
        case .peach: DSColor.notePeach
        case .mint: DSColor.noteMint
        case .lavender: DSColor.noteLavender
        case .blue: DSColor.noteBlue
        }
    }

    var title: Text {
        switch self {
        case .yellow: Text("Yellow", bundle: .module)
        case .peach: Text("Peach", bundle: .module)
        case .mint: Text("Mint", bundle: .module)
        case .lavender: Text("Lavender", bundle: .module)
        case .blue: Text("Blue", bundle: .module)
        }
    }
}

