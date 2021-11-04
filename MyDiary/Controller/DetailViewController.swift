//
//  DetailViewController.swift
//  MyDiary
//
//  Created by 박연배 on 2021/11/04.
//

import UIKit

class DetailViewController: UIViewController {

    
    //MARK: Property
    
    var diary: DiaryModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    //MARK: Method
    
    func tableViewConfig() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: DetailTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: DetailTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfig()
        // Do any additional setup after loading the view.
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier) as? DetailTableViewCell else {
            return UITableViewCell()
        }
        guard let data = diary else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = data.title
        cell.contentLabel.text = data.content
        cell.pictureImage.image = data.image
        
        return cell
    }
}
