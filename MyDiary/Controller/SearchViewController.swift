//
//  SearchViewController.swift
//  MyDiary
//
//  Created by 박연배 on 2021/11/01.
//

import UIKit

class SearchViewController: UIViewController {

    
    
    //MARK: Property
    
    var diaryData = [DiaryModel]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Method
    
    func fetchData() {
        self.diaryData = MockData.data
    }
    
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: SearchTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        let data = diaryData[indexPath.row]
        
        cell.title.text = data.title
        cell.title.font = UIFont().mainFontBold
        
        cell.contentLabel.text = data.content
        cell.contentLabel.font = UIFont().mainFontLight
        
        cell.dateLabel.text = "2021. 11. 1"
        cell.dateLabel.font = UIFont().mainFontLight
        cell.dateLabel.textColor = .gray
        
        
        cell.pictureImage.image = UIImage(systemName: "star")
        cell.pictureImage.backgroundColor = .gray
        cell.pictureImage.layer.cornerRadius = 10
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
