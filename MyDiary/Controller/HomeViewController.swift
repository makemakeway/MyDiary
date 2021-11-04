//
//  HomeViewController.swift
//  MyDiary
//
//  Created by 박연배 on 2021/11/01.
//

import UIKit

class HomeViewController: UIViewController {

    
    //MARK: Property
    
    
    @IBOutlet weak var homeTabBar: UITabBarItem!
    @IBOutlet weak var navItem: UINavigationItem!
    
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
        self.title = LocalizableStrings.tab_home.localized
        self.tabBarController?.tabBar.items![1].title = LocalizableStrings.tab_search.localized
        self.tabBarController?.tabBar.items![2].title = LocalizableStrings.tab_calendar.localized
        self.tabBarController?.tabBar.items![3].title = LocalizableStrings.tab_setting.localized
    }
    

    
    
}
