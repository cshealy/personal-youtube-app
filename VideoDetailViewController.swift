/*
 VideoDetailViewController displays the details of the video that the user selected from the table shown in the previous controller. The video is displayed using a Webview, description and title displayed through labels, and the ad is displayed down below.
 */

import UIKit
import iAd

class VideoDetailViewController: UIViewController, ADBannerViewDelegate {
    
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!

    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UITextView!
    
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    
    var selectedVideo:Video?
    
    var bannerView: ADBannerView!
    
    //We know the size of the view for height
    override func viewDidAppear(animated: Bool) {
        
        if let vid = self.selectedVideo {
            
            //display the title on the titleLabel
            self.titleLabel.text = vid.videoTitle
            
            //display the videoDescription on the descriptionLabel
            self.descriptionLabel.text = vid.videoDescription
            
            //width and height adjustments
            let width = self.view.frame.size.width
            let height = width/320 * 180
            
            //adjust webview height
            self.webViewHeightConstraint.constant = height
           
            //embeded code
            let videoEmbedString = "<html><head><style type=\"text/css\">body {background-color: transparent;color: white;}</style></head><body style=\"margin:0\"><iframe frameBorder=\"0\" height=\"" + String(height) + "\" width=\"" + String(width) + "\" src=\"http://www.youtube.com/embed/" + vid.videoId + "?showinfo=0&modestbranding=1&frameborder=0&rel=0\"></iframe></body></html>"
            
            //load the videoEmbedString into the webView
            self.webView.loadHTMLString(videoEmbedString, baseURL: nil)
            
            //Setup our ad banner
            
            bannerView = ADBannerView(adType: .Banner)
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            bannerView.delegate = self
            bannerView.hidden = true
            view.addSubview(bannerView)
            
            let viewsDictionary = ["bannerView": bannerView]
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bannerView]|", options: [], metrics: nil, views: viewsDictionary))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bannerView]|", options: [], metrics: nil, views: viewsDictionary))
            
            
            //stop our loading animation
            loadingIcon.stopAnimating()
            
        }
       
    
    
}
    //show our ad banner
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        bannerView.hidden = false
    }
    //hide our ad banner
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        bannerView.hidden = true
    }
    
}
