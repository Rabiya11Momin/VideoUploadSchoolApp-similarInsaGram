
import UIKit
import Photos
import MobileCoreServices
import AVFoundation
import ProgressHUD
//import KeychainSwift
//import SOTabBar

class HomeViewController: UIViewController, UIViewControllerTransitioningDelegate , UINavigationControllerDelegate
{
    
    
    @IBOutlet weak var uploadQuestBtn: UIButton!
    
    @IBOutlet weak var mainAddress: UIButton!
    var arrComponent = ["topCategoryTableViewCell","ExploreTabCell","TrendingTableViewCell"]
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
    var latitud : Double = 0.0
    var longitud : Double = 0.0
    var viewmodel = HomeViewModel()
     
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
       
                self.viewmodel.delegate = self
        
        if #available(iOS 13.0, *) {
            
            searchbar.delegate = self
        } else {
        }
 
        tableView.separatorColor = .clear

        for cell in arrComponent {
            tableView.register(UINib(nibName: cell, bundle: VideoApp_Bundle), forCellReuseIdentifier: cell)
        }
        
        
        tableView.register(UINib(nibName: "TrendingTableViewCell", bundle: VideoApp_Bundle), forCellReuseIdentifier: "TrendingTableViewCell")
        
        
        tableView.register(UINib(nibName: "topCategoryTableViewCell", bundle: VideoApp_Bundle), forCellReuseIdentifier: "topCategoryTableViewCell")
        mainAddress.setTitleColor(UIColor.systemPink, for: .normal)
        mainAddress.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewmodel.loadData()
    }
    

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
  
    
    
    @IBAction func mainAddressBtnClickd(_ sender: Any) {
    }
   

    func getRunCounts() -> Int {
        let usD = UserDefaults.standard
        let runs = usD.integer(forKey: "runIncrementerSetting")
        print("Run Counts are \(runs)")
        return runs
    }
    func startLoading() {
        ProgressHUD.show()
        self.view.isUserInteractionEnabled = false
    }

    func stopLoading() {
        self.view.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
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
            
            return   viewmodel.numberOfItems
        default:
            return 0
        }
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            switch arrComponent[indexPath.row]{
                
            case "topCategoryTableViewCell":
                let cell = tableView.dequeueReusableCell(withIdentifier: "topCategoryTableViewCell", for: indexPath) as! topCategoryTableViewCell
                return cell
            case "ExploreTabCell":
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreTabCell", for: indexPath) as! ExploreTabCell
                return cell
                
                
            default:
                return UITableViewCell()
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingTableViewCell", for: indexPath) as!
            TrendingTableViewCell

            
            cell.CommentBtnTapped = {
         
            }
            cell.shareBtnTapped = {
            
                let urlString = self.viewmodel.getInfo(for: indexPath)
                guard let url = URL(string: urlString.imageURL!) else {
                                return
                            }
                  
                            let objectsToShare = [url]
                            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                            self.present(activityVC, animated: true, completion: nil)
            }
            cell.configure(info: viewmodel.getInfo(for: indexPath))

            return cell
            
            
            
        default:
            return UITableViewCell()
        }
        
    }
    
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    

}

extension HomeViewController: RequestDelegate {
    func didUpdate(with state: ViewState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch state {
            case .idle:
                break
            case .loading:
                self.startLoading()
                
            case .success:
                self.tableView.setContentOffset(.zero, animated: true)
                self.tableView.reloadData()
                self.stopLoading()
            case .error(let error):
                self.stopLoading()
                
            }
        }
    }
}
