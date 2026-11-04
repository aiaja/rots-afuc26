//
//  DayCell.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import SwiftUI

/// One tappable date, shared by the week strip and the month picker.
struct DayCell: View {
    let day: ThoughtDay
    let date: Date
    let isSelected: Bool
    let mood: Mood?
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(date, format: .dateTime.day())
                .font(.title3)
                .foregroundStyle(foreground)
                .frame(width: 44, height: 44)
                .background {
                    if isSelected {
                        Circle().fill(DSColor.brandTint)
                    }
                }
                .overlay(alignment: .bottom) {
                    if let mood {
                        Circle()
                            .fill(mood.color)
                            .frame(width: 6, height: 6)
                            .offset(y: -3)
                    }
                }
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .accessibilityLabel(Text(date, format: .dateTime.weekday(.wide).day().month(.wide)))
        .accessibilityValue(mood?.title ?? Text(verbatim: ""))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var foreground: Color {
        if isSelected { return DSColor.brand }
        return isEnabled ? .primary : Color(.tertiaryLabel)
    }
}
