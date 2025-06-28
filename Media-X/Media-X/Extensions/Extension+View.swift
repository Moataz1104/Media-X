//
//  Extension+View.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    func dismissKeyboardOnTap() -> some View {
        self
            .contentShape(.rect)
            .onTapGesture {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )
            }
    }
}

//MARK: - CustomFonts
struct CustomFontModifier: ViewModifier {
    let fontName: FontsEnum
    let size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom(fontName.rawValue, size: size))
    }
}
extension View {
    func customFont(_ fontName: FontsEnum, size: CGFloat) -> some View {
        modifier(CustomFontModifier(fontName: fontName, size: size))
    }
}
