//
//  ContentView.swift
//  CosmeticChemicalDetection
//
//  Created by Pragatha on 7/24/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var recognizedText : DetectedText = DetectedText()
  //  let ingredients:Ingredient
    
    var body: some View {
       
        VStack {
            Text(recognizedText.value)
                .lineLimit(nil)
//            List(ingredients) {
//                ingredient in
//                IngredientRow(ingredient: ingredient)
                
//            }
            Spacer()
            Button(action:{
                detectTextFromImage(recognizedText: $recognizedText.value)
            }) {
                Text("Scan Image")
            }
        }

    }
    
    func detectTextFromImage(recognizedText: Binding<String>) {
        
        let textRecognizer: TextRecognizer
        textRecognizer = TextRecognizer(recognizedText: recognizedText)
        var images = [CGImage]()
        guard let cgImage = UIImage(named: "example2")?.cgImage else { return }
        images.append(cgImage)
        textRecognizer.recognizeText(from: images)
        print("Detected text final : \(textRecognizer.recognizedText)")
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


