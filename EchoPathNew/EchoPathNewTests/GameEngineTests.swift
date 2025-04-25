//
//  EchoPathNewTests.swift
//  EchoPathNewTests
//
//  Created by Admin2 on 4/22/25.
//

import Testing
@testable import EchoPathNew

struct GameEngineTests {
    
    //MARK: - 5.1 Selection View
    //Test Case 1: Verify that the animal selection defaults to "Dog".
    @Test func testInitialStateIsDog() {
        let engine = GameEngine(animal: "Dog")
        #expect(engine.animal == "Dog")
    }
    
    //MARK: - 5.2 Sentence Building View
    // Test Case 1: Validate initial level, targets, hints, and word pool
        @Test func testInitialState() {
            let engine = GameEngine(animal: "Dog")

            #expect(engine.animal == "Dog")
            #expect(engine.currentLevel == 0)
            #expect(engine.currentStep == 0)
            #expect(engine.feedback == "")

            // Hints for level 0
            #expect(engine.currentHints == ["article","noun"])

            // Words pool contains exactly the sentence words
            let sentenceWords = engine.sentences[0]
            #expect(Set(engine.availableWords) == Set(sentenceWords))
        }

        // Test Case 2: Ensure availableWords always contains all sentence words (randomized)
        @Test func testWordPoolRandomizationInvariant() {
            let engine = GameEngine(animal: "Cat")
            let sentenceWords = engine.sentences[0]
            // Sorting both should match
            #expect(engine.availableWords.sorted() == sentenceWords.sorted())
        }

        // Test Case 4 & 5: Correct and incorrect placements feedback
        @Test func testFeedbackOnPlacement() {
            let engine = GameEngine(animal: "Dog")
            // Incorrect at first slot
            engine.handleDrop("dog", at: 0)
            #expect(engine.feedback == "Incorrect. Try again.")
            #expect(engine.currentStep == 0)

            // Correct placement
            engine.handleDrop("a", at: 0)
            #expect(engine.feedback == "Correct!")
            #expect(engine.currentStep == 1)
            #expect(engine.droppedWords[0] == "a")
            #expect(!engine.availableWords.contains("a"))
        }

        // Test Case 6: Completing a level and advancing
        @Test func testCompleteLevelAndAdvance() {
            let engine = GameEngine(animal: "Dog")
            let sentence = engine.sentences[0]
            // Place all words correctly
            for (i, word) in sentence.enumerated() {
                engine.handleDrop(word, at: i)
            }
            // currentStep should equal sentence length
            #expect(engine.currentStep == sentence.count)

            // Advance to next level
            engine.nextLevel()
            #expect(engine.currentLevel == 1)
            #expect(engine.currentStep == 0)
            // New hints and sentence match
            #expect(engine.currentHints == ["article","adjective","noun"])
        }

        // Test Case 7: Reset level resets state
        @Test func testResetLevel() {
            let engine = GameEngine(animal: "Mouse")
            // Simulate progress
            engine.handleDrop(engine.currentSentence[0], at: 0)
            #expect(engine.currentStep == 1)

            // Reset
            engine.resetLevel()
            #expect(engine.currentLevel == 0)
            #expect(engine.currentStep == 0)
            #expect(engine.feedback == "")
            #expect(engine.droppedWords.allSatisfy { $0 == nil })
            #expect(engine.availableWords.count == engine.currentSentence.count)
        }

        // Test Case 8: Ensure engine does nothing when advancing past last level
        @Test func testAdvancePastLastLevelNoOp() {
            let engine = GameEngine(animal: "Bird")
            // Move to final level
            engine.nextLevel(); engine.nextLevel()
            let lastLevel = engine.currentLevel
            engine.nextLevel()  // should not change
            #expect(engine.currentLevel == lastLevel)
        }
}
