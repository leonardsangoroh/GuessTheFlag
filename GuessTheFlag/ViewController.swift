//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Lee Sangoroh on 30/03/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Setting flag border width (from the CAlayer)
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        //Setting border color (from the CA layer)
        button1.layer.borderColor = UIColor.lightGray.cgColor
        //button2.layer.borderColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0)
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        countries += ["estonia","france","germany","ireland","italy","monaco","nigeria","poland","russia","spain","uk","us"]
        
        //calling the method
        //askQuestion(action:nil)
        askQuestion()
    }
    
    //Method that shows 3 random flag images on the screen
    func askQuestion(action:UIAlertAction! = nil){
        
        //shuffling array contents
        countries.shuffle()
        
        correctAnswer = Int.random(in: 1...2)
        
        //assigns UI image to button                        describes which state of the button should be changed
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "\(countries[correctAnswer].uppercased())  Score: \(score)"
    }
    
    func resetCountAndScore(action:UIAlertAction) {
        counter = 0
        score = 0
        title = "\(countries[correctAnswer].uppercased())  Score: \(score)"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        var title:String
         //check whether answer is correct
        //Count score
        if sender.tag == correctAnswer {
            title = "CORRECT"
            score += 1
            counter += 1
            
            if counter <= 10 {
                //send an alert showing what the new score is
                let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
                //Setting continue button on the alert
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
                present(ac, animated: true)
            } else {
                
                title = "YOU'RE DONE"
                let ac = UIAlertController(title: title, message: "You have guessed 10 flags already", preferredStyle: .alert)
                //Setting continue button on the alert
                ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: resetCountAndScore))
                present(ac, animated: true)
            }
            
        } else {
            title = "WRONG"
            score -= 1
            counter += 1
            
            if counter <= 10 {
                //send an alert showing what the new score is
                let ac = UIAlertController(title: title, message: "The correct answer is \(countries[correctAnswer])", preferredStyle: .alert)
                //Setting continue button on the alert
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
                present(ac, animated: true)
            } else {
                title = "YOU'RE DONE"
                let ac = UIAlertController(title: title, message: "Your have guessed 10 flags", preferredStyle: .alert)
                //Setting continue button on the alert
                ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: resetCountAndScore))
                present(ac, animated: true)
            }

        }
        
    }
    


}

