//
//  OnBoardingView.swift
//  Dalang
//
//  Created by Mukhammad Miftakhul As'Adi on 19/05/23.
//

import SwiftUI

struct OnBoardingView: View {
    @State private var isNavigate : Bool = false
    
    @State var screenWidth : CGFloat = UIScreen.main.bounds.width
    @State var screenHeight : CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack{
            VStack {
                Spacer()
                Spacer()
                Spacer()
                Button {
//                    playMusic(sound: "mscInstrument", type: "mp3")
                    isNavigate.toggle()
                } label: {
                    Text("Try Dalang")
                        .padding(12)
                        .font(.system(size: 24, weight: .bold))
                        .background(Color("colorSecondary"))
                        .foregroundColor(Color("colorPrimary"))
                        .cornerRadius(10)
                }
                Spacer()
            }
            
            .frame(width: screenWidth, height: screenHeight)
            .background(Image("bgOnBoarding0").resizable().ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $isNavigate) {
                ContentView()
            }
            .onAppear{
                print("bisa yuk")
                playMusic(sound: "mscInstrument", type: "mp3")
            }
        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView().previewInterfaceOrientation(.landscapeLeft)
    }
}
