//
//  ContentView.swift
//  ImageSimilarity
//
//  Created by Pragatha on 6/10/20.
//  Copyright © 2020 Pragatha. All rights reserved.
//

import SwiftUI



struct ContentView: View {
    @State private var imagePickerOpen : Bool = false
    @State private var cameraOpen : Bool = false
    @State private var firstImage : UIImage? = nil
    @State private var secondImage : UIImage? = nil
    @State private var similarity: Int = -1

    private let placeholderImage = UIImage(named: "placeholder")!

    private var cameraEnabled: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    private var selectEnabled: Bool {
        secondImage == nil
    }

    private var comparisonEnabled: Bool {
        secondImage != nil && similarity < 0
    }
    
    var body: some View {
       // Text("Hello, World!")
        
        if imagePickerOpen {
            return AnyView(ImagePickerView { result in
                self.controlReturned(image: result)
                self.imagePickerOpen = false
            })
        } else if cameraOpen {
            return AnyView(ImagePickerView(camera: true) { result in
                self.controlReturned(image: result)
                self.cameraOpen = false
            })
        } else {
            return AnyView(NavigationView {
                VStack {
                    HStack {
                        OptionalResizableImage(image: firstImage, placeholder: placeholderImage)
                        OptionalResizableImage(image: secondImage, placeholder: placeholderImage)
                    }
                    
                    Button(action: clearImages) {
                        Text("Clear Images")
                    }
                    Spacer()
                    Text("Similarity : " + "\(similarity > 0 ? String(similarity) :" ...") %").font(.title).bold()
                    Spacer()
                    
                    if comparisonEnabled {
                        Button(action: getSimilarity) {
                            ButtonLabel("Compare", background: .blue)
                        }.disabled(!comparisonEnabled)
                    } else {
                        Button(action: getSimilarity) {
                            ButtonLabel("Compare", background: .gray)
                        }.disabled(!comparisonEnabled)
                    }
                }
            .padding()
                .navigationBarTitle(Text("isDemo"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: summonImagePicker){
                    Text("Select")
                    }.disabled(!selectEnabled),
                                    trailing: Button(action: SummonCamera) {
                                        Image(systemName: "camera")
                    }.disabled(!cameraEnabled))
            })
        }
    }
    
    private func clearImages() {
        firstImage = nil
        secondImage = nil
        similarity = -1
    }
    
    private func getSimilarity() {
        print("Getting similatiry ")
        if let firstImage = firstImage, let secondImage = secondImage,
            let similarityMeasure = firstImage.similarity(to: secondImage) {
            similarity = Int(similarityMeasure)
        } else {
            similarity = 0
        }
        print("Similatiry : \(similarity)%")
    }
    
    private func controlReturned(image : UIImage?) {
        print("Image return \(image == nil ? "failure" : "Success") ...")
        if firstImage == nil {
            firstImage = image?.fixOrientation()
        } else {
            secondImage = image?.fixOrientation()
        }
    }
    
    private func summonImagePicker() {
        print("Summoning Image Picker.... ")
        imagePickerOpen = true
    }
    
    private func SummonCamera() {
        print("Summoning Camera ....")
        cameraOpen = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
