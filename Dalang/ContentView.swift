//
//  ContentView.swift
//  Dalang
//
//  Created by Mukhammad Miftakhul As'Adi on 16/05/23.
//

import SwiftUI
import SpriteKit
import AVFoundation


struct ContentView: View {
    
    var scene = GameScene()
    

    @State var screenWidth : CGFloat = UIScreen.main.bounds.width
    @State var screenHeight : CGFloat = UIScreen.main.bounds.height
        
    var body: some View {
        NavigationStack {
            
            ZStack {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
                    
            }
            
        }//Navigation Stack
        .navigationBarBackButtonHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
