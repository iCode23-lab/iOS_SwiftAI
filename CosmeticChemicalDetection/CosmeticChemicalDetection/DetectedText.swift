//
//  DetectedText.swift
//  CosmeticChemicalDetection
//
//  Created by Pragatha on 7/24/21.
//

import Combine
import SwiftUI

final class DetectedText : ObservableObject, Identifiable {
    
    let willChange = PassthroughSubject<DetectedText, Never>()
    
    var value:String = "Scan document to see its content" {
        willSet {
            willChange.send(self)
        }
    }
}
