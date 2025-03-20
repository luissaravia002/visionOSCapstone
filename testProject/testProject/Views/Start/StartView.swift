//
//  StartView.swift
//  testProject
//
//  Created by Luis Saravia on 3/17/25.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

// MARK: - Animal Selection View
struct AnimalSelectionView: View {
    @State private var selectedAnimal: String = "Dog"
    let animals = ["dog", "cat", "lion"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Choose Your Favorite Animal")
                    .font(.largeTitle)
                    .padding()
                
                Picker("Animal", selection: $selectedAnimal) {
                    ForEach(animals, id: \.self) { animal in
                        Text(animal)
                            .font(.title) // Larger text in picker
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .frame(height: 60) // Increased picker height
                
                NavigationLink(destination: AnimalSentenceBuildingView(animal: selectedAnimal)) {
                    Text("Continue")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color.gray.opacity(0.2)) // Entire view now has a gray background
            .ignoresSafeArea() // Extend background to screen edges
            .navigationTitle("Animal Selection")
        }
    }
}

// MARK: - Animal Sentence Building View
struct AnimalSentenceBuildingView: View {
    let animal: String
    
    // Compute the target sentences based on the chosen animal.
    var sentences: [[String]] {
        [
            ["a", animal.lowercased()],
            ["a", "small", animal.lowercased()],
            ["a", "small", "brown", animal.lowercased()]
        ]
    }
    
    // Hints remain the same for each level.
    var hints: [[String]] {
        [
            ["article", "noun"],
            ["article", "adjective", "noun"],
            ["article", "adjective", "adjective", "noun"]
        ]
    }
    
    // Track the current level.
    @State private var currentLevel: Int = 0
    
    // Convenience: The target sentence and hints for the current level.
    var currentSentence: [String] { sentences[currentLevel] }
    var currentHints: [String] { hints[currentLevel] }
    
    // Drop target slots for each word.
    @State private var droppedWords: [String?]
    // Pool of available words (shuffled each level).
    @State private var availableWords: [String]
    // Currently selected word from the pool.
    @State private var selectedWord: String? = nil
    // The index of the next slot to fill.
    @State private var currentStep: Int = 0
    // Feedback message.
    @State private var feedback: String = ""
    
    // Initializer sets initial values using level 1 sentence.
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
            
            // Display drop target boxes with hints.
            HStack(spacing: 8) {
                ForEach(0..<currentSentence.count, id: \.self) { index in
                    SelectableDropTargetView(word: $droppedWords[index],
                                             hint: currentHints[index])
                        // Highlight only the active (first empty) slot.
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(index == currentStep ? Color.blue : Color.clear, lineWidth: 2)
                        )
                        .onTapGesture {
                            // Allow placement only on the active slot.
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
            
            // Display available words as buttons.
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
            
            // If the sentence is complete, show a Next Level button.
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
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            // Reset button for the current level.
            Button("Reset Level") {
                resetLevel()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
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
    AnimalSelectionView()
}
