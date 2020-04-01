//
//  BoxViewController.m
//  健康养生
//
//  Created by B04 on 2019/10/24.
//  Copyright © 2019年 B04. All rights reserved.
//

#import "BoxViewController.h"
#import "BoxItem.h"
#import "LPLBtnView.h"
#import "BoxView.h"
#import "HtmlItem.h"
#import "ToolsViewController.h"
#import "UIColor+LPLColor.h"

@interface BoxViewController ()<BoxViewDelegate>

//@property(nonatomic, strong)WKWebView *webView;
@property(nonatomic, strong) BoxView *boxView;
//@property(nonatomic, strong) NSArray *array;

@end

@implementation BoxViewController
- (BoxView *)boxView{
    if(_boxView == nil){
        _boxView = [[BoxView alloc ] initWithFrame:CGRectMake(0,self.view.frame.origin.y, self.view.bounds.size.width, self.view.frame.size.height)];
    }
    return _boxView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //让控制器的view的大小计算在导航栏以下，tabBar以上
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //让控制器的view的x大小计算在导航栏以下，一直到屏幕底部
//    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.title = @"百宝箱";

}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.boxView.backgroundColor = [UIColor cellColor];
    
    [self.view addSubview:self.boxView];
    self.boxView.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)boxView:(BoxView *)boxView tag:(NSInteger)tag title:(nonnull NSString *)title{
    
    ToolsViewController *toolsVC = [[ToolsViewController alloc] init];
           
    self.delegate = toolsVC;
    
    if([self.delegate respondsToSelector:@selector(toolsWithTag:title:)]){
        [self.delegate toolsWithTag:tag title:title];
        
        [self.navigationController pushViewController:toolsVC animated:YES];
    }
    
    
    
//    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//
//    [self.view addSubview:self.webView];
//
//    HtmlItem *item = [[HtmlItem alloc] init];
//    item = self.array[tag];
//
//    NSString *path = [[NSBundle mainBundle] pathForResource:item.fileName ofType:nil inDirectory:@"Tools"];
//    NSURL *url = [NSURL fileURLWithPath:path];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//
//    [self.webView loadRequest:request];
    
    
    
//    NSURL *url = [[NSBundle mainBundle] URLForResource:item.fileName withExtension:nil];
//    NSURL *url = [[NSBundle mainBundle] URLForResource:item.fileName withExtension:nil];
//    NSLog(@"%@", item.fileName);
//    NSLog(@"%@", url);
    
    //用safri浏览器加载html文件
//    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    
    
    
    
    
}


@end
