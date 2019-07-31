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
    @IBOutlet weak var workoutTimeLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var buttonLabel: UILabel!
    
    //MARK: Properties
    private var timer = Timer()
    private var countdownTimer = Timer()
    
    private var totalTime = Constants.sevenSecondsTotalTime
    private var hangTime = Constants.sevenSecondsHangTime
    private var restTime = Constants.sevenSecondsRestTime
    private var countdown = Constants.countdown
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if totalTime > 0 {
            totalTime -= 1
            
            if hangTime == 0 {
                restTime -= 1
                
                if restTime == 0 {
                    hangTime = Constants.sevenSecondsHangTime
                    restTime = Constants.sevenSecondsRestTime
                } else {
                    updateTimerLabels()
                }
            } else {
                hangTime -= 1
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
        
        totalTime = Constants.sevenSecondsTotalTime
        hangTime = Constants.sevenSecondsHangTime
        restTime = Constants.sevenSecondsRestTime
        countdown = Constants.countdown
        
        initWorkoutScreen()
    }
    
    func updateTimerLabels() {
        workoutTimeLabel.text = "\(timeString(time: TimeInterval(totalTime)))"
        
        if hangTime == 0 {
            countDownLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            countDownLabel.text = "\(restTime)"
        } else {
            countDownLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            countDownLabel.text = "\(hangTime)"
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}

