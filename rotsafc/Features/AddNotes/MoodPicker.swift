import SwiftUI

struct MoodPicker: View {
    @Binding var selection: Mood
    
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text("How are you feeling?", bundle: .module)
                .font(.subheadline.weight(.semibold))
                .accessibilityAddTraits(.isHeader)
            
            HStack(spacing: DSSpacing.sm) {
                ForEach(Mood.allCases) { mood in
                    MoodOption(mood: mood, isSelected: mood == selection) { selection = mood }
                }
            }
            .dynamicTypeSize(...DynamicTypeSize.xLarge)
        }
        .accessibilityElement(children: .contain)
    }
}

private struct MoodOption: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: DSSpacing.xxs) {
                mood.sticker
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .scaleEffect(isSelected ? 1.08 : 1)
                    .animation(.spring(duration: 0.3, bounce: 0.4), value: isSelected)
                mood.title
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .foregroundStyle(isSelected ? DSColor.brand : Color.primary)
            }
            .frame(maxWidth: .infinity, minHeight: 44)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(mood.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
