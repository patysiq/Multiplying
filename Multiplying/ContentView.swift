//
//  ContentView.swift
//  Multiplying
//
//  Created by PATRICIA S SIQUEIRA on 22/01/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var table = 1
    @State private var tipTables = [1,2,3,4,5,6,7,8,9,10,11,12]
    @State private var question = 0
    @State private var tipQuestions = ["5", "10", "20", "All"]
    @State private var difficulty = 0
    @State private var tipDifficulty = ["Easy", "Medium", "Hard"]
    @State private var correctAnswer = ""
    
    
    var converterDifficulty: Int {
        switch tipDifficulty[difficulty] {
        case "Easy":
            return Int.random(in: 1..<5)
        case "Medium":
            return Int.random(in: 5..<8)
        case "Hard":
            return Int.random(in: 8..<13)
        default:
            fatalError("Error read difficulty")
        }

    }
    
    var converterTable: Int {
        table + 1
    }
    
    var numberOfQuestions: Int {
        if tipQuestions[question] == "All" {
            return 100
        } else {
            return Int(tipQuestions[question]) ?? 5
        }
    }
    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(UIColor.init(red: 210/255, green: 246/255, blue: 252/255, alpha: 1.0))
                    .edgesIgnoringSafeArea(.all)
                VStack {
                Form{
                    Section (header: Text("What is the level of difficulty?")) {
                        Picker("Sellect the difficulty:  \(difficulty)", selection: $difficulty) {
                            ForEach(0 ..< tipDifficulty.count) {
                                Text("\(self.tipDifficulty[$0])")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    VStack(spacing: 25) {
                            Section (header: Text("Which multiplication table are we going to study?")) {
                                Picker("Multiply", selection: $table) {
                                    ForEach(0 ..< tipTables.count) {
                                        Text("\(self.tipTables[$0])")
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            
                            Section (header: Text("What questions are we going to play with?")) {
                                Picker("Questions", selection: $question) {
                                    ForEach(0 ..< tipQuestions.count) {
                                        Text("\(self.tipQuestions[$0])")
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                    }
                    Section{
                        NavigationLink(destination: Calculate(numberQuestions: numberOfQuestions, numberTable: converterTable, number: converterDifficulty)) {
                            Text("Start Game")
                                .foregroundColor(.blue)
                        }
                        
                    }
                    
                }
            }
            }
            .navigationBarTitle("Multiplying")
        }
    }
}

struct Calculate: View {
    @State private var answer = ""
    @State private var score = 0
    @State private var scoreTitle = ""
    @State private var titleQuestions = ""
    @State private var showingScore = false
    var numberQuestions: Int
    var numberTable: Int
    @State var number: Int
    @State private var times = 0
    
    var convertAnswer: Int {
        Int(answer) ?? 1
    }
    
    var body: some View {
        NavigationView {
        ZStack{
            Color(UIColor.init(red: 210/255, green: 246/255, blue: 252/255, alpha: 1.0))
                .edgesIgnoringSafeArea(.all)
            VStack(spacing : 0){
                Spacer()
                Text("Seu score:  \(score)")
                    .foregroundColor(.black)
                    .font(.title)
                Form{
                    Section{
                        Text(getQuestion(numberTable, number))
                            .bold()
                    }
                    Section {
                        TextField("Your Answer", text: $answer).keyboardType(.numberPad)
                    }
                    Section {
                        Button("Calculate") {
                            scoreCard(calculate(numberTable, number))
                        }
                        .frame(width: 350, height: 35, alignment: .center)
                        .animation(.default)
                        .foregroundColor(.blue)
                    }
                }
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                askAgain()
                if times > numberQuestions {
                    GameOver(score: score)
                }
            })
        }
        }
        .navigationBarTitle("Quiz")
    }
    
    func calculate(_ numberTable:Int,_ number: Int) -> Int {
           numberTable * number
    }
    
    func scoreCard(_ result: Int) {
        if result == convertAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
        }
        showingScore = true
    }
    
    func getQuestion(_ table: Int,_ number: Int) -> String {
        "How much is \(table) x \(number) ?"
    }
    
    func askAgain(){
        switch number{
        case 1..<5:
            number = Int.random(in: 1..<5)
        case 5..<8:
            number =  Int.random(in: 5..<8)
        case 8..<13:
            number =  Int.random(in: 8..<13)
        default:
            fatalError("Error read difficulty")
        }
        
        answer = ""
        
        if times >= numberQuestions {
            scoreTitle = "Finish the game."
            times = 0
        } else {
            times += 1
        }
    }
    
}



struct GameOver: View {
    var score = 0
    
    var body: some View {
        ZStack{
            Color(UIColor.init(red: 210/255, green: 246/255, blue: 252/255, alpha: 1.0))
                .edgesIgnoringSafeArea(.all)
            Text("Game Over")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.white)
            Text("Your score is \(score).")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.white)
            NavigationLink(destination: ContentView()) {
                Text("Start Game")
                    .foregroundColor(.blue)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
