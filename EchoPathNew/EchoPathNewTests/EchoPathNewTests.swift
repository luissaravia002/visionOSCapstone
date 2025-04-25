//
//  EchoPathNewTests.swift
//  EchoPathNewTests
//
//  Created by Admin2 on 4/22/25.
//

import Testing
@testable import EchoPathNew

struct EchoPathNewTests {

    @Test
    func testInitialState() {
        let engine = GameEngine(animal: "Dog")

        #expect(engine.currentLevel == 0)
        #expect(engine.currentStep == 0)
        #expect(engine.feedback == "")

        #expect(engine.droppedWords.count == engine.currentSentence.count)
        let expectedSet = Set(engine.sentences[0])
        let availableSet = Set(engine.availableWords)
        #expect(availableSet == expectedSet)
    }

    @Test
    func testHandleDropCorrectAndIncorrect() {
        let engine = GameEngine(animal: "Dog")

        // wrong drop at slot 0
        engine.handleDrop("dog", at: 0)
        #expect(engine.feedback == "Incorrect. Try again.")
        #expect(engine.currentStep == 0)

        // correct drop at slot 0
        engine.handleDrop("a", at: 0)
        #expect(engine.feedback == "Correct!")
        #expect(engine.currentStep == 1)
        #expect(engine.droppedWords[0] == "a")
        #expect(!engine.availableWords.contains("a"))

        // correct drop at slot 1
        engine.handleDrop("dog", at: 1)
        #expect(engine.feedback == "Correct!")
        #expect(engine.currentStep == 2)
    }

    @Test
    func testResetLevel() {
        let engine = GameEngine(animal: "Cat")

        engine.handleDrop("a", at: 0)
        engine.handleDrop("cat", at: 1)
        #expect(engine.currentStep == 2)
        #expect(engine.feedback == "Correct!")

        engine.resetLevel()
        #expect(engine.currentLevel == 0)
        #expect(engine.currentStep == 0)
        #expect(engine.feedback == "")
        #expect(engine.droppedWords.allSatisfy { $0 == nil })
        #expect(engine.availableWords.count == engine.droppedWords.count)
    }

    @Test
    func testNextLevelAdvances() {
        let engine = GameEngine(animal: "Mouse")
        #expect(engine.currentLevel == 0)

        engine.nextLevel()
        #expect(engine.currentLevel == 1)
        #expect(engine.currentStep == 0)
        #expect(engine.droppedWords.count == engine.sentences[1].count)

        let secondSet = Set(engine.availableWords)
        let expectedSecond = Set(engine.sentences[1])
        #expect(secondSet == expectedSecond)
    }
}
