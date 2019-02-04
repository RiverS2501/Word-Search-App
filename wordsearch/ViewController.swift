//
//  ViewController.swift
//  wordsearch
//
//  Created by River Shelton on 10/7/18.
//  Copyright © 2018 River Shelton. All rights reserved.
//

import UIKit
//creates an instance of the puzzle object
let puzzletest = puzzle.init(puzz: nil, size: nil, name: nil)


class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        step.wraps = true
        step.minimumValue = 10
        step.maximumValue = 20
    }

//creates the stepper
    @IBOutlet weak var counter: UILabel!
    
    @IBOutlet weak var step: UIStepper!
    
    @IBAction func stepper(_ sender: UIStepper) {
       counter.text = Int(sender.value).description
    
    }
    //button creates puzzle and sets name and size then segues to next view
    @IBAction func createPuzzle(_ sender: UIButton, forEvent event: UIEvent) {
        if let labelsize = counter.text, let sze = Int(labelsize){
           puzzletest.size = sze
            let randomName = String(arc4random_uniform(1000))
            puzzletest.name = randomName + ".jpg"
        }
    
    
}

}
