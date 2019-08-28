//
//  ViewController.swift
//  HangboardApp
//
//  Created by André Schäfer on 27.06.19.
//  Copyright © 2019 André Schäfer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var workoutTitleLabel: UILabel!
    @IBOutlet weak var workoutTimeLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    
    //MARK: - Properties
    var workoutTime: Int = 0
    var totalTime: Int = 0
    var restTime: Int = 0
    var countdown: Int = 0
    
    var workoutTimer = Timer()
    var countdownTimer = Timer()
    
    let workout = Workout(totalTime: 60, workoutTime: 7, restTime: 3, countdown: 5)
    
    
    //MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initWorkout()
        initWorkoutScreen()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: - IBActions

    @IBAction func startWorkout(_ sender: UIButton) {
        prepareCountdownScreen()
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    
    @IBAction func cancelWorkout(_ sender: UIButton) {
        workoutTimer.invalidate()
        resetWorkout()
        updateTimerLabels()
    }
    
    
    //MARK: Start New Workout
    
    func initWorkoutScreen() {
        workoutTitleLabel.text = "Seven Seconds Hang"
        workoutTimeLabel.isHidden = false
        startButton.isHidden = false
        resetButton.isHidden = true
        
        updateTimerLabels()
    }
    
    
    func prepareCountdownScreen() {
        workoutTimeLabel.isHidden = true
        startButton.isHidden = true
        resetButton.isHidden = true
        countDownLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        countDownLabel.text = "\(countdown)"
    }
    
    func initWorkout() {
        workoutTime = workout.workoutTime
        totalTime = workout.totalTime
        restTime = workout.restTime
        countdown = workout.countdown
    }

    
    func startWorkoutTimer() {
        workoutTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    
    //MARK: - Reset Workout
    
    func enableResetButton() {
        startButton.isHidden = true
        resetButton.isHidden = false
    }
    
    
    func resetWorkout() {
        workoutTimer.invalidate()
        
        initWorkout()
        initWorkoutScreen()
    }
    
    
    //MARK: - Update Methods
    
    @objc func updateTimer() {
        if totalTime > 0 {
            totalTime -= 1
            
            if workoutTime == 0 {
                restTime -= 1
                
                if restTime == 0 {
                    workoutTime = workout.workoutTime
                    restTime = workout.restTime
                } else {
                    updateTimerLabels()
                }
            } else {
                workoutTime -= 1
                updateTimerLabels()
            }
        } else {
            showCompletionAlert()
            workoutTimer.invalidate()
        }
        updateTimerLabels()
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
    
    
    func updateTimerLabels() {
        workoutTimeLabel.text = "\(timeString(time: TimeInterval(totalTime)))"
        
        if workoutTime == 0 {
            countDownLabel.textColor = #colorLiteral(red: 0.6392156863, green: 0.8705882353, blue: 0.5137254902, alpha: 1)
            countDownLabel.text = "\(restTime)"
        } else {
            countDownLabel.textColor = #colorLiteral(red: 0.9803921569, green: 0.2745098039, blue: 0.3490196078, alpha: 1)
            countDownLabel.text = "\(workoutTime)"
        }
    }
    
    
    //MARK: - Alerts
    
    func showCompletionAlert() {
        let alertController = UIAlertController(title: "WOW you did it!", message: "💪🏼", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Thanks!", style: .default) { (UIAlertAction) in
            self.resetWorkout()
        }
        
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
    }
    
    
    //MARK: - Helper Functions
    
    func timeString(time: TimeInterval) -> String {
        
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}

