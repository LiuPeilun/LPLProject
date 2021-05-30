//
//  LoginViewController.m
//  health-regimen
//
//  Created by home on 2021/4/6.
//  Copyright © 2021 lpl. All rights reserved.
//

#import "LoginViewController.h"
#import "LPLTabBarController.h"
#import "MainViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import <MOBFoundation/MobSDK+Privacy.h>
#import "LoginView.h"
#import "MBProgressHUD+XMG.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextFiled;
@property(nonatomic, copy) NSString *number;


@end

@implementation LoginViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (LoginView *)loginView {
    if (_loginView == nil) {
        _loginView = [[LoginView alloc] init];
        _loginView.frame = self.view.bounds;
    }
    return _loginView;
}

/// 登录按钮
- (void)loginAction {
    
    [SMSSDK commitVerificationCode:self.loginView.pwdTextField.text phoneNumber:self.loginView.accountTextField.text zone:@"86" result:^(NSError *error) {
        
        if(error){
            
            [self identifyError];
            
        } else {
            
            LPLTabBarController *tabBarVC = [[LPLTabBarController alloc] init];
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            if (window) {
                window.rootViewController = tabBarVC;
                [window makeKeyAndVisible];
            }
            
            self.loginView.count = 60;
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.loginView];

    [MobSDK uploadPrivacyPermissionStatus:YES onResult:^(BOOL success) {
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginAction) name:@"loginBtnClick" object:nil];
    
}

- (void)identifyError {
    [MBProgressHUD showError:@"验证码输入有误，请重新输入!"];
}

@end
