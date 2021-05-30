//
//  LoginView.m
//  LPL
//
//  Created by 徐智全 on 2021/5/29.
//

#import "LoginView.h"
#import <SMS_SDK/SMSSDK.h>
#import <MOBFoundation/MobSDK+Privacy.h>
#import "MBProgressHUD+XMG.h"

@interface LoginView()

@property(nonatomic,strong) UILabel *titleLabel;

/// 登录btn
@property(nonatomic,strong) UIButton *loginBtn;

@property(nonatomic,strong) UIImageView *bgImageView;

@property(nonatomic,strong) NSTimer *timer;



@end

@implementation LoginView

-(void)dealloc{
    
    if ([self.timer isValid]) {
        
        [self.timer invalidate];
    }
        self.timer = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layoutUI];
        self.count = 60;
    }
    return self;
}

- (void)layoutUI {
    
    //bg
    UIImageView *bgImageView = [[UIImageView alloc] init];
    self.bgImageView = bgImageView;
    [bgImageView setImage:[UIImage imageNamed:@"login_register_background"]];
    [self addSubview:bgImageView];
    
    // title
    UILabel *titleLabel = [[UILabel alloc] init];
    self.titleLabel = titleLabel;
    titleLabel.text = @"手机号登录";
    [titleLabel setFont:[UIFont systemFontOfSize:20]];
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    
    // account
    UITextField *accountTextField = [[UITextField alloc] init];
    accountTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    NSMutableDictionary *attDic = [@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[UIFont systemFontOfSize:16]} mutableCopy];
    NSMutableAttributedString *attPlace = [[NSMutableAttributedString alloc] initWithString:@"富文本修改占位文字的大小和颜色" attributes:attDic];
    accountTextField.attributedPlaceholder = attPlace;
    
    accountTextField.placeholder = @"请输入手机号";
    
    accountTextField.backgroundColor = [UIColor whiteColor];
    accountTextField.layer.cornerRadius = 5.0;
    accountTextField.textColor = [UIColor blackColor];
    self.accountTextField = accountTextField;
    [self addSubview:accountTextField];
    
    // pwd
    UITextField *pwdTextField = [[UITextField alloc] init];
    pwdTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    NSMutableDictionary *pwdDic = [@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[UIFont systemFontOfSize:16]} mutableCopy];
    NSMutableAttributedString *pwdPlace = [[NSMutableAttributedString alloc] initWithString:@"富文本修改占位文字的大小和颜色" attributes:pwdDic];
    pwdTextField.attributedPlaceholder = pwdPlace;
    
    pwdTextField.placeholder = @"请输入验证码";
    pwdTextField.backgroundColor = [UIColor whiteColor];
    pwdTextField.layer.cornerRadius = 5.0;
    self.pwdTextField = pwdTextField;
    pwdTextField.textColor = [UIColor blackColor];
    [self addSubview:pwdTextField];
    
    // 验证码
    UIButton *identifyBtn = [[UIButton alloc] init];
    self.identifyBtn = identifyBtn;
    [identifyBtn addTarget:self action:@selector(identifyAction) forControlEvents:UIControlEventTouchUpInside];
    [identifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [identifyBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    identifyBtn.titleLabel.textColor = [UIColor whiteColor];
    
    UIImage *normalImage = [UIImage imageNamed:@"loginBtnBg"];
    [normalImage resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1) resizingMode:UIImageResizingModeStretch];
    UIImage *highLightedImage = [UIImage imageNamed:@"loginBtnBgClick"];
    highLightedImage = [highLightedImage stretchableImageWithLeftCapWidth:highLightedImage.size.width / 2 topCapHeight:highLightedImage.size.height / 2];
    [identifyBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [identifyBtn setBackgroundImage:highLightedImage forState:UIControlStateHighlighted];
    identifyBtn.layer.cornerRadius = 5.0;
    [self addSubview:identifyBtn];
    
    // login
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn = loginBtn;
    self.loginBtn.backgroundColor = [UIColor redColor];
    loginBtn.layer.cornerRadius = 10.0;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self addSubview:loginBtn];
    
}

- (void)layoutSubviews {
    
    self.bgImageView.frame = self.bounds;
    
    self.titleLabel.center = CGPointMake(self.center.x, self.center.y * 0.3);
    [self.titleLabel sizeToFit];
    
    self.accountTextField.center = CGPointMake(self.titleLabel.center.x, self.titleLabel.center.y + self.titleLabel.bounds.size.height * 3);
    
    CGFloat accountW = self.bounds.size.width * 0.6;
    CGFloat accountH = 40;
    self.accountTextField.bounds = CGRectMake(0, 0, accountW, accountH);
    
    
    CGFloat pwdCenterX = self.accountTextField.center.x * 0.77;
    self.pwdTextField.center = CGPointMake(pwdCenterX , self.accountTextField.center.y + self.accountTextField.bounds.size.height * 2);
    
    CGFloat pwdTextFieldW = self.accountTextField.bounds.size.width * 0.6;
    CGFloat pwdTextFieldH = 40;
    self.pwdTextField.bounds = CGRectMake(0, 0, pwdTextFieldW, pwdTextFieldH);
    
    
    CGFloat identifyBtnCenterX = self.accountTextField.center.x * 1.4;
    CGFloat identifyBtnCenterY = self.pwdTextField.center.y;
    self.identifyBtn.center = CGPointMake(identifyBtnCenterX, identifyBtnCenterY);
    [self.identifyBtn sizeToFit];
    
    CGFloat loginBtnW = self.bounds.size.width * 0.6;
    CGFloat loginBtnH = 45;
    
    self.loginBtn.center = CGPointMake(self.center.x, self.center.y * 1.5);
    self.loginBtn.bounds = CGRectMake(0, 0, loginBtnW, loginBtnH);
}

/// 点击验证码按钮调用
- (void)identifyAction {
    
    if ([self.accountTextField.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入手机号!"];
        return;
    }
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.accountTextField.text zone:@"86" template:nil result:^(NSError *error) {
        
        if(error){
            [MBProgressHUD showError:@"手机号输入有误，请重新输入!"];
            return;
        }
        
        if (self.timer == nil) {
            self.timer = [NSTimer timerWithTimeInterval:1 target:self  selector:@selector(countDown) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
            [self.timer setFireDate:[NSDate distantPast]];
            self.identifyBtn.enabled = NO;
        }
        
    }];
    
    
}

/// 倒计时方法
- (void)countDown{
    
    NSString *title = [NSString stringWithFormat:@"%lds",self.count];
    [self.identifyBtn setTitle:title forState:UIControlStateNormal];
    
    // 此处条件如果设为== 可能会导致计时为负数
    if (self.count <= 0) {
        
        self.identifyBtn.enabled = YES;
        [self.timer setFireDate:[NSDate distantFuture]];
        self.timer = nil;
        [self.identifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    
    self.count--;
}


/// 点击登录按钮
- (void)loginBtnClick {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginBtnClick" object:nil];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.accountTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
}


@end
