//
//  ResultsViewController.swift
//  wordsearch
//
//  Created by River Shelton on 12/6/18.
//  Copyright © 2018 River Shelton. All rights reserved.
//

import Foundation
import UIKit


class ResultsViewController: UIViewController {
    
    @IBOutlet weak var results: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //grabs plain text dictionary
 let path = Bundle.main.path(forResource: "2of12", ofType: "txt")
    
        var data: String
        
        do{
            //makes dicitonary into a string
         data = try String(contentsOfFile: path!)
            
            //makes dicitonary string into an array and removes spaces and new lines
            let lines : [String] = data.components(separatedBy: "\r\n")
            
            //setting up variables for algorithm
            var i = 0
            var x = 2
            var z = puzzletest.size!
            var stringchecker = ""
            var stringcheckerb = ""
            var common: [String] = []
            
            
            //increments through each row
            while(i < puzzletest.size! * puzzletest.size!){
                while(i + x < z){
                    for f in i...i+x{
                        //checks strings forwards
                        stringchecker.append(String(puzzletest.puzz![f]))
                        
                    }
                    for w in (i...i+x).reversed(){
                        //checks string backwards
                        stringcheckerb.append(String(puzzletest.puzz![w]))
                    }
                    //searches dicitonary
                    let checker = lines.contains(where: {$0.caseInsensitiveCompare(stringchecker) == .orderedSame})
                    let checker2 = lines.contains(where: {$0.caseInsensitiveCompare(stringcheckerb) == .orderedSame})
                    
                    //adds matching strings to array
                    if(checker == true){
                        common.append(stringchecker)
                    }
                    if(checker2 == true){
                        common.append(stringcheckerb)
                    }
                    stringchecker = ""
                    stringcheckerb = ""
                    x+=1
                }
                if(i + 2 != z){
                    i+=1
                    x = 2
                }else if(i + 2 == puzzletest.size! * puzzletest.size!){
                    break
                }
                else{
                    i = z + 1
                    z = z + puzzletest.size!
                    x = 2
                }
            }
            //displays matching strings
            results.text = common.joined(separator: "\n")            
            
        }
        catch{
            print("error")
        }
        
        
        
    }
}
