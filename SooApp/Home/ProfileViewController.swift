//
//  MainViewController.swift
//  SooApp
//
//  Created by kms on 2021/10/24.
//

import UIKit
import KakaoSDKUser

class ProfileViewController: UIViewController {

    @IBOutlet weak var nickNameLabel: UILabel!
    
    var nickName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
    navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setUI() {
        let name = UserDefaults.standard.string(forKey: "nickName")
        if let nickName = name {
            nickNameLabel.text = "\(nickName)님"
        }
    }
    
    @IBAction func logoutBtn(_ sender: UIButton) {
        let logoutAlert = UIAlertController(title: "로그아웃", message: "로그아웃하시겠습니까?", preferredStyle: .alert)
        let cancelBtn = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okBtn = UIAlertAction(title: "로그아웃", style: .default) { _ in
            UserApi.shared.logout { error in
                if let error = error {
                    print(error)
                } else {
                    print("logout() success")
                    
                    let mainSB = UIStoryboard(name: "Main", bundle: nil)
                    let startVC = mainSB.instantiateViewController(withIdentifier: "loginSB")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(startVC, animated: true)

//                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        logoutAlert.addAction(cancelBtn)
        logoutAlert.addAction(okBtn)
        
        present(logoutAlert, animated: true, completion: nil)
        
//        UserApi.shared.logout { error in
//            if let error = error {
//                print(error)
//            } else {
//                print("logout() success")
//
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
    }
    

}


