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



class OutputViewController: UIViewController, UITextFieldDelegate{
    
    
   //gets instance of firestore
    let db = Firestore.firestore()
    var textFields = [UITextField]()
    var newarray: [Character] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //programatically creates button
        let button = UIButton(frame: CGRect(x: 112, y: 485, width: 97, height: 63))
        button.backgroundColor = .black
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(button)
        
        self.hideKeyboardWhenTappedAround()
        
        //creates databse listener to look for results of vision call
        db.collection("imagedata").document(puzzletest.name!).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else{
                print("error")
                return
            }
            //no results
            guard let data = document.data() else{
                print("empty")
                return
            }
            
            //goes here once it gets the results
            
            //turns results into a string
            let stringy = data["text"] as! String
            
            //parses results and removes spaces and new lines
            let stringy2 = String(stringy.filter { !" \n".contains($0) })
            
            //adds characters to an array
            let characters = Array(stringy2)
            
            //calls fixArray function
            self.newarray = self.fixArray(char: characters)
            
            //creates text boxes and populates them with the characters
            self.addTextBoxes(ar: self.newarray)
            
            //sets the character array equal to the puzzle object
            puzzletest.setPuzzline(ar: self.newarray)
            
        }
        
        
    }
    //function helps fix the array by making sure it doesnt contain numbers
    func fixArray(char: [Character]) -> [Character]{
        var newarray: [Character] = []
        for x in char{
            if x == "0"{
                newarray.append("O")
        } else{
                newarray.append(x)
            }
        }
        return newarray
    }
    //creates all the text boxes with the characters
    func addTextBoxes(ar: [Character]){
        var count = 0
        for i in 0...puzzletest.size! - 1{
            for b in 0...puzzletest.size! - 1{
                createBox(toView: self.view, text: String(ar[count]) ,rowa: i, rowb: b)
                count+=1
            }
        }
    }
    //function to make the indiviudal boxes with calculations to make sure they are positioned correctly
    func createBox(toView view: UIView, text: String? = nil, rowa: Int, rowb: Int) {
       let sizeCalc = (puzzletest.size! * -2) + 50
        let sampleTextField =  UITextField(frame: CGRect(x: rowb * sizeCalc + 10, y: rowa * sizeCalc + 100, width: sizeCalc, height: sizeCalc))
        sampleTextField.text = text
        sampleTextField.font = UIFont.systemFont(ofSize: CGFloat(sizeCalc))
        sampleTextField.borderStyle = UITextField.BorderStyle.line
        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        sampleTextField.keyboardType = UIKeyboardType.default
        sampleTextField.returnKeyType = UIReturnKeyType.done
        sampleTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
        sampleTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        sampleTextField.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        sampleTextField.delegate = self
        view.addSubview(sampleTextField)
        textFields.append(sampleTextField)
    }
    //pressing the button updates the user changes to the array and segues to next view
    @objc func buttonAction(sender: UIButton!) {
        var index = 0
        for t in textFields{
            if t.text == String(newarray[index]){
                
            }else{
                newarray[index] = Character(t.text!)
            }
            index+=1
        }
        self.performSegue(withIdentifier: "final", sender: nil)
    }

}

extension UIViewController {
    //allows keyboard to disappear when user presses into blank area of screen

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
