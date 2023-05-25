//
//  OnBoardingScene.swift
//  Dalang
//
//  Created by Mukhammad Miftakhul As'Adi on 25/05/23.
//

import Foundation
import SpriteKit
import SwiftUI

class EndGameScene : SKScene {
    let charOne = SKSpriteNode(imageNamed: "bgEndGame")
    let btnStart = SKSpriteNode(imageNamed: "btnPlayAgain")
    var textButton : SKLabelNode!
    
    override func didMove(to view: SKView) {
        scene?.size = view.bounds.size
        scene?.scaleMode = .aspectFill
        physicsWorld.gravity = .zero
        
        //initialize wayang 1
        charOne.position = CGPoint(x: size.width / 2, y: size.height / 2)
        charOne.zPosition = 1
        charOne.size = CGSize(width: size.width, height: size.height)
        addChild(charOne)
        
        //initialize button
        btnStart.position = CGPoint(x: size.width / 2, y: size.height / 2 )
        btnStart.zPosition = 2
        btnStart.size = CGSize(width: 265, height: 150)
        addChild(btnStart)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
                    let location = touch.location(in: self)
                    
                    // Check if the play button is touched
                    if btnStart.contains(location) {
                        // Perform button action here
                        print("Play button tapped")
                        let reveal = SKTransition.reveal(with: .down,
                                                         duration: 1)
                        let newScene = GameScene(size: CGSize(width: size.width, height: size.height))

                        scene?.view!.presentScene(newScene,
                                                transition: reveal)
                    }
                }
    }
    
}
