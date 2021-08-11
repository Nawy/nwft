//
//  ButtonStyles.swift
//  NoWaitForTranslate
//
//  Created by Ivan Ermolaev on 04/08/2021.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
          Spacer()
            configuration.label.foregroundColor(NWFTStyleColors.secondAlternateColor)
                .font(NWFTFonts.primaryFont(withSize: 28.0))
          Spacer()
        }
        .padding(.all, 8.0)
        .background(NWFTStyleColors.secondBackgroudColor.cornerRadius(13.0))
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
        .shadow(color: NWFTStyleColors.darkColor, radius: 8.0, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
    }
}

struct DeleteButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        HStack {
          Spacer()
            configuration.label.foregroundColor(NWFTStyleColors.secondAlternateColor)
                .font(NWFTFonts.primaryFont(withSize: 17.0))
          Spacer()
        }
        .padding(.all, 5.0)
        .background(NWFTStyleColors.deleteColor.cornerRadius(15))
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
        .shadow(color: NWFTStyleColors.darkColor, radius: 6, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
    }
}


struct NavigationButton: View {
    
    let title: String
    var body: some View {
        HStack {
          Spacer()
            Text(title)
                .foregroundColor(NWFTStyleColors.secondAlternateColor)
                .font(NWFTFonts.primaryFont(withSize: 28.0))
          Spacer()
        }
        .padding(.all, 8.0)
        .background(NWFTStyleColors.secondBackgroudColor.cornerRadius(13))
        .shadow(color: NWFTStyleColors.darkColor, radius: 8, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
    }
}

struct NavigationButtonSmall: View {
    
    let title: String
    let onTapAction: () -> Void
    var body: some View {
        HStack {
          Spacer()
            Image(systemName: "arrowshape.turn.up.backward.fill")
                .foregroundColor(NWFTStyleColors.secondBackgroudColor)
                .padding(.all, 0.0)
            Text(title)
                .foregroundColor(NWFTStyleColors.secondBackgroudColor)
                .font(NWFTFonts.primaryFont(withSize: 18.0))
                .padding(.all, 0.0)
          Spacer()
        }
        .onTapGesture(perform: onTapAction)
        .padding(.all, 0.0)
    }
}
