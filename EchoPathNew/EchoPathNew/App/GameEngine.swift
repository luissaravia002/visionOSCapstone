//
//  GameEngine.swift
//  EchoPathNew
//
//  Created by Jose Blanco on 4/24/25.
//

// MARK: - GameEngine.swift
import SwiftUI

/// A pure game engine with observable state using the @Observable macro
@Observable
class GameEngine {
    let animal: String

    // MARK: - Data
    let sentences: [[String]]
    let hints: [[String]]

    // MARK: - State (all published automatically)
    var currentLevel: Int
    var droppedWords: [String?]
    var availableWords: [String]
    var currentStep: Int
    var feedback: String

    // Convenience
    var currentSentence: [String] { sentences[currentLevel] }
    var currentHints: [String] { hints[currentLevel] }

    // MARK: - Initialization
    init(animal: String) {
        self.animal = animal
        self.sentences = [
            ["a", animal.lowercased()],
            ["a", "small", animal.lowercased()],
            ["a", "small", "brown", animal.lowercased()]
        ]
        self.hints = [
            ["article", "noun"],
            ["article", "adjective", "noun"],
            ["article", "adjective", "adjective", "noun"]
        ]
        // start at level 0
        self.currentLevel = 0
        let initial = sentences[0]
        self.droppedWords = Array(repeating: nil, count: initial.count)
        self.availableWords = initial.shuffled()
        self.currentStep = 0
        self.feedback = ""
    }

    // MARK: - Game Logic
    /// Handles a dropped (or selected) word into the given slot index
    func handleDrop(_ word: String, at index: Int) {
        guard index == currentStep else { return }
        if word == currentSentence[index] {
            droppedWords[index] = word
            availableWords.removeAll { $0 == word }
            feedback = "Correct!"
            currentStep += 1
        } else {
            feedback = "Incorrect. Try again."
        }
    }

    /// Advance to the next level (if any)
    func nextLevel() {
        guard currentLevel < sentences.count - 1 else { return }
        currentLevel += 1
        resetLevel()
    }

    /// Reset the current level state
    func resetLevel() {
        droppedWords = Array(repeating: nil, count: currentSentence.count)
        availableWords = currentSentence.shuffled()
        currentStep = 0
        feedback = ""
    }
}
