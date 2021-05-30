//
//  LoginView.h
//  LPL
//
//  Created by 徐智全 on 2021/5/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginView : UIView

/// 获取验证码按钮
@property(nonatomic,strong) UIButton *identifyBtn;

/// 账号textField
@property(nonatomic,strong) UITextField *accountTextField;

/// 密码textField
@property(nonatomic,strong) UITextField *pwdTextField;


/// 倒计时60s
@property(nonatomic, assign) NSInteger count;

@end

NS_ASSUME_NONNULL_END
