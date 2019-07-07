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
    
    @IBOutlet weak var soundSwitchOutlet: UIBarButtonItem!
    
    @IBAction func soundSwitchFlipped(_ sender: UISwitch) {
        if sender.isOn {
            freq2 = freq1
            oscillator1.start()
            oscillator2.start()
        } else {
            
            oscillator1.stop()
            oscillator2.stop()
        }
    }
    
    @IBOutlet weak var frequencyPicker: UIPickerView!
    
    var ratio: Double = 1
    var a: Double = 1
    var b: Double = 1
    
    @IBAction func intervalSegmentedControl(_ sender: UISegmentedControl) {
        oscillator2.stop()
        oscillator2.start()
        
        switch sender.selectedSegmentIndex {
        
        case 0: // OFF
            oscillator2.stop()
            (a, b) = (1, 1)
        case 1: // unison
            (a, b) = (1, 1)
        case 2: // 2nd
            (a, b) = (9, 8)
        case 3: // 3rd
            (a, b) = (5, 4)
        case 4: // 4th
            (a, b) = (4, 3)
        case 5: // 5th
            (a, b) = (3, 2)
        case 6: // 6th
            (a, b) = (5, 3)
        case 7: // 7th
            (a, b) = (15, 8)
        case 8: // octave
            (a, b) = (2, 1)
        default:
            (a, b) = (1, 1)
        }
        
        ratio = a/b
        intervalRatio.text = "\(Int(a))/\(Int(b))"
        
        freq2 = freq1 * ratio
        let freq2String = String(format: "%.1f", freq2)
        intervalFrequency.text = "\(freq2String)Hz"
        
        oscillator2.frequency = freq2
        
    }
    
    @IBOutlet weak var intervalFrequency: UILabel!
    
    @IBOutlet weak var intervalRatio: UILabel!
    
    
    @IBOutlet var plot: AKNodeOutputPlot!

    @IBOutlet weak var spectrumPlotContainerView: EZAudioPlot!
    
    
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
        
        plot.color = AKColor.blue
        
//        setupPlot()
        
//        plot2.node = mixer
        
//        let spectrumPlot = AKNodeFFTPlot(mixer, frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        
//        let spectrumPlot = AKNodeFFTPlot(
//
//        spectrumPlot.shouldFill = true
//        spectrumPlot.shouldMirror = false
//        spectrumPlot.shouldCenterYAxis = false
//        spectrumPlot.color = UIColor.purple
//
//        spectrumPlotContainerView.addSubview(spectrumPlot)
//
//        plot2 = spectrumPlot
//        plot2.color = AKColor.blue
        
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
    
    func setupPlot() {
        let plot = AKNodeOutputPlot(mixer, frame: spectrumPlotContainerView.bounds)
        plot.translatesAutoresizingMaskIntoConstraints = false
        plot.plotType = .rolling
        plot.shouldFill = true
        plot.shouldMirror = true
        plot.color = UIColor.blue
        spectrumPlotContainerView.addSubview(plot)
        
        // Pin the AKNodeOutputPlot to the audioInputPlot
        var constraints = [plot.leadingAnchor.constraint(equalTo: spectrumPlotContainerView.leadingAnchor)]
        constraints.append(plot.trailingAnchor.constraint(equalTo: spectrumPlotContainerView.trailingAnchor))
        constraints.append(plot.topAnchor.constraint(equalTo: spectrumPlotContainerView.topAnchor))
        constraints.append(plot.bottomAnchor.constraint(equalTo: spectrumPlotContainerView.bottomAnchor))
        constraints.forEach { $0.isActive = true }
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        print(frequencies)
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
