//
//  CollectionViewController.m
//  health-regimen
//
//  Created by 312 on 2019/11/17.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "CollectionViewController.h"
#import "UIColor+LPLColor.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cellColor];
    [self setUpImage];
}

-(void)setUpImage{
    
    UIImage *image = [UIImage imageNamed:@"C-NEmptyView_106x106_"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width/3, self.view.frame.size.width/3);
    imageView.center = self.view.center;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(self.view.frame.size.width/2 - 40, self.view.frame.size.height/2 + self.view.frame.size.width/6, 80, 20);
    label.text = @"暂无数据";
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:label];
    [self.view addSubview:imageView];
    
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
