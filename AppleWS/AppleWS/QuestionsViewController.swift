//
//  QuestionsViewController.swift
//  AppleWS
//
//  Created by Parth on 01/02/17.
//  Copyright © 2017 Solution Analysts. All rights reserved.
//

import UIKit
import DLRadioButton

class QuestionsViewController: UIViewController {

    @IBOutlet weak var IBtxtQuestions: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtonUI(2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupButtonUI(_ numberOfButtons: Int) {
        var otherButtons : [DLRadioButton] = [];
        let firstFrame = CGRect(x: 20, y: IBtxtQuestions.frame.maxY + 2 , width: 350, height: 44)
        print(firstFrame)
        let firstRadioBtn = createRadioButton(firstFrame, title: "Red Button", color: UIColor.red);
        for var i in 0..<numberOfButtons
        {
            print(firstFrame.maxY)

            let frame = CGRect(x: firstFrame.minX, y: (firstFrame.maxY + 6) + 50 * CGFloat(i), width: firstFrame.width, height: firstFrame.height)
            print(frame)
            let radioButton = createRadioButton(frame, title: "Red Button", color: UIColor.red);
            otherButtons.append(radioButton);
        }
        firstRadioBtn.otherButtons = otherButtons
    }
    
    fileprivate func createRadioButton(_ frame : CGRect, title : String, color : UIColor) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 17);
        radioButton.setTitle(title, for: UIControlState());
        radioButton.setTitleColor(color, for: UIControlState());
        radioButton.iconColor = color;
        radioButton.indicatorColor = color;
        radioButton.backgroundColor = UIColor.gray
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
//        radioButton.addTarget(self, action: #selector(DemoViewController.logSelectedButton), for: UIControlEvents.touchUpInside);
        self.view.addSubview(radioButton);
        
        return radioButton;
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
