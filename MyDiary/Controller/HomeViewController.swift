//
//  HomeViewController.swift
//  MyDiary
//
//  Created by 박연배 on 2021/11/01.
//

import UIKit

class HomeViewController: UIViewController {

    
    //MARK: Property
    
    
    
    //MARK: Method
    
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard.init(name: "Content", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "홈"
        self.navigationController?.navigationBar.tintColor = .red
    }
    

}
