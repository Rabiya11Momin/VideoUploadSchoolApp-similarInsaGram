
import UIKit
import AVFAudio
import AVKit
import Photos
import MobileCoreServices
import AVFoundation

//import KeychainSwift
//import SOTabBar

class HomeViewController: UIViewController, UIViewControllerTransitioningDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate
{
    @IBOutlet weak var uploadQuestBtn: UIButton!
    
    @IBOutlet weak var mainAddress: UIButton!
    var arrComponent = ["topCategoryTableViewCell","TrendingTableViewCell"]
    //    var tabLbl: UILabel?
    var locationString = ""
    var locationCityString = ""
    var feeds = NSArray()
    var searchController : UISearchController!
    @IBOutlet weak var navView: UIView!
    var finalValue = [String : AnyObject]()
    var filteredData = NSArray()
    @IBOutlet weak var tableView: UITableView!
    var countryList = [String]()
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var addressLbl: UILabel!
    var filteredPeopleData:NSMutableArray = []
    var likeJsonResponse = [String: Any]()
    var hasImage = true
    var latitud : Double = 0.0
    var longitud : Double = 0.0
    
    var videoURL : String?
    var videoMainUrl : URL?
    var VideourlsArr = [String]()
    
    
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print("1")
//        uploadQuestBtn.layer.shadowColor = UIColor.white.cgColor
//        uploadQuestBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
//        uploadQuestBtn.layer.shadowRadius = 3
//        uploadQuestBtn.layer.shadowOpacity = 0.4
        uploadQuestBtn.layer.cornerRadius = 7
        if #available(iOS 13.0, *) {
            
            searchbar.delegate = self
        } else {
        }
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.bounces = false
        
        
        tableView.separatorColor = .clear
        for cell in arrComponent {
            tableView.register(UINib(nibName: cell, bundle: VideoApp_Bundle), forCellReuseIdentifier: cell)
        }
        
        
        tableView.register(UINib(nibName: "TrendingTableViewCell", bundle: VideoApp_Bundle), forCellReuseIdentifier: "TrendingTableViewCell")
        
        
        tableView.register(UINib(nibName: "topCategoryTableViewCell", bundle: VideoApp_Bundle), forCellReuseIdentifier: "topCategoryTableViewCell")
        //        self.view.displayActivityIndicator(shouldDisplay: true)
        //        exploreAPI()
        mainAddress.setTitleColor(UIColor.systemPink, for: .normal)
        mainAddress.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pausePlayeVideos()
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let videoURL = info["UIImagePickerControllerReferenceURL"] as? NSURL
        print(videoURL!)
        //     imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadBtnClicked(_ sender: Any) {
        let imagePickerController = UIImagePickerController ()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        dismiss(animated: true, completion: nil)
        
        guard
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL as NSURL?
                
                
        else {
            return }
        //        videoMainUrl = url
        var uniqueVideoID = ""
        let uniqueID = ""
        
        //Add this to ViewDidLoad
        
        let myVideoVarData = try! Data(contentsOf: url as URL)
        
        //Now writeing the data to the temp diroctory.
        let tempPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let tempDocumentsDirectory: AnyObject = tempPath[0] as AnyObject
        let usD = UserDefaults.standard
        let runs = getRunCounts() + 1
         usD.set(runs, forKey: "runIncrementerSetting")
        
        
        uniqueVideoID = uniqueID + "\(runs)" + "TEMPVIDEO.MOV"
        let tempDataPath = tempDocumentsDirectory.appendingPathComponent(uniqueVideoID) as String
        try? myVideoVarData.write(to: URL(fileURLWithPath: tempDataPath), options: [])
        print("tempDataPath under picker ",tempDataPath)
        
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectoryoutPut = paths[0]
        
        let videoDataPath = documentsDirectoryoutPut  + "/" + "\(runs)" + "TEMPVIDEO.MOV"
        
        let filePathURL = URL(fileURLWithPath: videoDataPath)
        VideourlsArr.append(filePathURL.absoluteString)
        tableView.reloadData()
        
        
    }
    
    @IBAction func mainAddressBtnClickd(_ sender: Any) {
    }
    func incrementAppRuns() {
       
    }

    func getRunCounts() -> Int {
        let usD = UserDefaults.standard
        let runs = usD.integer(forKey: "runIncrementerSetting")
        print("Run Counts are \(runs)")
        return runs
    }
    
    
    func reloadFilterdData(filterText: String?){
        if let searchData = filterText , searchData.count > 0{
            let p1 = NSPredicate(format: "tanName contains[cd] %@", searchData)
            let p2 = NSPredicate(format: "description contains[cd] %@", searchData)
            let predicate = NSCompoundPredicate.init(type: .or, subpredicates: [p1,p2])
            
            self.filteredData = NSArray(array: self.feeds.filtered(using: predicate))
        }else{
            filteredData =  NSArray(array: self.feeds)
        }
        
        tableView.reloadData()
        
    }
    
}


func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }
    print(text)
}
extension HomeViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadFilterdData(filterText: searchText)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        reloadFilterdData(filterText: searchBar.text)
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return arrComponent.count
        case 1:
            
            return  VideourlsArr.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 0, width: headerView.frame.width-10, height: headerView.frame.height-10)
        //  label.text = "Trending near you!"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        
        headerView.addSubview(label)
        
        switch section {
        case 0:
            label.text =  ""
        case 1:
            label.text =  "No Videos!! Upload Videos Using +Upload Button"
        default:
            label.text =  ""
        }
        
        return headerView
        
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            if VideourlsArr.count == 0{
                return 50
            }else{
                return 0
            }
            
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            switch arrComponent[indexPath.row]{
                
                
            case "ExploreTabCell":
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreTabCell", for: indexPath) as! ExploreTabCell
                
                return cell
                
÷                
                
            default:
                return UITableViewCell()
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingTableViewCell", for: indexPath) as!
            TrendingTableViewCell
           
            let obj = VideourlsArr[indexPath.row]
            print(obj)
            
            cell.DescriptionLbl.text = "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs."
            
            cell.configureVideo(videoUrl:VideourlsArr[indexPath.row], imageUrl: "")
            
            cell.CommentBtnTapped = {
                let imagePickerController = UIImagePickerController ()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                imagePickerController.mediaTypes = ["public.movie"]
                self.present(imagePickerController, animated: true, completion: nil)
            }
            cell.shareBtnTapped = {
                
                            
                            // get the url from our data source
                            let urlString = self.VideourlsArr[indexPath.row]
                            guard let url = URL(string: urlString) else {
                                // could not get a valid URL from the string
                                return
                            }
                            
                            // present the share screen
                            let objectsToShare = [url]
                            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                            self.present(activityVC, animated: true, completion: nil)
            }
            
            return cell
            
            
            
        default:
            return UITableViewCell()
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    
   
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayeVideos()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            pausePlayeVideos()
        }
    }
    
    func pausePlayeVideos(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView)
    }
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView, appEnteredFromBackground: true)
    }
}

