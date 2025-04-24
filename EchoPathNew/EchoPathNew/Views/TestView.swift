//
//  TestView.swift
//  EchoPathNew
//
//  Created by Admin2  on 4/23/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct TestView: View {
    @State private var parent = ModelEntity()
    
    var body: some View {
        RealityView { content in
            let boxMesh = MeshResource.generateBox(size: [0.12, 0.06, 0.01])
            let material = SimpleMaterial(color: .cyan, isMetallic: false)
            let box = ModelEntity(mesh: boxMesh, materials: [material])
            box.components.set(InputTargetComponent(allowedInputTypes: .indirect))
            box.generateCollisionShapes(recursive: true)
            
            let textMesh = MeshResource.generateText("Test", extrusionDepth: 0.002, font: .systemFont(ofSize: 0.05))
            let textMaterial = SimpleMaterial(color: .white, isMetallic: false)
            let textEntity = ModelEntity(mesh: textMesh, materials: [textMaterial])
            let bounds = textEntity.visualBounds(relativeTo: nil)
            textEntity.position = SIMD3(-bounds.center.x, -bounds.center.y, 0.006)

            parent.name = "Test"
            parent.addChild(box)
            parent.addChild(textEntity)
            parent.generateCollisionShapes(recursive: true)
            parent.components.set(InputTargetComponent(allowedInputTypes: .indirect))
            
            content.add(parent)
        }
        .gesture(
            DragGesture()
                .targetedToEntity(parent)
                .onChanged({ value in
                    parent.position = value.convert(value.location3D, from: .local, to: parent.parent!)
            })
        )
    }
}

#Preview {
    TestView()
}
