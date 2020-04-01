//
//  ViewController.m
//  runtime字典转模型
//
//  Created by 312 on 2019/12/7.
//  Copyright © 2019 Lun. All rights reserved.
//

#import "ViewController.h"
#import "StatusItem.h"
#import "NSObject+Property.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"status" ofType:@"plist"]];
    
    StatusItem *item = [StatusItem modelWithDict:dictionary];
}


@end
