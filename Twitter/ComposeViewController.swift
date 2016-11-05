//
//  ComposeViewController.swift
//  Twitter
//
//  Created by jasmine_lee on 11/4/16.
//  Copyright © 2016 jasmine_lee. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var characterLimitLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tweetTextField: UITextField!
    @IBOutlet weak var tweetButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tweetTextChanged(_ sender: UITextField) {

        tweetButton.isEnabled = (tweetTextField.text != nil && !tweetTextField.text!.isEmpty) ? true : false

        if let text = tweetTextField.text {
            let length = text.characters.count
            let remainingChars = Tweet.characterLimit - length
            characterLimitLabel.text = "\(remainingChars)"


            if remainingChars <= 0 {
                tweetTextField.isUserInteractionEnabled = false
                tweetButton.isEnabled = false
            }
        }

    }

    private func setUp() {
        tweetButton.isEnabled = false
        tweetButton.tintColor = UIColor.lightGray
        tweetButton.setTitleColor(UIColor.lightGray, for: UIControlState.disabled)
        tweetButton.setTitleColor(Tweet.TWITTER_BLUE, for: UIControlState.normal)

        errorLabel.alpha = 0
        errorLabel.isHidden = true

        characterLimitLabel.text = "140"

        let cancelImage = UIImage(named: "cancel")?.withRenderingMode(.alwaysTemplate)
        cancelButton.setImage(cancelImage, for: .normal)
        cancelButton.tintColor = Tweet.TWITTER_BLUE
    }

    @IBAction func onTweetButton(_ sender: UIButton) {

        let text = tweetTextField.text

        if let text = text {
            TwitterClient.sharedInstance?.postTweet(text: text, success: { () in
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error: Error) in
                self.errorLabel.isHidden = false
                self.errorLabel.alpha = 1.0
                UIView.animate(withDuration: 0.5, delay: 1.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.errorLabel.alpha = 0
                    }, completion: { (_: Bool) in
                        self.errorLabel.isHidden = true
                })
                print(error.localizedDescription)
            })
        }
    }

    @IBAction func onCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
