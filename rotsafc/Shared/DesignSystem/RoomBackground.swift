//
//  RoomBackground.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import SwiftUI

/// The pink room behind every screen: a soft wall with a curved floor.
public struct RoomBackground: View {
    private let floorHeight: CGFloat

    /// - Parameter floorHeight: How far the top of the floor sits above the screen's bottom edge.
    public init(floorHeight: CGFloat) {
        self.floorHeight = floorHeight
    }

    public var body: some View {
        LinearGradient(
            colors: [DSColor.wallTop, DSColor.wallBottom],
            startPoint: .top,
            endPoint: .bottom
        )
        .overlay { RoomFloor(height: floorHeight) }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}

/// The curved pink floor the chick stands on.
public struct RoomFloor: View {
    private let height: CGFloat

    /// - Parameter height: How far the top of the floor sits above the view's bottom edge.
    public init(height: CGFloat) {
        self.height = height
    }

    public var body: some View {
        Color.clear
            .overlay(alignment: .bottom) {
                Ellipse()
                    .fill(DSColor.ground)
                    .frame(width: 762, height: 420)
                    .offset(y: 420 - height)
            }
            .clipped()
            .accessibilityHidden(true)
    }
}
