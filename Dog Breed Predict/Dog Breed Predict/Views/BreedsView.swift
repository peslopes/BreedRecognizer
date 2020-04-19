//
//  BreedsView.swift
//  Dog Breed Predict
//
//  Created by Pedro Lopes on 19/04/20.
//  Copyright © 2020 Pedro Lopes. All rights reserved.
//

import SwiftUI

struct BreedsView: View {
    var breedNames: [String] = ["Teste testoso", "Xis", "agua", "bauru", "arroz"]
    var breedNamesProbs: [String: Double] = ["Teste testoso" : 0.5, "Xis" : 0.3, "agua" : 0.2, "bauru" : 0.1, "arroz": 0.2]
    var image: UIImage = UIImage()
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 15) {
                ((self.image.cgImage != nil) ? Image(decorative: self.image.cgImage!, scale: 1, orientation: self.translateImageOrientation(uiImageOrientation: self.image.imageOrientation)) : Image(uiImage: self.image))
                .resizable()
                .frame(width: geometry.size.width, height: geometry.size.height  * 0.7)
                .scaledToFill()
                .clipShape(Circle())
                .overlay(Circle()
                    .stroke(Color("panelColor"), lineWidth: 4))
                Text(self.getBreedName(breedName: self.breedNames.first))
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                ForEach(0 ..< (self.breedNames.count < 5 ? self.breedNames.count : 5)) { i in
                    HStack(alignment: .top, spacing: 50) {
                        if i < self.breedNames.count {
                            Text(self.getBreedName(breedName: self.breedNames[i]))
                                .foregroundColor(Color(white: 0.4))
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Text("\(Int(self.breedNamesProbs[self.breedNames[i]]! * 100).description) %")
                        }
                    
                    }
                    .padding(.leading)
                    .padding(.trailing, 0.15 * geometry.size.width)
                }
                Spacer()
            }
        }
    }
    
    
    func translateImageOrientation(uiImageOrientation: UIImage.Orientation) -> Image.Orientation {
        switch uiImageOrientation {

        case .up:
            return .up
        case .down:
            return .down
        case .left:
            return .left
        case .right:
            return .right
        case .upMirrored:
            return .upMirrored
        case .downMirrored:
            return .downMirrored
        case .leftMirrored:
            return .leftMirrored
        case .rightMirrored:
            return .rightMirrored
        @unknown default:
            return .up
        }
    }
    
    func getBreedName(breedName: String?) -> String {
        guard let breedName = breedName else {
            return ""
        }
        var stringToReturn = ""
        var components = breedName.components(separatedBy: " ")
        components.reverse()
        components.forEach{
            stringToReturn += "\($0) "
        }
        
        return stringToReturn.capitalized
    }
}

struct BreedsView_Previews: PreviewProvider {
    static var previews: some View {
        BreedsView()
    }
}
