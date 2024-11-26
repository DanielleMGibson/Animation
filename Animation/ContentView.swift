//
//  ContentView.swift
//  Animation
//
//  Created by Student on 11/26/24.
//

import SwiftUI

struct FlagView : View{
    var flagName : String

    var body: some View{
        Image(flagName).clipShape(.capsule).shadow(radius: 5)
    }
}

struct FlagButton : View{
    let number: Int
    let correctAnswerView: Int
    @State var animationAmountView: Double = 0
    let action: (Int) -> Void
    let countries: String
    @State var opacity: Double

    var body: some View{
        Button {
            if number == correctAnswerView {

                withAnimation{
                    animationAmountView  += 360
                }
            }
            else {
                withAnimation{
                    opacity = 0.0
                }
            }
            print("number button : \(number) et idButtonClicked : correctAnswer : \(correctAnswerView)")
            action(number)

        }
        label: {
            FlagView(flagName: countries)
        }
        .opacity(opacity)
        .rotation3DEffect(.degrees(number == correctAnswerView ? animationAmountView : 0), axis:  (x: 0, y: 1, z: 0))
    }
}

struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var counterQuestion = 0
    @State private var isGameOver = false
    @State private var gameOverString = ""
    @State private var idButtonClicked = 0
    @State private var isbuttonClicked = false
    @State private var animationAmount = 0.0
    @State private var opacity = 1.0

    func flagTapped(_ number: Int) {
        counterQuestion += 1

        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong the answer was the flag n°\(correctAnswer+1)"
        }
        if counterQuestion >= 8 {
            isGameOver = true
            gameOverString = "The game is over, you did \(score) out of 8"
            return
        }
        showingScore = true
        askQuestion()
    }

    func askQuestion() {
        isbuttonClicked = false
        idButtonClicked = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }

    func restartGame() {
        score = 0
        counterQuestion = 0
        isGameOver = false
        askQuestion()
    }

    var body: some View {

        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            VStack{
                Spacer()
                Text("Guess the Flag")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of").font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer]).font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        FlagButton(number: number,
                                   correctAnswerView: correctAnswer,
                                   action: {_ in flagTapped(number)},
                                   countries: countries[number], opacity: opacity)
//                        Button {
//                            self.idButtonClicked = number
//
//                            if self.idButtonClicked == correctAnswer {
//                                self.isbuttonClicked.toggle()
//                                withAnimation{
//                                    animationAmount += 360
//                                }
//                            }
//                            print("number button : \(number) et idButtonClicked : \(self.idButtonClicked) et correctAnswer : \(correctAnswer) et isbuttonClicked : \(self.isbuttonClicked)")
//                            flagTapped(number)
//
//
//                        }
//                        label: {
//                            FlagView(flagName: countries[number])
//                        }
//                        .rotation3DEffect(.degrees(self.idButtonClicked == correctAnswer ? animationAmount : 0), axis:  (x: 0, y: 1, z: 0))
                        //.animation(.default, value: self.isbuttonClicked)

                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))

                Spacer()
                Spacer()

                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())

                Spacer()
            }
            .padding()
        }
//        .alert(scoreTitle, isPresented: $showingScore) {
//            Button("Continue", action: askQuestion)
//        } message: {
//            Text("Your score is \(score)")
//        }
        .alert("game is over", isPresented: $isGameOver) {
            Button("Continue", action: restartGame)
        } message: {
            Text(gameOverString)
        }

    }
}

#Preview {
    ContentView()
}
