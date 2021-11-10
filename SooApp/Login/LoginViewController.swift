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
import GoogleSignIn
import Firebase

class LoginViewController: UIViewController {
        
    @IBOutlet weak var googleLoginBtn: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hadtoken()
        GIDSignIn.sharedInstance()?.presentingViewController = self // 로그인화면 불러오기
        GIDSignIn.sharedInstance()?.restorePreviousSignIn() // 자동로그인
        googleLoginBtn.style = .wide
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
    
    @IBAction func googleLoginBtn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
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

//extension LoginViewController: GIDSignInDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let authentication = user.authentication {
//            print("\(authentication)")
//        }
//    }
//}
