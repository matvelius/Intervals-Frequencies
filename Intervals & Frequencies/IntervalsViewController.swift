//
//  IntervalsViewController.swift
//  Intervals & Frequencies
//
//  Created by Matvey on 7/5/19.
//  Copyright © 2019 Matvey. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class IntervalsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var frequencyPicker: UIPickerView!
    
    @IBAction func intervalSegmentedControl(_ sender: UISegmentedControl) {
        oscillator2.stop()
        oscillator2.start()
        
        switch sender.selectedSegmentIndex {
        
        case 0: // OFF
            oscillator2.stop()
        case 1: // unison
            freq2 = freq1
        case 2: // 2nd
            freq2 = freq1 * 9 / 8
        case 3: // 3rd
            freq2 = freq1 * 5 / 4
        case 4: // 4th
            freq2 = freq1 * 4 / 3
        case 5: // 5th
            freq2 = freq1 * 3 / 2
        case 6: // 6th
            freq2 = freq1 * 5 / 3
        case 7: // 7th
            freq2 = freq1 * 16 / 9 
        case 8: // octave
            freq2 = freq1 * 2
        default:
            freq2 = freq1 * 2
        }
        
        
        oscillator2.frequency = freq2
        
    }
    
    @IBOutlet weak var intervalFrequency: UILabel!
    
    @IBOutlet weak var intervalRatio: UILabel!
    
    
    @IBOutlet weak var plot: AKNodeOutputPlot!
    
    var oscillator1 = AKOscillator()
    var oscillator2 = AKOscillator()
    var mixer = AKMixer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        mixer = AKMixer(oscillator1, oscillator2)
        
        // Cut the volume in half since we have two oscillators
        mixer.volume = 0.5
        AudioKit.output = mixer
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for n in 60...1000 {
            frequencies.append(String(n))
        }
        
        self.frequencyPicker.delegate = self
        self.frequencyPicker.dataSource = self
        
        frequencyPicker.selectRow(161, inComponent: 0, animated: true)
        
        oscillator1.frequency = freq1
        oscillator1.start()
        
//        if oscillator1.isPlaying {
//            oscillator1.stop()
//            oscillator2.stop()
//            sender.setTitle("Play Sine Waves", for: .normal)
//        } else {
//            //            oscillator1.frequency = random(in: 220 ... 880)
//            oscillator1.frequency = Double(freq1)
//            oscillator1.start()
//            //            oscillator2.frequency = random(in: 220 ... 880)
//            oscillator2.frequency = Double(freq2)
//            oscillator2.start()
//            sender.setTitle("Stop \(Int(oscillator1.frequency))Hz & \(Int(oscillator2.frequency))Hz", for: .normal)
//        }
//        let currentPlot = AKNodeOutputPlot(oscillator1)
//        currentPlot.plotType = .rolling
//
////        plot.plotType = .buffer
//        currentPlot.shouldFill = true
//        currentPlot.shouldMirror = true
//        currentPlot.color = UIColor.blue
//        plot.addSubview(currentPlot)
//        plot.resume()
//        audioOutputPlot.addSubview(plot)
        
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(frequencies)
        return frequencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return frequencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        oscillator1.stop()
        freq1 = Double(frequencies[row])!
        oscillator1.frequency = freq1
        oscillator1.start()
    }
    

}
