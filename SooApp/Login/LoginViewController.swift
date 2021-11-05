//
//  ViewController.swift
//  SooApp
//
//  Created by kms on 2021/10/24.
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hadtoken()
    }

    private func hadtoken() {
        // 토큰검사
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let tokenError = error as? SdkError, tokenError.isInvalidTokenError() == true {
                } else {
                    print("Error")
                }
            } else {
                self.getUserInfo()
                }
            }
        } else {
            print("login")
        }
    }
    
    @IBAction func kakaoLoginBtn(_ sender: UIButton) {
        kakaoLogin()
    }
    
}

extension LoginViewController {
    
    // 유저 정보 가져오기
    private func getUserInfo() {
        
        UserApi.shared.me() { (user, error) in
            if let error = error {
                print(error)
            } else {
                print("me() success")
                
                let nickname = user?.kakaoAccount?.profile?.nickname
                let email = user?.kakaoAccount?.email
                
                UserDefaults.standard.set(nickname, forKey: "nickName")
                UserDefaults.standard.set(email, forKey: "email")
                
                let HomeSB = UIStoryboard(name: "Home", bundle: nil)
                
                let nextVC = HomeSB.instantiateViewController(withIdentifier: "HomeTab")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(nextVC, animated: true)
                
//                nextVC.nickName = nickname
                
//                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    private func kakaoLogin() {
        
        // 카카오톡 웹 브라우저 연결
        UserApi.shared.loginWithKakaoAccount { (oAuthToken, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoTalk() success")
                
                _ = oAuthToken
                
                self.getUserInfo()
            }
        }
        
//        카카오톡 직접 연결 방식
//        if (UserApi.isKakaoTalkLoginAvailable()) {
//            UserApi.shared.loginWithKakaoAccount { (oAuthToken, error) in
//                if let error = error {
//                    print(error)
//                } else {
//                    print("loginWithKakaoTalk() success")
//                    _ = oAuthToken
//                }
//            }
//        }
    }
    
}
