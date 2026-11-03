//
//  SpeechBubble.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import SwiftUI

/// A white speech bubble with a small tail pointing at the chick.
public struct SpeechBubble: View {
    public enum TailEdge: Sendable {
        case leading
        case bottom
    }

    private let text: Text
    private let tailEdge: TailEdge

    public init(_ text: Text, tailEdge: TailEdge) {
        self.text = text
        self.tailEdge = tailEdge
    }

    public var body: some View {
        text
            .font(.subheadline)
            .foregroundStyle(.primary)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, 14)
            .background {
                RoundedRectangle(cornerRadius: DSRadius.bubble, style: .continuous)
                    .fill(.white)
                    .overlay(alignment: tailEdge == .leading ? .leading : .bottom) { tail }
                    .shadow(color: DSColor.brandShadow, radius: 9, y: 6)
            }
    }

    private var tail: some View {
        BubbleTail()
            .fill(.white)
            .frame(width: 10, height: 14)
            .rotationEffect(tailEdge == .leading ? .degrees(90) : .zero)
            .offset(
                x: tailEdge == .leading ? -10 : 0,
                y: tailEdge == .bottom ? 10 : 0
            )
    }
}

private struct BubbleTail: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
