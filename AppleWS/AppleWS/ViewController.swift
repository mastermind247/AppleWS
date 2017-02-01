//
//  ViewController.swift
//  AppleWS
//
//  Created by Parth on 30/11/16.
//  Copyright © 2016 Solution Analysts. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import AsyncDisplayKit
import SimplePDF
import PromiseKit
import MessageUI
import Anymotion
import PhotosUI


class ViewController: UIViewController, MFMailComposeViewControllerDelegate {

    let iTunesUrl = "https://itunes.apple.com/us/rss/toptvepisodes/limit=100/json"
    
    @IBOutlet weak var IBtblView: UITableView!
    
    var feedsResponse: FeedModel?
    var imageUrls = [String: String]()
    var imageView: ASMultiplexImageNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromItunesFeed()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    } 
    override func viewDidAppear(_ animated: Bool) {
        let image = UIImage(named: "Image")
        image?.withRenderingMode(.alwaysTemplate)
        let imageView1 = UIImageView(frame: CGRect(x: 200, y: 200, width: 100, height: 100))
        imageView1.image = image
        imageView1.tintColor = UIColor.gray
        self.view.addSubview(imageView1)
        _ = PHPhotoLibrary.requestAuthorization().then(execute: { (status) -> Void in print(status.rawValue) })
        let goRight = ANYPOPSpring(kPOPLayerPositionX).toValue(100).springSpeed(5).animation(for: imageView1.layer)
        let fadeOut = ANYCABasic(#keyPath(CALayer.opacity)).toValue(0).duration(1).animation(for: imageView1.layer)
    }
}

extension ViewController {
    func createPDFWithData() {
        let dataDict = ["THIS IS QUESTION": "ANSWER"]
        var dataArr = [dataDict]
        dataArr.append(["THIS IS QUESTION 2 THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2THIS IS QUESTION 2": "ANSWER 2"])
        dataArr.append(["THIS IS QUESTION 3 ": "ANSWER 3"])
        dataArr.append(["THIS IS QUESTION 4 ": "ANSWER 4"])
        dataArr.append(["THIS IS QUESTION 5 ": "ANSWER 5"])
        dataArr.append(["THIS IS QUESTION 6 ": "ANSWER 6"])
        dataArr.append(["THIS IS QUESTION 7 ": "ANSWER 7"])
        dataArr.append(["THIS IS QUESTION 8 ": "ANSWER 8"])
        dataArr.append(["THIS IS QUESTION 9 ": "ANSWER 9"])
        
        
        let A4paperSize = CGSize(width: 595, height: 842)
        let pdf = SimplePDF(pageSize: A4paperSize)
        for text in dataArr {
            for (key,value) in text {
                let question = key
                let answer = value
                pdf.addText("\(question)")
                pdf.addText(" \(answer)")
            }
        }

        if let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let fileName = "flow.pdf"
            let documentsFileName = docDir + "/" + fileName
            let pdfData = pdf.generatePDFdata()
            do {
                try pdfData.write(to: URL(fileURLWithPath: documentsFileName), options: .atomic)
                print("\nThe generated pdf can be found at:")
                print("\n\t\(documentsFileName)\n")
            } catch {
                print(error)
            }
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["parth.adroja.sa@gmail.com"])
        mailComposerVC.setSubject("Sending you an pdf file...")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let pdfFileName = documentsPath.appending("/flow.pdf")
        let fileData = NSData(contentsOfFile: pdfFileName)
        mailComposerVC.addAttachmentData(fileData as! Data, mimeType: "application/pdf ", fileName: "flow")
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.feedsResponse?.feed?.entry?.count  {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ASCell", for: indexPath) as! ASTableViewCell
        let high = self.feedsResponse?.feed?.entry?[indexPath.row].image?.last
        let medium = self.feedsResponse?.feed?.entry?[indexPath.row].image?[1]
        let low = self.feedsResponse?.feed?.entry?[indexPath.row].image?.first
        let entry = self.feedsResponse?.feed?.entry
        cell.imageUrls["original"] = String(describing: high!)
        cell.imageUrls["medium"] = String(describing: medium!)
        cell.imageUrls["thumb"] = String(describing: low!)
        
        return cell
    }
}

extension ViewController {
    // Get Data from Itunes Feed
    func getDataFromItunesFeed() {
        Alamofire.request(iTunesUrl).responseObject { (response: DataResponse<FeedModel>) in
            self.feedsResponse = response.result.value
            let high = self.feedsResponse?.feed?.entry?.last?.image?.last
            let medium = self.feedsResponse?.feed?.entry?.last?.image?[1]
            let low = self.feedsResponse?.feed?.entry?.last?.image?.first

            self.imageUrls["original"] = String(describing: high!)
            self.imageUrls["medium"] = String(describing: medium!)
            self.imageUrls["thumb"] = String(describing: low!)
            
            self.imageView = ASMultiplexImageNode(cache: nil, downloader: ASBasicImageDownloader.shared())
            self.imageView?.frame = CGRect(x: 30, y: 30, width: 100, height: 100)
            self.imageView?.backgroundColor = UIColor.red
            self.imageView?.downloadsIntermediateImages = true
            self.imageView?.imageIdentifiers = ["original" as NSCopying & NSObjectProtocol, "medium" as NSCopying & NSObjectProtocol, "thumb" as NSCopying & NSObjectProtocol]
            self.imageView?.dataSource = self
            self.imageView?.delegate = self
//            self.view.addSubnode(self.imageView!)
            
            self.IBtblView.performSelector(onMainThread: #selector(self.IBtblView.reloadData), with: nil, waitUntilDone: false)
        }
    }
}

extension ViewController: ASMultiplexImageNodeDelegate, ASMultiplexImageNodeDataSource {
    
    func multiplexImageNode(_ imageNode: ASMultiplexImageNode, urlForImageIdentifier imageIdentifier: ASImageIdentifier) -> URL? {
        
        let newImageUrl = URL(string: imageUrls[imageIdentifier as! String]!)
        return newImageUrl
    }
    
    func multiplexImageNode(_ imageNode: ASMultiplexImageNode, didFinishDownloadingImageWithIdentifier imageIdentifier: ASImageIdentifier, error: Error?) {
    }
}
