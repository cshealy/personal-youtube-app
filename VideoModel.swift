/*
 The code below grabs the data for the videos using API calls and stores the maximum amount of videos allowed in a array containing the video objects.
 */

import UIKit
import Alamofire

protocol VideoModelDelegate{
    func dataReady()
}

class VideoModel: NSObject {

    let API_KEY = "PERSONAL API KEY"
    let UPLOADS_PLAYLIST_ID = "UU9U_UPJLasfZYZ0icNI0vBg"
    
    var videoArray = [Video]()
    
    var delegate:VideoModelDelegate?
    
    
    
    func getFeedVideos(){
        
        //fetch videos with our YouTube API
        Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/playlistItems", parameters: ["part":"snippet", "playlistId":UPLOADS_PLAYLIST_ID, "key": API_KEY, "maxResults": "20"], encoding: ParameterEncoding.URL, headers: nil).responseJSON{ (response) -> Void in
            
            if let JSON = response.result.value{
               
                var arrayOfVideos = [Video]()
                
                for video in JSON["items"] as! NSArray{
                    
                    //Create objects from the JSON
                    let videoObj = Video()
                    //This is how we sift through the dictionaries for what we want
                    videoObj.videoId = video.valueForKeyPath("snippet.resourceId.videoId") as! String
                    videoObj.videoTitle = video.valueForKeyPath("snippet.title") as! String
                    videoObj.videoDescription = video.valueForKeyPath("snippet.description") as! String
                    videoObj.videoThumbnailURL = video.valueForKeyPath("snippet.thumbnails.maxres.url") as! String
                    
                    arrayOfVideos.append(videoObj)
                }
                //When everything is done assign arrayOfVideos to our videoArray
                self.videoArray = arrayOfVideos
                
                
                if self.delegate != nil {
                    self.delegate!.dataReady()
                }
            }
    }
    
}
}