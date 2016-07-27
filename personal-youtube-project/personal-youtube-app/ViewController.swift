/*
 Class to setup the initial view the user will see upon opening the application
 */

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, VideoModelDelegate {

    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    //assign the variable videos explicitly as an empty array of Video objects

    var videos:[Video] = [Video]()
    var selectedVideo:Video?
    var model:VideoModel = VideoModel()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //allow refresh of tableView
        self.tableView.addSubview(self.refreshControl)
        
        self.title = "foxdropLoL Channel"
        self.model.delegate = self
   
        //use the method provided in the VideoModel class in order to set the table with the necessary information
        model.getFeedVideos()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataReady() {
        //access objects that have been downloaded
        self.videos = self.model.videoArray
        
        //reload tableview
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //get width of screen to get height of row
       return (self.view.frame.size.width / 147) * 82
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        
        return videos.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BasicCell")!
    
        let videoTitle = videos[indexPath.row].videoTitle
        
        //get the label for the cell
        let label = cell.viewWithTag(2) as! UILabel
        
        label.text = videoTitle
        
        //changed the ending URL to maxres for better quality image
        //Video Thumbnail URL
        let videoThumbnailUrlString = videos[indexPath.row].videoThumbnailURL
        
        //Create an NSURL object
        let videoThumbnailUrl = NSURL(string: videoThumbnailUrlString)
        
        if(videoThumbnailUrl != nil){

        
        //Create an NSURLRequest Object
        let request = NSURLRequest(URL: videoThumbnailUrl!)
            
        //Create an NSURLSession
        let session = NSURLSession.sharedSession()
            
        //Create a datatask and pass in the request (background thread)
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response: NSURLResponse?, error:NSError?)-> Void in
                
                
                //kick the image back to the main thread when it is finished downloading
                dispatch_async(dispatch_get_main_queue(), {
                    
                //get a reference to the image element of the cell
                let imageView = cell.viewWithTag(1) as! UIImageView
                    
                //Create an image from the data and send it to the imageview
                imageView.image = UIImage(data: data!)
                
                })
    
            })
  
            dataTask.resume()
    }
        
    return cell
    
}
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Take note of which video the user selected
        self.selectedVideo = self.videos[indexPath.row]
        
        //Call segue
        self.performSegueWithIdentifier("goToDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //Get a reference to the destination view controller
        let detailViewController = segue.destinationViewController as! VideoDetailViewController
        
        //Set the selected video
        detailViewController.selectedVideo = self.selectedVideo
    }
    
    //Allow refresh for tableView
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    //Function used in refreshControl
    func handleRefresh(refreshControl: UIRefreshControl){
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    
}

