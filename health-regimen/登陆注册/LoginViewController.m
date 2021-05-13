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

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextFiled;
@property(nonatomic, copy) NSString *number;


@end

@implementation LoginViewController

//手机号输入框
- (IBAction)phoneNumber:(UITextField *)sender {
    
    
}

//验证码输入框
- (IBAction)code:(UITextField *)sender {
    
    
}

//获取验证码按钮
- (IBAction)codeClick:(UIButton *)sender {
    
    NSLog(@"11--------------");
    //获取验证码
    /*
     SMSGetCodeMethodSMS为短信验证码
     SMSGetCodeMethodVoice为语音验证码
     zone :地区号，填86即可
     */
    NSLog(@"self.phoneNumberTextFiled.text :%@", self.phoneNumberTextFiled.text);
    NSLog(@"self.number :%@", self.number);
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneNumberTextFiled.text zone:@"86" template:nil result:^(NSError *error) {
        
        if(error){
            NSLog(@"手机号输入有误");
        }
    }];
}

//登陆按钮
- (IBAction)loginClick:(UIButton *)sender {
    
    LPLTabBarController *tabBarVC = [[LPLTabBarController alloc] init];
    //    MainViewController *mainVC = [[MainViewController alloc] init];
        
        //满屏弹出
        tabBarVC.modalPresentationStyle = 0;
        [self presentViewController:tabBarVC animated:NO completion:nil];
    
//    [SMSSDK commitVerificationCode:self.codeTextField.text phoneNumber:self.phoneNumberTextFiled.text zone:@"86" result:^(NSError *error) {
//        if(error){
//            NSLog(@"验证码输入错误");
//        }else{
//            
//            LPLTabBarController *tabBarVC = [[LPLTabBarController alloc] init];
//            //    MainViewController *mainVC = [[MainViewController alloc] init];
//                
//                //满屏弹出
//                tabBarVC.modalPresentationStyle = 0;
//                [self presentViewController:tabBarVC animated:NO completion:nil];
//        }
//    }];
    
    
}


//-(void)textFiledDidChange:(UITextField*) sender{
//
//    self.number = sender.text;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [MobSDK uploadPrivacyPermissionStatus:YES onResult:^(BOOL success) {
    }];
    
    NSLog(@"aaaaaa");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
