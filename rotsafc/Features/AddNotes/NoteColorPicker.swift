import SwiftUI

struct NoteColorPicker: View {
    @Binding var selection: NoteColor
    
    var body: some View {
        HStack(spacing: DSSpacing.xxs) {
            ForEach(NoteColor.allCases) { item in
                let isSelected = item == selection
                Button { selection = item } label: {
                    Circle()
                        .fill(item.swatch)
                        .frame(width: 28, height: 28)
                        .overlay {
                            Circle().strokeBorder(
                                isSelected ? DSColor.brand : .black.opacity(0.12),
                                lineWidth: isSelected ? 2.5 : 1
                            )
                        }
                        .frame(width: 44, height: 44)
                        .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(item.title)
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
