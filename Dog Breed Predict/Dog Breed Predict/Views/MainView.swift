//
//  MainView.swift
//  Dog Breed Predict
//
//  Created by Pedro Lopes on 19/04/20.
//  Copyright © 2020 Pedro Lopes. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @State private var showAlertSheet : Bool = false
    @State private var showImagePicker : Bool = false
    @State private var image : UIImage? = nil
    @State private var screenSize: CGSize? = nil
    @State private var sourceType : UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        NavigationView {
            ZStack {
                if image != nil {
                    GeometryReader { geometry in
                        self.imageLoaded.onAppear() {
                            self.screenSize = geometry.size
                        }
                    }
                } else {
                    initialButton
                }
            }
        .navigationBarTitle("Breed Recognizer")
            .actionSheet(isPresented: self.$showAlertSheet) {
                ActionSheet(title: Text("Select"), message: nil, buttons: [.default(Text("Open Gallery"), action: {
                    self.showImagePicker = true
                    self.sourceType = .photoLibrary
                }), .default(Text("Open Camera"), action: {
                    self.showImagePicker = true
                    self.sourceType = .camera
                }), .cancel()])
            }
            .sheet(isPresented: self.$showImagePicker){
                PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image, sourceType: self.sourceType)
            }
        }

    }
    
    var initialButton: some View {
        Button(action: {
            self.showAlertSheet = true
        }) {
            ZStack {
                Circle()
                    .foregroundColor(Color("panelColor"))
                Text("START")
                .font(.largeTitle)
                    .foregroundColor(Color("titleColor"))
            }
        .padding(70)
        }
    }
    
    var imageLoaded: some View {
        ZStack {
            detectImage(image: image)
            VStack {
                Rectangle()
                    .frame(width: 0, height: (screenSize != nil) ? screenSize!.height  * 0.6 : nil)
                    .foregroundColor(.clear)
                HStack {
                    Spacer()
                    Button(action: {
                        self.showAlertSheet = true
                    }) {
                        ZStack {
                            Circle().frame(width: 40, height: 40)
                                .foregroundColor(.white)
                            Image(systemName: "camera.fill")
                                .foregroundColor(Color(white: 0.4))
                        }
                    }
                }
                .padding(.trailing)
                .padding(.bottom)
                Spacer()
            }
        }
    }
    
    func detectImage(image: UIImage?) -> BreedsView?  {

        let model = DogBreedClassifier()
        var breeds: [Breed] = []
        var returnedBreeds: [String] = []
        
        guard let image = image else {
            return nil
        }
        guard let buffer = self.buffer(from: image) else {
            return nil
        }
        guard let prediction = try? model.prediction(image: buffer) else {
            return nil
        }
        
        breeds = prediction.classLabelProbs.map{
            return Breed(name: $0.key, valuePredict: $0.value)
        }
        
        breeds = breeds.sorted(by:{
            $0.valuePredict > $1.valuePredict
        })
        
        breeds = breeds.filter{
            $0.valuePredict >= 0.01
        }
        
        for i in 0 ..< (breeds.count < 5 ? breeds.count : 5 ){
            returnedBreeds.append(breeds[i].name)
        }
        
        return BreedsView(breedNames: returnedBreeds, breedNamesProbs: prediction.classLabelProbs, image: image)

    }
    
    func buffer(from image: UIImage) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }

        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)

        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

        return pixelBuffer
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
