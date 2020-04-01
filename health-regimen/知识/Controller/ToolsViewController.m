//
//  ToolsViewController.m
//  health-regimen
//
//  Created by home on 2019/11/16.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "ToolsViewController.h"
#import "BoxViewController.h"
#import "HtmlItem.h"

@interface ToolsViewController ()<BoxViewControllerDelegate>

@property(nonatomic, strong)WKWebView *webView;
@property(nonatomic, strong) NSArray *array;

@end

@implementation ToolsViewController
//懒加载
- (NSArray *)array{
    if(!_array){
        _array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Html" ofType:@"plist"]];
        
        NSMutableArray *array = [NSMutableArray array];
        for(NSDictionary *dict in _array){
            HtmlItem *item = [[HtmlItem alloc] initWithDict:dict];
            
            [array addObject:item];
        }
        _array = array;
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)toolsWithTag:(NSInteger)tag title:(NSString *)title{
    
    self.navigationItem.title = title;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:self.webView];
    
    HtmlItem *item = [[HtmlItem alloc] init];
    item = self.array[tag];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:item.fileName ofType:nil inDirectory:@"Tools"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
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
