//
//  GameView.swift
//  EchoPathNew
//
//  Created by Admin2  on 4/22/25.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import RealityKit
import RealityKitContent

struct GameView: View {
    let animal: String
    
    var sentences: [[String]] {
        [
            ["a", animal.lowercased()],
            ["a", "small", animal.lowercased()],
            ["a", "small", "brown", animal.lowercased()]
        ]
    }
    
    var hints: [[String]] {
        [
            ["article", "noun"],
            ["article", "adjective", "noun"],
            ["article", "adjective", "adjective", "noun"]
        ]
    }
    
    @State private var currentLevel: Int = 0
    
    var currentSentence: [String] { sentences[currentLevel] }
    var currentHints: [String] { hints[currentLevel] }
    
    @State private var droppedWords: [String?]
    @State private var availableWords: [String]
    @State private var selectedWord: String? = nil
    @State private var currentStep: Int = 0
    @State private var feedback: String = ""
    
    init(animal: String) {
        self.animal = animal
        let initialSentence = ["a", animal.lowercased()]
        _droppedWords = State(initialValue: Array(repeating: nil, count: initialSentence.count))
        _availableWords = State(initialValue: initialSentence.shuffled())
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Build the sentence word by word!")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            Text("Level \(currentLevel + 1)")
                .font(.headline)
            
            HStack(spacing: 8) {
                ForEach(0..<currentSentence.count, id: \.self) { index in
                    SelectableDropTargetView(word: $droppedWords[index],
                                             hint: currentHints[index])
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(index == currentStep ? Color.blue : Color.clear, lineWidth: 2)
                        )
                        .onTapGesture {
                            if index == currentStep, let selected = selectedWord {
                                if selected == currentSentence[currentStep] {
                                    droppedWords[currentStep] = selected
                                    if let removalIndex = availableWords.firstIndex(of: selected) {
                                        availableWords.remove(at: removalIndex)
                                    }
                                    feedback = "Correct!"
                                    currentStep += 1
                                } else {
                                    feedback = "Incorrect. Try again."
                                }
                                selectedWord = nil
                            }
                        }
                }
            }
            
            Text(feedback)
                .font(.title2)
                .foregroundColor(feedback == "Correct!" ? .green : .red)

            HStack(spacing: 6) {
                ForEach(availableWords, id: \.self) { word in
                    Button(action: {
                        selectedWord = word
                    }) {
                        Text(word)
                            .font(.title2)
                            .padding()
                            .cornerRadius(8)
                    }
                }
            }
            
            if currentStep == currentSentence.count {
                Button("Next Level") {
                    if currentLevel < sentences.count - 1 {
                        currentLevel += 1
                        resetLevel()
                    } else {
                        feedback = "Congratulations! You completed all levels."
                    }
                }
                .padding()
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            // Reset button for the current level.
            Button("Reset Level") {
                resetLevel()
            }
            .padding()
            .foregroundColor(.red)
            .cornerRadius(10)
            
            NavigationStack {
                NavigationLink("Go to Test View") {
                    TestView()
                }
                .foregroundColor(.cyan)
                .cornerRadius(10)
            }
            .background(.clear)
        }
        .padding()
        .navigationTitle("Sentence Builder")
    }
    
    /// Resets the drop targets and available words for the current level.
    func resetLevel() {
        droppedWords = Array(repeating: nil, count: currentSentence.count)
        availableWords = currentSentence.shuffled()
        selectedWord = nil
        currentStep = 0
        feedback = ""
    }
}

// MARK: - Selectable Drop Target View
struct SelectableDropTargetView: View {
    @Binding var word: String?
    let hint: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray, lineWidth: 2)
            .frame(width: 80, height: 40)
            .overlay(
                Text(word ?? hint)
                    .foregroundColor(word == nil ? .gray : .black)
            )
    }
}

#Preview {
    GameView(animal: "Dog")
}

