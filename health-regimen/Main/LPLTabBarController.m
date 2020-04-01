//
//  LPLTabBarController.m
//  health-regimen
//
//  Created by home on 2019/10/21.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "LPLTabBarController.h"
#import "LPLNavigationController.h"
#import "VideoTableViewController.h"
#import "SelfTableViewController.h"
#import "MainViewController.h"
#import "KnowledgeViewController.h"
#import "SelfTableViewCell.h"
#import "UIColor+LPLColor.h"
#import "LPLTabBarView.h"

@interface LPLTabBarController ()

@property(nonatomic, assign) NSInteger didSelectedIndex;
//@property(nonatomic, strong) NSMutableArray *item;

@end

@implementation LPLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //文字位置
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -5)];

    //导航栏字体颜色
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    [self setUpAllChildController];
    
    [[UITabBar appearance] setBarTintColor:[UIColor tabBarColor]];
    [UITabBar appearance].translucent = NO;
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"switch" object:nil];
}

-(void)notice:(NSNotification *) notification{
    
    NSString *isOn = notification.userInfo[@"isOn"];
    if([isOn isEqualToString:@"YES"]){
        //强制改变颜色模式
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    }else{
        //强制改变颜色模式
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.tabBar.frame = CGRectMake(0, self.tabBar.frame.origin.y - 5, self.view.frame.size.width, 54);
    
    //文字位置
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -5)];
}


-(void)setUpAllChildController{
    
    //主页
    MainViewController *mainVC = [[MainViewController alloc] init];
    [self setUpChildController:mainVC title:@"主页" image:[UIImage imageNamed:@"barBtn_1"] selectImage:[UIImage imageNamed:@"barBtn_1"]];
    
    //视频
    VideoTableViewController *videoVC = [[VideoTableViewController alloc] init];
    [self setUpChildController:videoVC title:@"视频" image:[UIImage imageNamed:@"barBtn_2"] selectImage:[UIImage imageNamed:@"barBtn_2"]];
    
    //知识
    KnowledgeViewController *knowledgeVC = [[KnowledgeViewController alloc] init];
    [self setUpChildController:knowledgeVC title:@"知识" image:[UIImage imageNamed:@"barBtn_3"] selectImage:[UIImage imageNamed:@"barBtn_3"]];
    
    //个人
    SelfTableViewController *selfVC = [[SelfTableViewController alloc] init];
    [self setUpChildController:selfVC title:@"个人" image:[UIImage imageNamed:@"barBtn_4"]  selectImage:[UIImage imageNamed:@"barBtn_4"]];
    
}

-(void)setUpChildController:(UIViewController *)vc title:(NSString *)title image:(UIImage *)image selectImage:(UIImage *)selectImage{
    
    //创建导航控制器
    LPLNavigationController *navVC = [[LPLNavigationController alloc] initWithRootViewController:vc];
    
    
    //设置导航栏标题
    vc.navigationItem.title = title;
    
    //设置item按钮选中图片
    vc.tabBarItem.selectedImage = selectImage;
    
    //设置item按钮默认图片
    vc.tabBarItem.image = image;
    
//    [self.item addObject:vc.tabBarItem];
    
    vc.tabBarItem.title = title;
    
    //将NavigationController添加到TabBarController上
    [self addChildViewController:navVC];
    
}

#pragma mark - UITabBarDelegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    NSInteger index = [tabBar.items indexOfObject:item];
    
    if(self.didSelectedIndex < index){
        //设置切换界面的动画效果
           CATransition *animate = [CATransition animation];
           
           //设置动画类型
           /*
            fade 渐变
            moveIn 覆盖
            push 推出
            reveal 揭开
            cube 立方体旋转
            suckEffect 收缩动画
            onlFlip 跳转
            rippleEffect 水波动画
            pageCurl 页面揭开
            pageUnCurl 放下页面
            cameralrisHollowOpen 镜头打开
            cameralrisHollowClose 镜头关闭
            */
           animate.type = @"fade";
           
           //设置动画子类型，控制方向
           animate.subtype = kCATransitionFromRight;
           
           //设置动画时间
           animate.duration = 0.2;
           
           [animate setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
           
           //添加动画效果
           [self.view.layer addAnimation:animate forKey:nil];
    }else if (self.didSelectedIndex > index){
        //设置切换界面的动画效果
           CATransition *animate = [CATransition animation];
           
           //设置动画类型
           animate.type = @"fade";
           
           //设置动画子类型，控制方向
           animate.subtype = kCATransitionFromLeft;
           
           //设置动画时间
           animate.duration = 0.2;
           
           [animate setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
           
           //添加动画效果
           [self.view.layer addAnimation:animate forKey:nil];
    }
    self.didSelectedIndex = index;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"switch" object:self];
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
