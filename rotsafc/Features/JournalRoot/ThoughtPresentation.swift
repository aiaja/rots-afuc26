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
//        case .drained: Text("Drained", bundle: .module)
//        case .down: Text("Down", bundle: .module)
//        case .okay: Text("Okay", bundle: .module)
//        case .good: Text("Good", bundle: .module)
//        case .amazing: Text("Amazing", bundle: .module)
            
        case .sadness: Text("Sadness", bundle: .module)
        case .fear: Text("Fear", bundle: .module)
        case .angry: Text("Angry", bundle: .module)
        case .disgust: Text("Disgust", bundle: .module)
        case .joy: Text("Joy", bundle: .module)
        }
    }

    var chickRemark: Text {
        switch self {
//        case .drained: Text("You felt drained this day.", bundle: .module)
//        case .down: Text("You felt down this day.", bundle: .module)
//        case .okay: Text("You felt okay this day.", bundle: .module)
//        case .good: Text("You felt good this day.", bundle: .module)
//        case .amazing: Text("You felt amazing this day.", bundle: .module)
            
        case .sadness: Text("Its okay to be sad, tomorrow will be better.", bundle: .module)
        case .fear: Text("I'm here, youre not alone.", bundle: .module)
        case .angry: Text("Calm down, I'm here.", bundle: .module)
        case .disgust: Text("It so disgusting, ewhh.", bundle: .module)
        case .joy: Text("You looks so happy today!.", bundle: .module)
        }
    }

    var sticker: Image {
        Image("mood-\(rawValue)", bundle: .module)
    }

    var color: Color {
        switch self {
//        case .drained: DSColor.moodDrained
//        case .down: DSColor.moodDown
//        case .okay: DSColor.moodOkay
//        case .good: DSColor.moodGood
//        case .amazing: DSColor.moodAmazing
            
        case .sadness: DSColor.moodSadness
        case .fear: DSColor.moodFear
        case .angry: DSColor.moodAngry
        case .disgust: DSColor.moodDisgust
        case .joy: DSColor.moodJoy
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

