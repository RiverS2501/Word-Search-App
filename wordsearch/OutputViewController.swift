//
//  outputViewController.swift
//  wordsearch
//
//  Created by River Shelton on 11/13/18.
//  Copyright © 2018 River Shelton. All rights reserved.
//

import Foundation
import UIKit
import Firebase



class OutputViewController: UIViewController{
    
    
   
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let docRef = db.collection("imagedata").document(puzzletest.name!)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
        
        addTextBoxes()
        
    }
    
    func addTextBoxes(){
        for i in 0...puzzletest.size! - 1{
            for b in 0...puzzletest.size! - 1{
                createBox(toView: self.view, text: "\(i)",rowa: i, rowb: b)
            }
        }
    }
    
    func createBox(toView view: UIView, text: String? = nil, rowa: Int, rowb: Int) {
       let sizeCalc = (puzzletest.size! * -2) + 50
        //let sizeCalc = 20
        let sampleTextField =  UITextField(frame: CGRect(x: rowb * sizeCalc + 10, y: rowa * sizeCalc + 100, width: sizeCalc, height: sizeCalc))
        //    sampleTextField.placeholder = "Enter text here"
        sampleTextField.text = text
        sampleTextField.font = UIFont.systemFont(ofSize: CGFloat(sizeCalc))
        sampleTextField.borderStyle = UITextField.BorderStyle.line
        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        sampleTextField.keyboardType = UIKeyboardType.default
        sampleTextField.returnKeyType = UIReturnKeyType.done
        sampleTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
        sampleTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        sampleTextField.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        //    sampleTextField.delegate = self
        view.addSubview(sampleTextField)
    }

}
