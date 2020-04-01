//
//  KnowWebViewController.m
//  health-regimen
//
//  Created by home on 2019/11/16.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "KnowWebViewController.h"
#import "MBProgressHUD+XMG.h"

@interface KnowWebViewController ()<KnowledgeViewControllerDelegate,WKUIDelegate,MBProgressHUDDelegate,WKNavigationDelegate>

@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) MBProgressHUD *HUB;

@end

@implementation KnowWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MBProgressHUD *HUB = [MBProgressHUD showMessage:@"玩命加载中..."];
    HUB.delegate = self;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    
}

- (void)cellClickWithURL:(NSString *)url{
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height)];
    self.webView.navigationDelegate = self;
//    self.webView.backgroundColor = [UIColor blackColor];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
    
    
}

//网页加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [MBProgressHUD hideHUD];
    
}

-(void)hudWasHidden:(MBProgressHUD *)hud{
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
