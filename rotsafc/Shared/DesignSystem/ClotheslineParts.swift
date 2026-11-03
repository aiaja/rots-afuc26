//
//  ClotheslineParts.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import SwiftUI

/// A sagging line that notes hang from.
public struct Clothesline: View {
    public init() {}

    public var body: some View {
        ClotheslineCurve()
            .stroke(DSColor.clothesline, lineWidth: 1.5)
            .frame(height: 10)
            .accessibilityHidden(true)
    }
}

private struct ClotheslineCurve: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY),
            control: CGPoint(x: rect.midX, y: rect.maxY * 2)
        )
        return path
    }
}

/// The wooden peg that holds a note on the line.
public struct ClothesPeg: View {
    public init() {}

    public var body: some View {
        RoundedRectangle(cornerRadius: 2, style: .continuous)
            .fill(DSColor.pegBody)
            .frame(width: 8, height: 24)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(DSColor.pegSpring)
                    .frame(height: 2)
                    .offset(y: 9)
            }
            .shadow(color: .black.opacity(0.2), radius: 1, y: 1)
            .accessibilityHidden(true)
    }
}

extension View {
    /// Gives a view the flat paper look of a sticky note.
    public func stickyNote(_ color: Color) -> some View {
        background {
            RoundedRectangle(cornerRadius: DSRadius.note, style: .continuous)
                .fill(color)
                .shadow(color: .black.opacity(0.14), radius: 4, y: 5)
        }
    }
}
