import Foundation
import UIKit
import Firebase
import Network
class BlogViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView:UITableView!
    var cellHeights: [IndexPath : CGFloat] = [:]

    var posts = [Post]()
    var fetchingMore = false
    var endReached = false
    let leadingScreensForBatching:CGFloat = 3.0
    
    var refreshControl:UIRefreshControl!
    
    var seeNewPostsButton:SeeNewPostsButton!
    var seeNewPostsButtonTopAnchor:NSLayoutConstraint!
    
    var lastUploadedPostID:String?
    var documentdata:[String:Any] = [:]
    var questionBlogWord = ""
    var postsRef:DatabaseReference {
        return Database.database().reference().child("posts")
    }
    var timer = Timer()
    var countss = 0
    
   
    
    let monitor = NWPathMonitor()
    
    
    
    var oldPostsQuery:DatabaseQuery {
        var queryRef:DatabaseQuery
        let lastPost = posts.last
        if lastPost != nil {
            let lastTimestamp = lastPost!.createdAt.timeIntervalSince1970 * 1000
            queryRef = postsRef.queryOrdered(byChild: "timestamp").queryEnding(atValue: lastTimestamp)
        } else {
            queryRef = postsRef.queryOrdered(byChild: "timestamp")
        }
        return queryRef
    }
    
    
    
    
    
    var newPostsQuery:DatabaseQuery {
        var queryRef:DatabaseQuery
        let firstPost = posts.first
        if firstPost != nil {
            let firstTimestamp = firstPost!.createdAt.timeIntervalSince1970 * 1000
            queryRef = postsRef.queryOrdered(byChild: "timestamp").queryStarting(atValue: firstTimestamp)
        } else {
            queryRef = postsRef.queryOrdered(byChild: "timestamp")
        }
        return queryRef
    }
    var dayOfMonth = ""
    var month = ""
    var noConnection:NoConnectionHeader!
    var noConnectionTopAnchor:NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        tableView.register(LoadingCell.self, forCellReuseIdentifier: "loadingCell")
        let cellNibs = UINib(nibName: "QuestionTableViewCell", bundle: nil)
        tableView.register(cellNibs, forCellReuseIdentifier: "QuestionTableViewCell")
        tableView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        view.addSubview(tableView)
        getQuestion()
        var layoutGuide:UILayoutGuide!
        
        if #available(iOS 11.0, *) {
            layoutGuide = view.safeAreaLayoutGuide
        } else {
            // Fallback on earlier versions
            layoutGuide = view.layoutMarginsGuide
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        refreshControl = UIRefreshControl()
    
            
            tableView.addSubview(refreshControl)
            refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = .white
        
        
     
        
        seeNewPostsButton = SeeNewPostsButton()
        view.addSubview(seeNewPostsButton)
        seeNewPostsButton.translatesAutoresizingMaskIntoConstraints = false
        seeNewPostsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        seeNewPostsButtonTopAnchor = seeNewPostsButton.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: -44)
        seeNewPostsButtonTopAnchor.isActive = true
        seeNewPostsButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        seeNewPostsButton.widthAnchor.constraint(equalToConstant: seeNewPostsButton.button.bounds.width).isActive = true
        
        seeNewPostsButton.button.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        
        //dope icon top
          let image: UIImage = UIImage(named: "banner2x.png")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 10, width: 180, height: 47.5))
          imageView.contentMode = .scaleAspectFit
          imageView.image = image
          self.navigationItem.titleView = imageView
            
        //observePosts()
       noConnection = NoConnectionHeader()
        view.addSubview(noConnection)
        noConnection.translatesAutoresizingMaskIntoConstraints = false
        noConnection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noConnectionTopAnchor = noConnection.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 0)
        noConnectionTopAnchor.isActive = true
        noConnection.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        noConnection.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        beginBatchFetch()
        
    }
    func getQuestion(){
        let db = Firestore.firestore()
        db.collection("blog").document("question").getDocument { (document,error) in
            
                   if error != nil{
                       print("cant get data")
                       
                   }
                   if document != nil && document!.exists{
                    
                   if let documentdata = document?.data() {
                   self.documentdata = documentdata
                
                     self.questionBlogWord = self.documentdata["question"] as! String
                     
                    }
                    }
           
        }

    }
    
       
        
    func getTimeFromServer2(completionHandler:@escaping (_ getResDate: String, _ month:String, _ _hour:String) -> Void){
            if (UserDefaults.standard.bool(forKey: "nowifi") == false){
            let url = URL(string: "https://www.apple.com")
            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                let httpResponse = response as? HTTPURLResponse
                if let contentType = httpResponse!.allHeaderFields["Date"] as? String {
                    //print(httpResponse)
                    let dFormatter = DateFormatter()
                    dFormatter.timeZone = NSTimeZone(abbreviation: "EST") as TimeZone?
                    dFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
                    let serverTime = dFormatter.date(from: contentType)
                    dFormatter.dateFormat = "M"
                    let myStringafd = dFormatter.string(from: serverTime!)
                    dFormatter.dateFormat = "d"
                    let myStringafds = dFormatter.string(from: serverTime!)
                    dFormatter.dateFormat = "H"
                    let myStringafdss = dFormatter.string(from: serverTime!)
                    completionHandler(myStringafd,myStringafds,myStringafdss)
                    
                    
                }
            }
            task.resume()
        }
    }
    var finalTimeLeft = 0
    var timeRemainingString = ""
    var colorOfTimeRemaining:UIColor = .black
    var hours = ""
    func GetDaysRemaining(){
         if UserDefaults.standard.bool(forKey: "nowifi") == false{
    
            let dayOfMonthInt = Int(dayOfMonth)!
            let hoursInt = Int(hours)!
        
            if (dayOfMonthInt < 24){
                if(dayOfMonthInt <= 7){
                    self.finalTimeLeft = 7-dayOfMonthInt
                }
                else if(dayOfMonthInt <= 15){
                    self.finalTimeLeft = 15-dayOfMonthInt
                }
                else if(dayOfMonthInt <= 23){
                    self.finalTimeLeft = 23-dayOfMonthInt
                }
            }else{
                if(month == "1" || month == "3" || month == "5" || month == "7" || month == "8" || month == "10" || month == "12"){
                    self.finalTimeLeft = 31 - dayOfMonthInt
                }else if(month == "2"){
                    self.finalTimeLeft = 29 - dayOfMonthInt
                }else{
                    self.finalTimeLeft = 30 - dayOfMonthInt
                }
            }
            if(finalTimeLeft == 1){
                timeRemainingString = "1 Day Remaining"
            }else if(finalTimeLeft > 1){
                timeRemainingString = "\(finalTimeLeft) Days Remaining"
            }else{
                if (hoursInt == 1){
                    timeRemainingString = "1 Hour Remaining"
                }else{
                    timeRemainingString = "\(24-hoursInt) Hours Remaining"
                }
            }
            if (finalTimeLeft >= 3){
                colorOfTimeRemaining = .blue
            }else{
                colorOfTimeRemaining = .red
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("ttbtw")
        noConnection.isHidden = true;
        seeNewPostsButton.isHidden = true
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
                 if path.status == .satisfied {
                     print("We're connected!")
                    UserDefaults.standard.set(false, forKey: "nowifi")
                    DispatchQueue.main.async {
                         self.seeNewPostsButton.isHidden = true
                    }
                 
                 } else {
                     print("No connection.")
                    UserDefaults.standard.set(true, forKey: "nowifi")
                    DispatchQueue.main.async {
                        print("cousiN")
                         self.seeNewPostsButton.isHidden = false
                    }
                
                    
                 }

                 print(path.isExpensive)
             }
        if UserDefaults.standard.bool(forKey: "Finshed") == true{
            UserDefaults.standard.set(false, forKey: "Finshed")
        newPostsQuery.queryLimited(toFirst: 20).observeSingleEvent(of: .value, with: { snapshot in
            var tempPosts = [Post]()

            let firstPost = self.posts.first
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let data = childSnapshot.value as? [String:Any],
                    let post = Post.parse(childSnapshot.key, data),
                    childSnapshot.key != firstPost?.id {

                    tempPosts.insert(post, at: 0)
                }
            }

            self.posts.insert(contentsOf: tempPosts, at: 0)

            let newIndexPaths = (0..<tempPosts.count).map { i in
                return IndexPath(row: i, section: 1)
            }

            self.refreshControl.endRefreshing()
            self.tableView.insertRows(at: newIndexPaths, with: .top)
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)

            //self.listenForNewPosts()
            self.tableView.reloadData()
        })
    }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       if UserDefaults.standard.bool(forKey: "nowifi") == false{
       
           self.getTimeFromServer2 { (serverDate, serverDate2, serverDate3) in
               self.month = serverDate
               self.dayOfMonth = serverDate2
               self.hours = serverDate3
            self.GetDaysRemaining()
           }
        }
        //listenForNewPosts()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopListeningForNewPosts()
    }
    
    func toggleSeeNewPostsButton(hidden:Bool) {
        if hidden {
            // hide it
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.seeNewPostsButtonTopAnchor.constant = -44.0
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            // show it
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.seeNewPostsButtonTopAnchor.constant = 12
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    @objc func handleRefresh() {
        print("Refresh!")
        
        if UserDefaults.standard.bool(forKey: "nowifi") == false{
            print("Refresh!")
        toggleSeeNewPostsButton(hidden: true)
        countss = 2
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countdownDisplayText), userInfo: nil, repeats: true)
        newPostsQuery.queryLimited(toFirst: 20).observeSingleEvent(of: .value, with: { snapshot in
            var tempPosts = [Post]()
            
            let firstPost = self.posts.first
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let data = childSnapshot.value as? [String:Any],
                    let post = Post.parse(childSnapshot.key, data),
                    childSnapshot.key != firstPost?.id {
                    
                    tempPosts.insert(post, at: 0)
                }
            }
            
            self.posts.insert(contentsOf: tempPosts, at: 0)
            print("here it is")
            let newIndexPaths = (0..<tempPosts.count).map { i in
                return IndexPath(row: i, section: 1)
            }
            
            self.refreshControl.endRefreshing()
            self.tableView.insertRows(at: newIndexPaths, with: .top)
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            
          
            self.tableView.reloadData()
        })
        }else{
            self.refreshControl.endRefreshing()
        }
    }
    @objc func countdownDisplayText(){
        
        countss-=1
        if countss == 0{
            
            timer.invalidate()
            self.refreshControl.endRefreshing()
        }
    }
    func fetchPosts(completion:@escaping (_ posts:[Post])->()) {
        
        oldPostsQuery.queryLimited(toLast: 20).observeSingleEvent(of: .value, with: { snapshot in
            var tempPosts = [Post]()
            
            let lastPost  = self.posts.last
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let data = childSnapshot.value as? [String:Any],
                    let post = Post.parse(childSnapshot.key, data),
                    childSnapshot.key != lastPost?.id {
                    
                    tempPosts.insert(post, at: 0)
                }
            }
            
            return completion(tempPosts)
        })
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return posts.count
        case 2:
            return fetchingMore ? 1 : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            getQuestion()
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
            cell.setPost(question: questionBlogWord,DaysRemaning:timeRemainingString,Color:colorOfTimeRemaining)
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
            cell.setPost(post: posts[indexPath.row])
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            cell.spinner.startAnimating()
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 72.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height * leadingScreensForBatching {
            
            if !fetchingMore && !endReached {
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
        
        fetchPosts { newPosts in
            self.posts.append(contentsOf: newPosts)
            self.fetchingMore = false
            self.endReached = newPosts.count == 0
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
                
                self.listenForNewPosts()
            }
        }
    }
    
    var postListenerHandle:UInt?
    
    func listenForNewPosts() {
        
        guard !fetchingMore else { return }
        
        // Avoiding duplicate listeners
        stopListeningForNewPosts()
        
        postListenerHandle = newPostsQuery.observe(.childAdded, with: { snapshot in
            
            if snapshot.key != self.posts.first?.id,
                let data = snapshot.value as? [String:Any],
                //let post = Post.parse(snapshot.key, data) {
                let _ = Post.parse(snapshot.key, data) {
                self.stopListeningForNewPosts()
                
                if snapshot.key == self.lastUploadedPostID {
                    self.handleRefresh()
                    self.lastUploadedPostID = nil
                } else {
                   self.toggleSeeNewPostsButton(hidden: false)
                }
            }
        })
    }
    
    func stopListeningForNewPosts() {
        if let handle = postListenerHandle {
            newPostsQuery.removeObserver(withHandle: handle)
            postListenerHandle = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newPostNavBar = segue.destination as? UINavigationController,
            let newPostVC = newPostNavBar.viewControllers[0] as? WritePostViewController {
            
            newPostVC.delegate = self
        }
    }
}

extension BlogViewController: NewPostVCDelegate {
    func didUploadPost(withID id: String) {
        self.lastUploadedPostID = id
    }
}
