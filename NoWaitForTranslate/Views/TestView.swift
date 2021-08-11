//
//  TestView.swift
//  NoWaitForTranslate
//
//  Created by Ivan Ermolaev on 10/08/2021.
//

import SwiftUI

struct TestView: View {
    @State private var animation = false
    @State var size: CGFloat = 1.0
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "mic.fill")
                .resizable()
                .foregroundColor(NWFTStyleColors.darkColor)
                .frame(width: 20, height: 28, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Text("Say a word")
                .font(NWFTFonts.secondaryFont(withSize: 20))
                .foregroundColor(NWFTStyleColors.darkColor)
        }
        .padding(.all, 20.0)
        .scaleEffect(size)
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: true)) {
                    self.size = 1.1
                }
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TestView()
        }
    }
}
