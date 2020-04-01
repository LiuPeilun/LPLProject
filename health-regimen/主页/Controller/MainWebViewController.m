//
//  MainWebViewController.m
//  health-regimen
//
//  Created by home on 2019/11/16.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "MainWebViewController.h"
#import "MainViewController.h"

#import "MBProgressHUD+XMG.h"
#import "UIColor+LPLColor.h"

@interface MainWebViewController ()<MainViewControllerDelegate,MBProgressHUDDelegate,WKNavigationDelegate>

@property(nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) NSInteger cellTag;

@end

@implementation MainWebViewController

//static NSInteger n = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MBProgressHUD *HUB = [MBProgressHUD showMessage:@"玩命加载中..."];
    HUB.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)cellClickWithURL:(NSString *)url cellTag:(NSInteger)tag{
//    NSLog(@"%lu----------self.cellTag", self.cellTag);
//    NSLog(@"%lu----------tag", tag);
//
//    //如果cellTag为空，则是第一次加载网页
//    if(!self.cellTag){
//        //将点击的cell行号记录下来
//        self.cellTag = tag;
//
//        //如果cellTag不为空，则是第二次进入同一个网页或者进入其他网页
//    }else{
//        //相等，代表第二次点击cell加载的网页和上一次相同
//        if(self.cellTag == tag){
//
//            //不相等，这次点击的cell加载的网页和上一次不相同
//        }else{
//            n = 0;
//        }
//        self.cellTag = tag;
//    }
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height + 50)];
    self.webView.navigationDelegate = self;
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
    
}

//网页加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [MBProgressHUD hideHUD];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"switch" object:nil];
    
    
}

-(void)notice:(NSNotification *) notification{
    
    NSString *isOn = notification.userInfo[@"isOn"];
    if([isOn isEqualToString:@"YES"]){
        //网页切换夜间模式
        self.webView.opaque = NO;
        self.webView.backgroundColor = [UIColor cellColor];
        
    }else{
        //网页切换到日间模式
        self.webView.opaque = NO;
        self.webView.backgroundColor = [UIColor cellColor];
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
    hud = nil;
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
