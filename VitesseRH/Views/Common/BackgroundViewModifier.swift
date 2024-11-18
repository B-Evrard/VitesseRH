//
//  BackgroundViewModifier.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 01/11/2024.
//

import SwiftUI

struct BackgroundViewModifier : ViewModifier {
    let colors:  [Color]
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
                           .edgesIgnoringSafeArea(.all)
            content
        }
      
    }
}

extension View {
    public func applyBackground(_ colors: [Color]) -> some View {
        modifier(BackgroundViewModifier(colors: colors))
    }
}

