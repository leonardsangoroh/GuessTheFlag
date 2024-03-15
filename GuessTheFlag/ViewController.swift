//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Lee Sangoroh on 30/03/2023.
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var counter = 0
    var highScore:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        showNotificationPermission()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Req", style: .plain, target: self, action: #selector(registerLocal))
        
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
        
        resetButtonSize()
        
        //assigns UI image to button                        describes which state of the button should be changed
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        ///load high score from disk when app runs
        let defaults = UserDefaults.standard
        
        if let savedHighScore = defaults.integer(forKey: "highScore") as? Int {
            highScore = savedHighScore
        }
        
        title = "\(countries[correctAnswer].uppercased())  High Score: \(highScore)"
    }
    
    func resetCountAndScore(action:UIAlertAction) {
        
        resetButtonSize()
        
        counter = 0
        score = 0
        title = "\(countries[correctAnswer].uppercased())  High Score: \(highScore)"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: nil)
        
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
                if score > highScore {
                    highScore = score
                    title = "NEW HIGH SCORE!"
                    let ac = UIAlertController(title: title, message: "Your new score is \(highScore)", preferredStyle: .alert)
                    //Setting continue button on the alert
                    ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: resetCountAndScore))
                    present(ac, animated: true)
                    save()
                } else {
                    title = "YOU'RE DONE"
                    let ac = UIAlertController(title: title, message: "Your have guessed 10 flags already", preferredStyle: .alert)
                    //Setting continue button on the alert
                    ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: resetCountAndScore))
                    present(ac, animated: true)
                }

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
                if score > highScore {
                    highScore = score
                    title = "NEW HIGH SCORE!"
                    let ac = UIAlertController(title: title, message: "Your new score is \(highScore)", preferredStyle: .alert)
                    //Setting continue button on the alert
                    ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: resetCountAndScore))
                    present(ac, animated: true)
                    save()
                } else {
                    title = "YOU'RE DONE"
                    let ac = UIAlertController(title: title, message: "Your have guessed 10 flags already", preferredStyle: .alert)
                    //Setting continue button on the alert
                    ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: resetCountAndScore))
                    present(ac, animated: true)
                }
            }
        
    }
    


    }
    
    func save (){
        let defaults = UserDefaults.standard
        defaults.set(highScore, forKey: "highScore")
    }
    
    func resetButtonSize() {
        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
            self.button1.transform = CGAffineTransform.identity
            self.button2.transform = CGAffineTransform.identity
            self.button3.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    // to send local notifications, we need to request for permission
    // registerLocal() is responsible for that
    @ objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted{
                print("Access granted")
                self.scheduleLocal()
            } else {
                print("Access Denied")
            }
        }
    }
    
    
    // will configure all data needed to schedule a notification
    // - content (what to show)
    // - trigger (when to show it)
    // - request (combination of content and trigger)
    func scheduleLocal(){
        
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        
        // content
        let content = UNMutableNotificationContent()
        content.title = "Daily Reminder"
        content.body = "Have you guessed a flag today?"
        content.categoryIdentifier = "dailyReminder"
        content.userInfo = ["customData":"wagwan"]
        content.sound = UNNotificationSound.default
        //86400
        // trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func showNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { [weak self] (settings) in
            if settings.authorizationStatus == .notDetermined {
                self?.registerLocal()
                
            } else if settings.authorizationStatus == .authorized {
                self?.scheduleLocal()
            }
        }
        

    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        // any alert-based messages sent will be routed to ViewController
        center.delegate = self
        
        //An identifier, which is a unique text string that gets sent to you when the button is tapped.
        //A title, which is what user’s see in the interface.
        //Options, which describe any special options that relate to the action. You can choose from .authenticationRequired, .destructive, and .foreground.
        let reminder = UNNotificationAction(identifier: "dailyReminder", title: "Remember to play today", options: .foreground)
        
        
        // intent identifiers - used to connect notifications to intents if any is created
        /// identifier has to be same as categoryIdentifier on line 199
        let category = UNNotificationCategory(identifier: "dailyReminder", actions: [reminder], intentIdentifiers: [])
        // register with notification center
        center.setNotificationCategories([category])
    }


}
