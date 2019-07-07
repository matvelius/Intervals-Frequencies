
import AudioKit
import AudioKitUI

import UIKit

class FrequenciesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var frequencies = [""]


    @IBOutlet weak var frequencyPicker1: UIPickerView!
    @IBOutlet weak var frequencyPicker2: UIPickerView!

    var freq1 = 220
    var freq2 = 330

    @IBOutlet var plot: AKNodeOutputPlot?
    
    

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

        self.frequencyPicker1.delegate = self
        self.frequencyPicker1.dataSource = self
        self.frequencyPicker2.delegate = self
        self.frequencyPicker2.dataSource = self
    }


    @IBAction func toggleSound(_ sender: UIButton) {
        if oscillator1.isPlaying {
            oscillator1.stop()
            oscillator2.stop()
            sender.setTitle("Play Sine Waves", for: .normal)
        } else {
            //            oscillator1.frequency = random(in: 220 ... 880)
            oscillator1.frequency = Double(freq1)
            oscillator1.start()
            //            oscillator2.frequency = random(in: 220 ... 880)
            oscillator2.frequency = Double(freq2)
            oscillator2.start()
            sender.setTitle("Stop \(Int(oscillator1.frequency))Hz & \(Int(oscillator2.frequency))Hz", for: .normal)
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return frequencies.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return frequencies[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == frequencyPicker1 {
            freq1 = Int(frequencies[row])!
        } else {
            freq2 = Int(frequencies[row])!
        }
    }

}
