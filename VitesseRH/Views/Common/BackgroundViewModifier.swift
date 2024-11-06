//
//  BackgroundViewModifier.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 01/11/2024.
//

import SwiftUI

struct BackgroundViewModifier : ViewModifier {
    let color:  Color
    func body(content: Content) -> some View {
        ZStack {
            Color(color)
                .edgesIgnoringSafeArea(.all)
            content
        }
      
    }
}

extension View {
    public func applyBackground(_ color: Color) -> some View {
        modifier(BackgroundViewModifier(color: color))
    }
}


