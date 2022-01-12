//
//  TextRecognizer.swift
//  CosmeticChemicalDetection
//
//  Created by Pragatha on 7/24/21.
//

import SwiftUI
import Vision
import Combine

public struct TextRecognizer {
    
    @Binding var recognizedText: String
    
    //What this is doing????
    private let textRecognitionWorkQueue = DispatchQueue(label: "TextRecognitionQueue",qos: .userInitiated, attributes:[], autoreleaseFrequency:.workItem)
    
    func recognizeText(from images: [CGImage]) {
        
        self.recognizedText = ""
        var temp = ""
        
        let textRecognitionRequest = VNRecognizeTextRequest {(request, error) in
            guard let observations = (request.results as? [VNRecognizedTextObservation]) else {
                print("The observations are of an unexpected type. \(error.debugDescription)")
                return
            }
            
            // Concatenate the recognised text from all the observations.
            let maximumCandidates = 1
            for observation in observations {
                guard let candidate = observation.topCandidates(maximumCandidates).first else {
                    continue
                }
                print("Scanned Text : \(candidate.string)")
                temp += candidate.string + "\n"
            }
        }
        
        textRecognitionRequest.recognitionLevel = .accurate
               for image in images {
                   let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
                   
                   do {
                       try requestHandler.perform([textRecognitionRequest])
                   } catch {
                       print(error)
                   }
                   temp += "\n\n"
               }
               self.recognizedText = temp
    
    }
    
}
