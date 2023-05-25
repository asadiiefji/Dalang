//
//  PersonalizedWayangQuizView.swift
//  Dalang
//
//  Created by Mukhammad Miftakhul As'Adi on 21/05/23.
//


//Fitur yang ini ngga jadi, belum selesai



import SwiftUI

struct Question {
    let text: String
    let answers: [String]
    let scores: [Int]
}

struct PersonalizedWayangQuizView: View {
    let questions: [Question] = [
        Question(text: "Siapa namaku?", answers: ["asadi", "jokowi", "obama"], scores: [1, 2, 3]),
        Question(text: "Berapa umurku?", answers: ["21", "22", "23"], scores: [1, 2, 3]),
        Question(text: "Aku lahir dimana??", answers: ["Batam", "Malang", "Dampit"], scores: [1, 2, 3])
    ]
    
    @State private var currentQuestion = 0
    @State private var totalScore = 0
    @State private var score = [0, 0, 0]
    @State private var isEndQuestion = false
    @State private var showAlert = false
    @State private var answer = ["", "", ""]
    
    @State var screenWidth : CGFloat = UIScreen.main.bounds.width
    @State var screenHeight : CGFloat = UIScreen.main.bounds.height
    @State private var nextSwiped = false
    @State private var backSwiped = false
    
    var body: some View{
        NavigationStack{
            ZStack {
                Rectangle()
                    .foregroundColor(nextSwiped ? .green : .gray)
                    .frame(width: screenWidth , height: screenHeight)
                    .position(x: screenWidth/2.25 , y: screenHeight/2)
                    .gesture(DragGesture()
                        .onEnded({ value in
                            if value.translation.width > 0 {
                                backSwiped.toggle()
                                self.swipeQuestion(currentQuestion)
                            }
                            if value.translation.width < 0 {
                                nextSwiped.toggle()
                                self.swipeQuestion(currentQuestion)
                            }
                        })
                    )
                
                VStack{
                    Text (questions[currentQuestion].text)
                    
                    ForEach (0..<questions[currentQuestion].answers.count){ index in
                        
                        Button {
                            answer[currentQuestion] = questions[currentQuestion].answers[index]
                            score[currentQuestion] = questions[currentQuestion].scores[index]
                            //                        print (questions[currentQuestion].answers[index])
                            print (score)
                            print (totalScore)
                            withAnimation(Animation.linear.delay(0.4)){
                                self.checkAnswer(index)
                            }
                            print(answer)
                            
                            
                        } label: {
                            Text(questions[currentQuestion].answers[index])
                                .frame(width: screenWidth/3, height: screenHeight/8)
                                .background(Color.white)
                                .border(Color.purple, width: answer[currentQuestion] == questions[currentQuestion].answers[index] ? 4 : 0)
                        }
                    }
                    Button {
                        restartQuiz()
                    } label: {
                        Text("Restart")
                            .frame(width: screenWidth/3, height: screenHeight/8)
                            .background(Color.red)
                    }
                    
                    Button {
                        self.showAlert = true
                        self.totalScore = score.reduce(0, +)
                    } label: {
                        Text("Show Alert")
                            .frame(width: screenWidth/3, height: screenHeight/8)
                            .background(Color.yellow)
                    }
                }
                .background(Color.gray)
                .position(x: screenWidth / 2.25, y: screenHeight / 2)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Your score is"),
                        message: Text("\(totalScore)"),
                        primaryButton: .destructive(Text("Destructive"), action: {
                            //action here
                        }),
                        secondaryButton: .cancel(Text("Cancel"), action: {
                            //action here
                        })
                    )
                }
                
            }
        }
    }
    
    func swipeQuestion(_ index:Int){
        if backSwiped && currentQuestion > 0 {
            print ("sebelum swipe back \(currentQuestion)")
            currentQuestion -= 1
            backSwiped.toggle()
            print ("karena swipe back \(currentQuestion)")
        }
        
        if nextSwiped && currentQuestion < questions.count - 1 {
            print ("sebelum next back \(currentQuestion)")
            currentQuestion += 1
            nextSwiped.toggle()
            print ("karena next back \(currentQuestion)")
        }
    }
    
    func checkAnswer(_ index:Int){
        if currentQuestion < questions.count - 1 {
            currentQuestion += 1
        } else {
            isEndQuestion = true
        }
    }
    
    func restartQuiz() {
        currentQuestion = 0
        score = [0, 0, 0]
        totalScore = 0
        answer = ["", "", ""]
    }
    
}

struct PersonalizedWayangQuizView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalizedWayangQuizView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
