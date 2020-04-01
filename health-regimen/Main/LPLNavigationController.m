//
//  LPLNavigationController.m
//  health-regimen
//
//  Created by home on 2019/10/21.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "LPLNavigationController.h"
#import "UIColor+LPLColor.h"

@interface LPLNavigationController ()

@end

@implementation LPLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置navigationController的view的位置
    //这一步是让view在导航栏下面，tabBar上面
//    self.edgesForExtendedLayout = UIRectEdgeNone;   //edgesForExtendedLayout
    
//    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //translucent = yes时，self.view起点是从导航栏左上角计算的，no的时候起点是葱花导航栏左下角计算的
    self.navigationController.navigationBar.translucent = NO;
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
}

//初始化类的时候调用（调用一次）
+ (void)initialize
{
    if (self == [LPLNavigationController class]) {
        
        UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[LPLNavigationController class]]];
        
        bar.barTintColor = [UIColor navigationBarColor];//[UIColor colorWithRed:66/255.0 green:192/255.0 blue:16/255.0 alpha:1];
        [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:22]}];
        
        
    }
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
