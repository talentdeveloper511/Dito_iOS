//
//  ContainerViewController.swift
//  iPaths
//
//  Created by Lebron on 3/26/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit
import SideMenu

class ContainerViewController: UIViewController  , UISideMenuNavigationControllerDelegate{
    @IBOutlet weak var navigationbar: UINavigationBar!
    
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenu()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    fileprivate func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftSideMenuViewController") as? UISideMenuNavigationController
        SideMenuManager.default.menuRightNavigationController = nil
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.menuAddPanGestureToPresent(toView: (self.navigationbar)!)
        //        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuPresentMode = .menuSlideIn
    }
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        if let vc = menu.topViewController as? LeftSideViewController {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            switch (vc.selectedId)
            {
            case 0:
                if self.childViewControllers.count > 0{
                    let viewControllers:[UIViewController] = self.childViewControllers
                    for viewContoller in viewControllers{
                        viewContoller.willMove(toParentViewController: nil)
                        viewContoller.view.removeFromSuperview()
                        viewContoller.removeFromParentViewController()
                    }
                }
                
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                addChildViewController(mainViewController)
                containerView.addSubview(mainViewController.view)
                break;
            case 1:
                let trackViewController = storyboard.instantiateViewController(withIdentifier: "TrackViewController") as! TrackViewController
                addChildViewController(trackViewController)
                containerView.addSubview(trackViewController.view)
                break;
            case 2:
                let creditViewController = storyboard.instantiateViewController(withIdentifier: "CreditViewController") as! CreditViewController
                addChildViewController(creditViewController)
                containerView.addSubview(creditViewController.view)
                break;
            case 3:
                let favViewController = storyboard.instantiateViewController(withIdentifier: "FavorViewController") as! FavorViewController
                addChildViewController(favViewController)
                containerView.addSubview(favViewController.view)
                break;
            case 4:
                let historyViewController = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
                addChildViewController(historyViewController)
                containerView.addSubview(historyViewController.view)
                break;
            case 5:
                let contactViewController = storyboard.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
                addChildViewController(contactViewController)
                containerView.addSubview(contactViewController.view)
                break;
            case 6:
                // Instantiate View Controller
                let faqViewController = storyboard.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
                addChildViewController(faqViewController)
                containerView.addSubview(faqViewController.view)

                break;
            case 7:
                let myCartViewController = storyboard.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
                addChildViewController(myCartViewController)
                containerView.addSubview(myCartViewController.view)
                break;
            case 8:
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(nextViewController, animated:true, completion:nil)
                UserDefaults.standard.set("", forKey:"user_id")
                UserDefaults.standard.set(false, forKey:Constants.IS_LOGIN)
                break;
            case 100:
                
                let user_type = UserDefaults.standard.string(forKey: "user_type")
                if(user_type?.count == 4){
                    let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileEditViewController") as! ProfileEditViewController
                    addChildViewController(profileViewController)
                    containerView.addSubview(profileViewController.view)
                }
                else{
                    let corporateViewController = storyboard.instantiateViewController(withIdentifier: "CorporateProfileViewController") as! CorporateProfileViewController
                    addChildViewController(corporateViewController)
                    containerView.addSubview(corporateViewController.view)
                }
                break
                

                
                
            default:
                break;
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
