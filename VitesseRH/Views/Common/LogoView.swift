//
//  ExtractedView.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/10/2024.
//

import SwiftUI
struct LogoView: View {
    @State var width: CGFloat = 335
    @State var height: CGFloat = 100
    
    var body: some View {
        Image("Logo")
            .resizable()
            .frame(width: width, height: height)
    }
}
