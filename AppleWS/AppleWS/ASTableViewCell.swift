//
//  ASTableViewCell.swift
//  AppleWS
//
//  Created by Parth on 02/12/16.
//  Copyright © 2016 Solution Analysts. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ASTableViewCell: UITableViewCell {

    var asImageView: ASMultiplexImageNode?
    var imageUrls = [String: String]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.asImageView = ASMultiplexImageNode(cache: nil, downloader: ASBasicImageDownloader.shared())
        self.asImageView?.frame = CGRect(x: 20, y: 20, width: 60, height: 60)
        self.asImageView?.backgroundColor = UIColor.red
        self.asImageView?.downloadsIntermediateImages = true
        self.asImageView?.imageIdentifiers = ["original" as NSCopying & NSObjectProtocol, "medium" as NSCopying & NSObjectProtocol, "thumb" as NSCopying & NSObjectProtocol]
        self.asImageView?.dataSource = self
        self.asImageView?.delegate = self
        self.addSubnode(asImageView!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension ASTableViewCell: ASMultiplexImageNodeDataSource, ASMultiplexImageNodeDelegate {
    func multiplexImageNode(_ imageNode: ASMultiplexImageNode, urlForImageIdentifier imageIdentifier: ASImageIdentifier) -> URL? {
        print(imageIdentifier)
        let imgUrl = imageUrls[imageIdentifier as! String]
        if let newImageUrl = imgUrl {
            return URL(string: newImageUrl)
        } else {
            return nil
        }
    }
    
    func multiplexImageNode(_ imageNode: ASMultiplexImageNode, didFinishDownloadingImageWithIdentifier imageIdentifier: ASImageIdentifier, error: Error?) {
        print(imageIdentifier)
    }
}
