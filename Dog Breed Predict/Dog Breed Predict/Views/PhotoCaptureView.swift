//
//  PhotoCaptureView.swift
//  AgeClassifier
//
//  Created by Pedro Lopes on 18/04/20.
//  Copyright © 2020 Pedro Lopes. All rights reserved.
//

import SwiftUI

struct PhotoCaptureView: View {
    @Binding var showImagePicker    : Bool
    @Binding var image              : UIImage?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        ImagePicker(isShown: $showImagePicker, image: $image, sourceType: sourceType)
    }
}

struct PhotoCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoCaptureView(showImagePicker: .constant(false), image: .constant(UIImage(named: "")))
    }
}
