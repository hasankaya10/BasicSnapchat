//
//  SnapViewController.swift
//  BasicSnapchat
//
//  Created by Hasan Kaya on 25.05.2022.
//

import UIKit
import ImageSlideshow
import Kingfisher
import ImageSlideshowKingfisher
class SnapViewController: UIViewController {

    var inputArray = [KingfisherSource]()
    var selectedSnap : SnapModel?
    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedSnap = selectedSnap {
            for imageUrl in selectedSnap.imageUrlArray {
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
            timeLabel.text = "Time Left \(selectedSnap.timeDifference)"
            
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
            pageIndicator.pageIndicatorTintColor = UIColor.black
           
            
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.95))
            imageSlideShow.pageIndicator = pageIndicator
            imageSlideShow.backgroundColor = UIColor.white
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
         
            
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLabel)
        }


    }
    


}
