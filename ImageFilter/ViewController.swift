//
//  ViewController.swift
//  ImageFilter
//
//  Created by Jonathan Go on 2017/07/18.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensity: UISlider!
    
    var currentImage: UIImage!
    var context: CIContext!  //CoreImage component that handles rendering
    var currentFilter: CIFilter!  //will store whatever filter we activated
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adds a button to import photos from the library
        title = "InstaFilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeFilter(_ sender: UIButton) {
    }

    @IBAction func save(_ sender: UIButton) {
    }
    
    @IBAction func intensityChanged(_ sender: UISlider) {
    
        applyProcessing()
    }
    
    func importPicture() {
        
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    //method for when the user selects a picture from the imagepicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        currentImage = image  //required so we'll have a copy of what was originally imported (user changes the filter and we need to have a copy of the original)
        
        let beginImage = CIImage(image: currentImage)  //CoreImage equivalent of UIImage
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    func applyProcessing() {
        
        currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        //uses the value of the slider to set the intensity value of the CoreImage filter
        
        if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
        //creates a new data type called CGimage from the output image of the current filter. .extent means that it will apply the filter to all the image.  Until this method is called, no actual processing is done.  This returns an option cgimg so we need to unwrap it with "if let"
            
            let processedImage = UIImage(cgImage: cgimg)
            //creates a new UIImage from the CGImage
            imageView.image = processedImage
            //assigns the UIImage to the imageView
        }
    }
    
}

//coreimage is a framework and applies filters to images.

