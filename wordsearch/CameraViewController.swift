//
//  CameraViewController.swift
//  wordsearch
//
//  Created by River Shelton on 10/14/18.
//  Copyright © 2018 River Shelton. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class CameraViewController: UIViewController {
    
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet var previewView: UIView!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var image: UIImage?



    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found")
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous deivce object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object
            captureSession = AVCaptureSession()
            
            // Set the input devcie on the capture session
            captureSession?.addInput(input)
            
            // Get an instance of ACCapturePhotoOutput class
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            
            // Set the output on the capture session
            captureSession?.addOutput(capturePhotoOutput!)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the input device
            
            // Set delegate and use the default dispatch queue to execute the call back
            
            // Set the output on the capture session
            
            // Initialize a AVCaptureMetadataOutput object and set it as the input device
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
        
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            //Initialise the video preview layer and add it as a sublayer to the viewPreview view's layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = CGRect(x:10,y:20,width:300,height:300)
            previewView.layer.addSublayer(videoPreviewLayer!)
            
            //start video capture
            captureSession?.startRunning()
            
            
          
            }
        catch
    {
            //If any error occurs, simply print it out
            print(error)
            return
        }
        
    }
    @IBAction func takePhoto(_ sender: UIButton) {
         let capturePhotoOutput = self.capturePhotoOutput!
            // Get an instance of AVCapturePhotoSettings class
        let photoSettings = AVCapturePhotoSettings()
        // Call capturePhoto method by passing our photo settings and a delegate implementing AVCapturePhotoCaptureDelegate
        
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
   
}
extension CameraViewController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData: Data = photo.fileDataRepresentation() else{
            return
        }
        guard let imager = UIImage(data:imageData) else{
            return
        }
        
        let cgimage = imager.cgImage!
                
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(300)
        var cgheight: CGFloat = CGFloat(300)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let imagen: UIImage = UIImage(cgImage: imageRef, scale: imager.scale, orientation: imager.imageOrientation)
        
        UIImageWriteToSavedPhotosAlbum(imagen, nil, nil, nil)
        
        let imageUploadData = imagen.jpegData(compressionQuality: 1)
        
        let storageRef = Storage.storage().reference()
        
        
        
        let wordImageRef =  storageRef.child("images/" + puzzletest.name!)
        
       
        
        let metadata = StorageMetadata()
        
        
        
        
        metadata.contentType = "image/jpeg"
        
        let uploadTask = wordImageRef.putData(imageUploadData!, metadata: metadata)
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print(percentComplete)
            self.progressLabel.text = String(Int(percentComplete)) + "%"
    
            if(self.progressLabel.text == "100%"){
                self.progressLabel.text = "Success!"
                self.performSegue(withIdentifier: "segueToResults", sender: self)
            }
        }

    }
 
    

}



