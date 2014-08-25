//
//  SettingsViewController.swift
//  tips
//
//  Created by Vijay Karunamurthy on 8/22/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var percentSwitch: UISwitch!
    @IBOutlet weak var shakeSwitch: UISwitch!
    @IBOutlet weak var localePicker: UIPickerView!
    
    var _localeData: [String] = ["Default", "Japan", "China", "Italy", "France", "Australia", "United States"]
    var _localeCodes: [String] = ["en_US", "jp_JP", "zh_CN", "it_IT", "fr_FR",  "en_AU", "en_US"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.localePicker.dataSource = self
        self.localePicker.delegate = self
        
        var defaults = NSUserDefaults.standardUserDefaults()
        percentSwitch.on = defaults.boolForKey("more_tips")
        shakeSwitch.on = defaults.boolForKey("shake")
        
        var locale_row = 0
        let default_locale = defaults.objectForKey("locale_code") as String
        
        if let def_row = find(_localeCodes, default_locale) {
            localePicker.selectRow(def_row, inComponent: 0, animated: true)
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Picker Delegate
    */
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return _localeData.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return _localeData[row]
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        let codeChoice = _localeCodes[row]
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(codeChoice, forKey: "locale_code")
        defaults.synchronize()
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func tapAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    @IBAction func shakeAction(sender: AnyObject) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool((sender as UISwitch).on, forKey: "shake")
    }
    @IBAction func percentChanged(sender: AnyObject) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool((sender as UISwitch).on, forKey: "more_tips")
    }
}
