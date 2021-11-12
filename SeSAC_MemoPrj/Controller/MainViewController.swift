//
//  ViewController.swift
//  SeSAC_MemoPrj
//
//  Created by ChanhoHwang on 2021/11/08.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var tabelView: UITableView!
    
    let localRealm = try! Realm()
    
    var filteredMemos: Results<MemoList>!
    var fixedMemos: Results<MemoList>!
    var noneFixedMemos: Results<MemoList>!
    var row = MemoList()
    var colorText = ""
    
    var searchController = UISearchController(searchResultsController: nil)
    
    let firstLaunch = FirstLaunch(userDefaults: UserDefaults.standard, key: Constants.userDefaultKey.userInfo)
    
    var memos: Results<MemoList>! { didSet { self.tabelView.reloadData() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstLaunchAction()
        
        setUpSearchController()
        setUpTabelView()
        
        let nibName = UINib(nibName: MainTableViewCell.identifier, bundle: nil)
        self.tabelView.register(nibName, forCellReuseIdentifier: MainTableViewCell.identifier)
        
        memos = localRealm.objects(MemoList.self)
        
        // removeAllData()
        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    func firstLaunchAction() {
        if firstLaunch.isFirstLaunch {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func memoButtonPressed(_ sender: UIBarButtonItem) {
        let storyBoard = UIStoryboard(name: "Memo", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: MemoViewController.identifier) as! MemoViewController
        
        vc.CompleteActionHandler = {
            // 서치 자동 종료
            self.tabelView.reloadData()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - setUp
    
    func setUpSearchController() {
        searchController.delegate = self
        
        searchController.searchResultsUpdater = self // search result updating protocol usage
        searchController.obscuresBackgroundDuringPresentation = false // 거색시 화면 숨김
        searchController.searchBar.placeholder = "검색"
        searchController.searchBar.tintColor = .lightGray
        searchController.searchBar.autocorrectionType = .no
        searchController.searchBar.autocapitalizationType = .none
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "닫기"
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        setUpTitleMemoCount()
        self.navigationItem.titleView?.tintColor = .white
        
        definesPresentationContext = true
    }
    
    func setUpTitleMemoCount() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: getAllMemoCountFromUserMemo()))
        
        self.navigationController?.navigationBar.topItem?.title = "\(result!)개의 메모"
    }
    
    func setUpTabelView() {
        self.tabelView.delegate = self
        self.tabelView.dataSource = self
        self.tabelView.backgroundColor = .black
        // self.tabelView.tableHeaderView?.tintColor = .white
        self.tabelView.sectionHeaderHeight = 40
        // self.tabelView.sectionFooterHeight = 20
        self.tabelView.sectionIndexColor = .white
    }
}

//MARK: - TabelView

extension MainViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.searchController.isActive {
            return 1
        } else {
            let fixedMemoCount = getFixedMemoCountFromUserMemo()
            let noneFixedMemoCount = getNoneFixedMemoCountFromUserMemo()
            
            if fixedMemoCount > 0 && noneFixedMemoCount == 0 {
                return 1
            } else if noneFixedMemoCount > 0 && fixedMemoCount > 0 {
                return 2
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !self.searchController.isActive {
            let fixedMemoCount = getFixedMemoCountFromUserMemo()
            let noneFixedMemoCount = getNoneFixedMemoCountFromUserMemo()
            
            if fixedMemoCount > 0 && noneFixedMemoCount == 0 {
                return "고정된 메모"
            } else if noneFixedMemoCount > 0 && fixedMemoCount > 0 {
                if section == 0 {
                    return "고정된 메모"
                } else {
                    return "메모"
                }
            } else {
                return "메모"
            }
        }
        return "\(filteredMemos.count)개 찾음"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //        if !self.searchController.isActive {
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 0, y: 3, width: 320, height: 44)
        myLabel.font = UIFont.boldSystemFont(ofSize: 18)
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        let headerView = UIView()
        headerView.addSubview(myLabel)
        
        return headerView
        //        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive {
            return filteredMemos.count
        } else {
            let fixedMemoCount = getFixedMemoCountFromUserMemo()
            let noneFixedMemoCount = getNoneFixedMemoCountFromUserMemo()
            
            if fixedMemoCount > 0 && noneFixedMemoCount == 0 {
                return fixedMemoCount
            } else if noneFixedMemoCount > 0 && fixedMemoCount > 0 {
                if section == 0 {
                    return fixedMemoCount
                } else {
                    return noneFixedMemoCount
                }
            } else {
                return noneFixedMemoCount
            }
        }
    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        cell.backgroundColor = .clear
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        setUpTitleMemoCount()
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        let background = UIView()
        background.backgroundColor = .clear
        cell.selectedBackgroundView = background
        
        cell.cntentLabel.attributedText = nil
        cell.fullContentLabel.attributedText = nil
        
        if self.searchController.isActive { // 서치바가 동작중일떄
            let row = filteredMemos[indexPath.row]
            
            cell.cntentLabel.text = row.title
            var attributedString = NSMutableAttributedString(string: row.title)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange, range: (row.title as NSString).range(of: colorText))
            cell.cntentLabel.attributedText = attributedString
            
            cell.dateLabel.text = getCorrectDateFormat(inputDate: row.date)
            
            cell.fullContentLabel.text = row.content
            attributedString = NSMutableAttributedString(string: row.title)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange, range: (row.content! as NSString).range(of: colorText))
            cell.fullContentLabel.attributedText = attributedString
        } else {
            getRow(indexPathRow: indexPath.row, IndexPathSection: indexPath.section)
            
            cell.cntentLabel.text = row.title
            cell.dateLabel.text = getCorrectDateFormat(inputDate: row.date)
            cell.fullContentLabel.text = row.content
            
            cell.cntentLabel.attributedText = NSMutableAttributedString(string: (row.title), attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.white, .kern: -1.0])
            cell.fullContentLabel.attributedText = NSMutableAttributedString(string: (row.content!), attributes: [.font: UIFont.systemFont(ofSize: 8, weight: .medium), .foregroundColor: UIColor.white, .kern: -1.0])
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Memo", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: MemoViewController.identifier) as! MemoViewController
        
        getRow(indexPathRow: indexPath.row, IndexPathSection: indexPath.section)
        vc.memo = row
        vc.CompleteActionHandler = {
            self.tabelView.reloadData()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    // 왼쪽 스와이프 동작 정의
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        getRow(indexPathRow: indexPath.row, IndexPathSection: indexPath.section)
        
        let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            
            // DB제거
            self.removeDataFromRealm(index: self.row.id)
            self.tabelView.reloadData()
            completion(true)
        }
        
        action.backgroundColor = .red
        action.image = UIImage(systemName: "trash.fill")
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    // 오른쪽 스와이프 동작 정의
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        getRow(indexPathRow: indexPath.row, IndexPathSection: indexPath.section)
        
        if !row.fixed {
            if self.getFixedMemoCountFromUserMemo() >= 5 {
                self.showToast(message: "고정메모는 5개까지만 등록이 가능합니다.")
                
                let configuration = UISwipeActionsConfiguration()
                configuration.performsFirstActionWithFullSwipe = false
                return configuration
            }
        }
        
        let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            // DB에서 favourite 값 변경
            self.getFixed(index: self.row.id)
            self.tabelView.reloadData()
            
            completion(true)
        }
        
        if row.fixed {
            action.image = UIImage(systemName: "pin.slash.fill")
        } else {
            action.image = UIImage(systemName: "pin.fill")
        }
        action.backgroundColor = .orange
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func getRow(indexPathRow: Int, IndexPathSection: Int) {
        let fixedMemoCount = self.getFixedMemoCountFromUserMemo()
        let noneFixedMemoCount = self.getNoneFixedMemoCountFromUserMemo()
        
        if noneFixedMemoCount > 0 && fixedMemoCount > 0 {
            self.fixedMemos = self.searchFixedDataFromUserMemo()
            self.noneFixedMemos = self.searchNoneFixedDataFromUserMemo()
            
            if IndexPathSection == 0 {
                self.row = self.fixedMemos[indexPathRow]
            } else {
                self.row = self.noneFixedMemos[indexPathRow]
            }
        } else {
            self.row = self.memos[indexPathRow]
        }
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    func getCorrectDateFormat(inputDate: Date) -> String{
        let calendar = Calendar.current
        let isToday = calendar.isDateInToday(inputDate)
        let formatter = DateFormatter()
        
        if isToday {
            return formatter.dateTimeFormat.string(from: inputDate)
        }
        
        let weekDay = Calendar.current.dateComponents([.weekday], from: Date()).weekday // 오늘 weekday
        let daysBetween = abs(Calendar.current.dateComponents([.day], from: inputDate, to: Date()).day!)
        
        if daysBetween <= 7 - weekDay! { // 이번주 이면
            return formatter.weekFormat.string(from: inputDate)
        } else {
            return formatter.fullDateFormat.string(from: inputDate)
        }
    }
}


//MARK: - UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func filteredContentForSearchText(_ searchText: String) {
        print(searchText)
        
        filteredMemos = searchTextFromUserMemo(text: searchText)
        
        self.tabelView.reloadData()
        colorText = searchText
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchController.searchBar.text ?? " ")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.tabelView.reloadData()
    }
}


