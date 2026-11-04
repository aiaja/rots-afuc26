//
//  ChuckState.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import Foundation
/// What the chick is doing. Each case maps to one animation clip in `Chick.usdz`.
public enum ChuckState: String, Sendable {
    case idle
    case greeting
    case reacting
}
