//
//  ViewController.swift
//  tips
//
//  Created by Vijay Karunamurthy on 8/20/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var billField: UITextField!
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        billField.text = ""
        
        billField.keyboardType = .DecimalPad
        
        setSegmentValues()
        setLabelValues()
    
    }
    
    override func viewWillAppear(animated: Bool) {
        setSegmentValues()
        calcTotal()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLabelValues() {
        var nf: NSNumberFormatter = getNumberFormatter()
        tipLabel.text = nf.stringFromNumber(0)
        totalLabel.text = nf.stringFromNumber(0)
    }
    
    func setSegmentValues() {
        var defaults = NSUserDefaults.standardUserDefaults()
        var more_preference = defaults.boolForKey("more_tips")
        if more_preference && tipControl.numberOfSegments < 4  {
            tipControl.insertSegmentWithTitle("30%", atIndex: 3, animated:true)
        }
        if !more_preference && tipControl.numberOfSegments > 3 {
            tipControl.removeSegmentAtIndex(3, animated: true)
        }
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        calcTotal()
    }
    
    func calcTotal() {
        var tipPercentages = [0.15, 0.2, 0.25, 0.3]
        var tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        println("User editing object")
        
        // Use locale-specific Number formatter
        var nf: NSNumberFormatter = getNumberFormatter()
        
        var billAmount: Double = 0.0
        
        if let ba_locale = nf.numberFromString(billField.text)?.doubleValue  {
            billAmount = ba_locale
        } else {
            billAmount = billField.text._bridgeToObjectiveC().doubleValue
        }
        
        //var billAmount = billField.text._bridgeToObjectiveC().doubleValue
        
        var tip = billAmount * tipPercentage
        var total = billAmount + tip
        
        // Optionally initialize the property to a desired starting value
        tipLabel.alpha = 0
        totalLabel.alpha = 1
        
        tipLabel.text = nf.stringFromNumber(tip)
        totalLabel.text = nf.stringFromNumber(total)
        //totalLabel.bounds = CGRectMake(124, 299, 180, 30)
        
        var anim = POPBasicAnimation(propertyNamed: "view.alpha")
        anim.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")
        anim.fromValue = 0
        anim.toValue = 1
        var slide_anim = POPBasicAnimation(propertyNamed: "view.center")
        anim.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")
        //slide_anim.fromValue = NSValue(CGRect: CGRectMake(124, 299, 180, 30))
        //slide_anim.toValue = NSValue(CGRect: CGRectMake(124, 233, 180, 30))
        slide_anim.fromValue = NSValue(CGPoint: CGPoint(x: 214,y: 299))
        slide_anim.toValue = NSValue(CGPoint: CGPoint(x: 214,y: 248))
        self.totalLabel.pop_addAnimation(slide_anim, forKey: "slide")
        self.totalLabel.pop_addAnimation(anim, forKey: "fade")
        self.tipLabel.pop_addAnimation(anim, forKey: "fade")
        

        /*
            UIView.animateWithDuration(1, animations: {
                self.tipLabel.alpha = 1
            })
        */
        
    
        
        
        //tipLabel.text = String(format: "$%.2f", tip)
        //totalLabel.text = String(format: "$%.2f", total)
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func getNumberFormatter() -> NSNumberFormatter {
        var defaults = NSUserDefaults.standardUserDefaults()
        var locale_code = defaults.objectForKey("locale_code") as String
        if locale_code == "" { locale_code = "en_US" }
        var nf: NSNumberFormatter = NSNumberFormatter()
        nf.numberStyle  = .CurrencyStyle
        nf.locale = NSLocale(localeIdentifier: locale_code)
        return nf
    }
    
    // detect shake events
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent!) {
        if (motion == .MotionShake) {
            var defaults = NSUserDefaults.standardUserDefaults()
            var shake_preference = defaults.boolForKey("shake")
            if shake_preference {
                tipControl.selectedSegmentIndex = Int(arc4random_uniform(UInt32(tipControl.numberOfSegments)))
            }
        }
    }


}

