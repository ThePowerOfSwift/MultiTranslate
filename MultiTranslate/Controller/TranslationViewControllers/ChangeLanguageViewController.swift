//
//  ChangeLanguageViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/07.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

class ChangeLanguageViewController: UIViewController {
    
    var pickerView: UIPickerView = UIPickerView()
    let languageList: [String] = ["English", "Chinese", "Japanese", "French", "Spanish"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // ViewContorller 背景色
        self.view.backgroundColor = UIColor(red: 0.92, green: 1.0, blue: 0.94, alpha: 1.0)
        
        // PickerView のサイズと位置
        pickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 2)
        pickerView.backgroundColor = UIColor(red: 0.69, green: 0.93, blue: 0.9, alpha: 1.0)
        
        // PickerViewはスクリーンの中央に設定
        pickerView.center = self.view.center
        
        // Delegate設定
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.view.addSubview(pickerView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneChange))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelChange))
    }
    
    @objc func doneChange() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelChange() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension ChangeLanguageViewController : UIPickerViewDelegate, UIPickerViewDataSource {
 
    // ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

         if component == 0 {
            return languageList.count
         } else {
            return languageList.count
         }
    }
    
    // ドラムロールの各タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

         if component == 0 {
            return languageList[row]
         } else {
            return languageList[row]
         }

    }
    
    // ドラムロール選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
//            self.textField2.text = list[0][row]
            print("picker 1 is \(languageList[row])")
        } else {
//            self.textField4.text = list[1][row]
            print("picker 2 is \(languageList[row])")
        }
    }

}
