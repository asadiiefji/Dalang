//
//  GameScene.swift
//  Dalang
//
//  Created by Mukhammad Miftakhul As'Adi on 24/05/23.
//

import Foundation
import SpriteKit
import SwiftUI
import AVFoundation

class GameScene : SKScene, SKPhysicsContactDelegate{
    
    //variable char wayang
    let charOne = SKSpriteNode(imageNamed: "charOne")
    let charTwo = SKSpriteNode(imageNamed: "charTwo")
    
    //variable haptic
    var hapticGenerator: UIImpactFeedbackGenerator!
    
    //variable text
    var script : SKLabelNode!
    let scriptArray = ["selamat datang teman teman", "nama saya bima", "aku adalah pahlawan terkuat", "otot kawat tulang besi", "eh itu gatotkaca ya"]
    var currentIndex = 0
    var textHold : SKLabelNode!
    var textSpeak : SKLabelNode!
    var textWrong : SKLabelNode!
    var scriptWrong : SKLabelNode!
    
    //variable for action correct/incorrect speech
    let bgCorrectTop = SKSpriteNode(imageNamed: "bgCorrectTop")
    let bgCorrectBottom = SKSpriteNode(imageNamed: "bgCorrectBottom")
    
    //variable for speechrecognizer
    var speechRecognizer = SpeechRecognizer()
    var isRecording = false
    var isNavigate = false
    //    var isCorrect = false
    
    override func didMove(to view: SKView) {
        //initialize screen
        scene?.size = view.bounds.size
        scene?.scaleMode = .aspectFill
        physicsWorld.gravity = .zero
        
        //initialize haptic
        hapticGenerator = UIImpactFeedbackGenerator(style: .medium)
        hapticGenerator.prepare()
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        //initialize background
        moveBackGrounds(image: "bgDalangBottom0", y: 0, z: -1, duration: 12, size: CGSize(width: size.width, height: size.height))
        moveBackGrounds(image: "bgDalangBottom1", y: 0, z: 6, duration: 8, size: CGSize(width: size.width, height: size.height))
        moveBackGrounds(image: "bgDalangBottom2", y: 0, z: 1, duration: 5, size: CGSize(width: size.width, height: size.height))
        moveBackGrounds(image: "bgDalangBottom3", y: 0, z: 2, duration: 7, size: CGSize(width: size.width, height: size.height))
        moveBackGrounds(image: "bgDalangBottom4", y: 0, z: 3, duration: 6, size: CGSize(width: size.width, height: size.height))
        
        //initialize wayang 1
        charOne.position = CGPoint(x: size.width - 150, y: size.height * 0.5)
        charOne.zPosition = 5
        charOne.size = CGSize(width: 200, height: 155)
        charOne.physicsBody = SKPhysicsBody(rectangleOf: charOne.size)
        charOne.physicsBody?.friction = 0
        charOne.physicsBody?.restitution = 1
        charOne.physicsBody?.linearDamping = 0
        charOne.physicsBody?.angularDamping = 0
        charOne.physicsBody?.allowsRotation = true
        charOne.physicsBody?.isDynamic = false
        addChild(charOne)
        
        //initialize wayang 2
        charTwo.position = CGPoint(x: 150, y: size.height/2.5)
        charTwo.zPosition = 5
        charTwo.size = CGSize(width: 200, height: 150)
        charTwo.physicsBody = SKPhysicsBody(rectangleOf: charOne.size)
        charTwo.physicsBody?.friction = 0
        charTwo.physicsBody?.restitution = 1
        charTwo.physicsBody?.linearDamping = 0
        charTwo.physicsBody?.angularDamping = 0
        charTwo.physicsBody?.allowsRotation = true
        charTwo.physicsBody?.isDynamic = false
        addChild(charTwo)
        
        //initialize text when screen is on hold
        textHold = SKLabelNode(text: "Tahan, dan beri jeda usai berbicara")
        textHold.fontColor = UIColor(named: "colorPrimary")
        textHold.position = CGPoint(x: size.width/2, y: size.height - 50)
        textHold.fontName = "Helvetica"
        textHold.fontSize = 24
        
        //initialize text direction to speak
        textSpeak = SKLabelNode(text: "Tekan layar lalu ucapkan ini ya")
        textSpeak.fontName = "Helvetica"
        textSpeak.fontColor = UIColor(named: "colorSecondary")
        textSpeak.position = CGPoint(x: size.width/2, y: 65)
        //        textSpeak.scene?.backgroundColor = UIColor(named: "colorTertiary")!
        textSpeak.fontSize = 16
        textSpeak.zPosition = 100
        addChild(textSpeak)
        
        //initialize text for script to say
        script = SKLabelNode(fontNamed: "Helvetica-Bold")
        script.fontSize = 24
        script.position = CGPoint(x: size.width/2, y: 30)
        script.zPosition = 100
        script.fontColor = UIColor(named: "colorSecondary")
        addChild(script)
        updateScript()
        
        //initialize text when user say wrong's script
        textWrong = SKLabelNode(text: "Ucapanmu belum sesuai script dibawah ")
        textWrong.fontColor = UIColor(named: "colorQuaternary")
        textWrong.position = CGPoint(x: size.width/2, y: size.height - 35)
        textWrong.fontName = "Helvetica"
        textWrong.fontSize = 16
        textWrong.alpha = 0.0
        addChild(textWrong)
        
        //initialize text of the user have said
        scriptWrong = SKLabelNode(fontNamed: "Helvetica")
        scriptWrong.fontColor = UIColor(named: "colorPrimary")
        scriptWrong.position = CGPoint(x: size.width/2, y: size.height - 60)
        scriptWrong.fontName = "Helvetica-Bold"
        scriptWrong.fontSize = 24
        scriptWrong.alpha = 0.0
        addChild(scriptWrong)
        
        //initialize image for correct script
        bgCorrectTop.position = CGPoint(x: size.width/2, y: size.height/2)
        bgCorrectTop.zPosition = 101
        bgCorrectTop.setScale(1)
        bgCorrectTop.alpha = 0.0 // to hide first
        addChild(bgCorrectTop)
        
        bgCorrectBottom.position = CGPoint(x: size.width/2, y: size.height/2)
        bgCorrectBottom.zPosition = 101
        bgCorrectBottom.setScale(1)
        bgCorrectBottom.alpha = 0.0
        addChild(bgCorrectBottom)
        
        //initialize boundaries screen
        let frame = SKPhysicsBody(edgeLoopFrom: self.frame)
        frame.friction = 0
        self.physicsBody = frame
        
        
    }//end of didMove
    
    //function to create infinite background
    func moveBackGrounds(image: String, y: CGFloat, z: CGFloat, duration: Double, size: CGSize) {
        for i in 0...1 {
            //initialize image
            let node = SKSpriteNode(imageNamed: image)
            
            node.anchorPoint = .zero
            node.position = CGPoint(x: size.width * CGFloat(i), y: y)
            node.size = size
            node.zPosition = z
            
            //initialize animation
            let move = SKAction.moveBy(x: -node.size.width, y: 0, duration: duration)
            let wrap = SKAction.moveBy(x: node.size.width, y: 0, duration: 0)
            let sequence = SKAction.sequence([move, wrap])
            let immer = SKAction.repeatForever(sequence)
            node.run(immer)
            addChild(node)
        }
    }//end of moveBackground
    
    //function to update script index when user say it correctly
    func updateScript() {
        if currentIndex <= scriptArray.count - 1 {
            script.text = scriptArray[currentIndex].lowercased()
        }
    }
    
    //funtion on first touch screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //call haptic
        hapticGenerator.impactOccurred()
        
        //animate action after user speak to gone
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        bgCorrectTop.run(fadeOut)
        bgCorrectBottom.run(fadeOut)
        scriptWrong.run(fadeOut)
        textWrong.run(fadeOut)
        
        //call text to let user know screen is on the first touch
        addChild(textHold)
        print("start")
        
        //call the record speechRecognizer and start transcribe
        if !isRecording {
            speechRecognizer.transcribe()
        }
        isRecording = true
        
    }//end of touchesBegan
    
    //funtion on touch ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //call haptic
        hapticGenerator.impactOccurred()
        
        //remove text on hold screen
        textHold.removeFromParent()
        print("ended")
        
        //stop transcribe of speech recognizer
        isRecording = false
        speechRecognizer.stopTranscribing()
        print(speechRecognizer.transcript.lowercased())
        
        
        
        //check the transcript of what user have said
        if speechRecognizer.transcript.lowercased() == scriptArray[currentIndex].lowercased().replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "") {
            
            //call image to let user know they are right
            let fadeIn = SKAction.fadeIn(withDuration: 0.3)
            bgCorrectTop.run(fadeIn)
            bgCorrectBottom.run(fadeIn)
            
            // Increment the current index and wrap around if needed
            //            currentIndex = (currentIndex + 1) % scriptArray.count
            currentIndex += 1
            
            // Update the script with the new value
            updateScript()
        } else {
            //let user know what they have said
            scriptWrong.text = speechRecognizer.transcript.lowercased()
            let fadeIn = SKAction.fadeIn(withDuration: 0.2)
            textWrong.run(fadeIn)
            scriptWrong.run(fadeIn)
            //call the music background again
            
        }
        if currentIndex == scriptArray.count  {
            isNavigate = true
            
            let reveal = SKTransition.reveal(with: .down,
                                             duration: 1)
            let newScene = EndGameScene(size: CGSize(width: size.width, height: size.height))

            scene?.view!.presentScene(newScene,
                                    transition: reveal)
        }
        print(currentIndex)
        print("isNavigate, \(isNavigate)")
        
        //eliminate the script in screen
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.scriptWrong.run(fadeOut)
            self.textWrong.run(fadeOut)
        }
    }//end of touchesEnded
    
    //function on drag gesture
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            //initialize location
            let loc = touch.location(in: self)
            if let scene = scene{
                
                //check on the right or left screen
                if loc.x > (scene.size.width / 2){
                    //set wayang 1 location
                    charOne.position = loc
                }
                //                else
                if loc.x < (scene.size.width / 2)
                {
                    
                    //set wayang 2 location
                    charTwo.position = loc
                }
            }
        }
    }//end of touchesMoved
}
