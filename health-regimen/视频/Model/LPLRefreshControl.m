//
//  LPLRefreshControl.m
//  health-regimen
//
//  Created by home on 2019/12/1.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "LPLRefreshControl.h"

@implementation LPLRefreshControl

-(void)beginRefreshing{
    [super beginRefreshing];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void)endRefreshing{
    [super endRefreshing];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
