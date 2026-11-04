//
//  DSPrimaryButtonStyle.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import SwiftUI

/// The full-width pink capsule used for each screen's main action.
public struct DSPrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(DSColor.brand, in: .capsule)
            .opacity(isEnabled ? 1 : 0.5)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(duration: 0.2), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == DSPrimaryButtonStyle {
    public static var dsPrimary: DSPrimaryButtonStyle { DSPrimaryButtonStyle() }
}
