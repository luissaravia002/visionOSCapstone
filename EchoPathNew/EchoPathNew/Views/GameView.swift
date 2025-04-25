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

import SwiftUI
import RealityKitContent

struct GameView: View {
    @State private var engine: GameEngine
    // no more selectedWord since drag carries the word directly

    init(animal: String) {
        _engine = State(wrappedValue: GameEngine(animal: animal))
    }

    var body: some View {
        VStack(spacing: 30) {
            Text("Build the sentence word by word!")
                .font(.largeTitle)
                .multilineTextAlignment(.center)

            Text("Level \(engine.currentLevel + 1)")
                .font(.headline)

            // 1) Slots as drop destinations
            HStack(spacing: 8) {
                ForEach(0..<engine.currentSentence.count, id: \.self) { index in
                    SelectableDropTargetView(
                        word: $engine.droppedWords[index],
                        hint: engine.currentHints[index]
                    )
                    .frame(width: 100, height: 50)
                    .dropDestination(for: String.self) { items, _ in
                        guard let dropped = items.first,
                              index == engine.currentStep
                        else { return false }
                        engine.handleDrop(dropped, at: index)
                        return true
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                index == engine.currentStep
                                    ? Color.blue
                                    : Color.gray.opacity(0.3),
                                lineWidth: 2
                            )
                    )
                }
            }

            // 2) Feedback
            Text(engine.feedback)
                .font(.title2)
                .foregroundColor(engine.feedback == "Correct!" ? .green : .red)

            // 3) Word bank with draggable tokens
            HStack(spacing: 12) {
                ForEach(engine.availableWords, id: \.self) { word in
                    Text(word)
                        .font(.title2)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .draggable(word)
                }
            }

            // 4) Controls
            if engine.currentStep == engine.currentSentence.count {
                Button("Next Level") {
                    engine.nextLevel()
                }
                .buttonStyle(.borderedProminent)
            }

            Button("Reset Level", role: .destructive) {
                engine.resetLevel()
            }
        }
        .padding()
        .navigationTitle("Sentence Builder")
    }
}

// MARK: - Drop Target View
struct SelectableDropTargetView: View {
    @Binding var word: String?
    let hint: String

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray, lineWidth: 2)
            .overlay(
                Text(word ?? hint)
                    .foregroundColor(word == nil ? .gray : .black)
            )
    }
}

#Preview {
    GameView(animal: "Dog")
}

