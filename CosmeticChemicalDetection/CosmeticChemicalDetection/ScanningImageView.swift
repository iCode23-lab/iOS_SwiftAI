//
//  ScanningImageView.swift
//  CosmeticChemicalDetection
//
//  Created by Pragatha on 7/24/21.
//

import SwiftUI
import Combine
import Vision

class ScanningImageView:NSObject {
    
    var recognizedText: Binding<String>
    private let textRecognizer: TextRecognizer
    
    init(recognizedText: Binding<String>) {
        self.recognizedText = recognizedText
        textRecognizer = TextRecognizer(recognizedText: recognizedText)
    }
}
