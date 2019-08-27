//
//  ViewController.swift
//  HangboardApp
//
//  Created by André Schäfer on 27.06.19.
//  Copyright © 2019 André Schäfer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var workoutTitle: UILabel!
    @IBOutlet weak var workoutTimeLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var buttonLabel: UILabel!
    
    //MARK: Properties
    private var timer = Timer()
    private var countdownTimer = Timer()
    private var countdown = 3
    
    private var training = Workout()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        training.title = "7 Seconds Hang"
        training.totalTime = 60
        training.restTime = 3
        training.workoutTime = 7
        
        initWorkoutScreen()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: IBAction

    @IBAction func startWorkout(_ sender: UIButton) {
        prepareCountdownScreen()
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    @IBAction func cancelWorkout(_ sender: UIButton) {
        timer.invalidate()
        resetWorkout()
        updateTimerLabels()
    }
    
    //MARK: Methods
    
    private func initWorkoutScreen() {
        workoutTitle.text = training.title
        workoutTimeLabel.isHidden = false
        startButton.isHidden = false
        resetButton.isHidden = true
        buttonLabel.isHidden = false
        buttonLabel.text = "Start"
        
        updateTimerLabels()
    }
    
    private func prepareCountdownScreen() {
        workoutTimeLabel.isHidden = true
        startButton.isHidden = true
        resetButton.isHidden = true
        buttonLabel.isHidden = true
        countDownLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        countDownLabel.text = "\(countdown)"
    }
    
    @objc func updateCountdown() {
        if countdown > 1 {
            countdown -= 1
            countDownLabel.text = "\(countdown)"
        } else {
            countdownTimer.invalidate()
            resetWorkout()
            startWorkoutTimer()
            enableResetButton()
        }
    }
    
    private func enableResetButton() {
        startButton.isHidden = true
        resetButton.isHidden = false
        buttonLabel.text = "Reset"
    }
    
    private func startWorkoutTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if training.totalTime > 0 {
            training.totalTime -= 1
            
            if training.workoutTime == 0 {
                training.restTime -= 1
                
                if training.restTime == 0 {
                    training.workoutTime = 7
                    training.restTime = 3
                } else {
                    updateTimerLabels()
                }
            } else {
                training.workoutTime -= 1
                updateTimerLabels()
            }
        } else {
            timer.invalidate()
            showCompletionAlert()
        }
        updateTimerLabels()
    }
    
    private func showCompletionAlert() {
        let alertController = UIAlertController(title: "WOW you did it!", message: "💪🏼", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Thanks!", style: .default) { (UIAlertAction) in
            self.resetWorkout()
        }
        
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
    }
    
    private func resetWorkout() {
        timer.invalidate()
        
        training.totalTime = 60
        training.workoutTime = 7
        training.restTime = 3
        countdown = 3
        
        initWorkoutScreen()
    }
    
    func updateTimerLabels() {
        workoutTimeLabel.text = "\(timeString(time: TimeInterval(training.totalTime)))"
        
        if training.workoutTime == 0 {
            countDownLabel.textColor = #colorLiteral(red: 0.6392156863, green: 0.8705882353, blue: 0.5137254902, alpha: 1)
            countDownLabel.text = "\(training.restTime)"
        } else {
            countDownLabel.textColor = #colorLiteral(red: 0.9803921569, green: 0.2745098039, blue: 0.3490196078, alpha: 1)
            countDownLabel.text = "\(training.workoutTime)"
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}

