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
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found")
        }
        //sets up the camera and video preview
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            
            captureSession?.addInput(input)
            
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            //makes a capture session
            captureSession?.addOutput(capturePhotoOutput!)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            //sets up and siplays the video preview
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = CGRect(x:10,y:20,width:300,height:300)
            previewView.layer.addSublayer(videoPreviewLayer!)
            //starts the session
            captureSession?.startRunning()
            
            
          
            }
        catch
    {
            print(error)
            return
        }
        
    }
    //button takes the photo
    @IBAction func takePhoto(_ sender: UIButton) {
         let capturePhotoOutput = self.capturePhotoOutput!
        let photoSettings = AVCapturePhotoSettings()
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
   
}
//processing the captured image
extension CameraViewController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        //processing the data as an image
        guard let imageData: Data = photo.fileDataRepresentation() else{
            return
        }
        guard let imager = UIImage(data:imageData) else{
            return
        }
        //changing its type to make it more easily manipulated
        let cgimage = imager.cgImage!
        //crop what the viewer sees
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

        
        // Cropping image
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let imagen: UIImage = UIImage(cgImage: imageRef, scale: imager.scale, orientation: imager.imageOrientation)
        //saves image to album
        UIImageWriteToSavedPhotosAlbum(imagen, nil, nil, nil)
        //makes image a jpeg to upload it
        let imageUploadData = imagen.jpegData(compressionQuality: 1)
        //creates a firebase storage reference
        let storageRef = Storage.storage().reference()
        
        
        //another reference
        let wordImageRef =  storageRef.child("images/" + puzzletest.name!)
        //uploads image
        let uploadTask = wordImageRef.putData(imageUploadData!)
        //creates upload observer so we can see progress
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            //displays progress as percentage
            self.progressLabel.text = String(Int(percentComplete)) + "%"
            //segues to next view when upload is complete
            if(self.progressLabel.text == "100%"){
                self.progressLabel.text = "Success!"
                self.performSegue(withIdentifier: "segueToResults", sender: self)
            }
        }

    }

}



