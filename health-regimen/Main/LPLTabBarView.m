//
//  LPLTabBarView.m
//  health-regimen
//
//  Created by home on 2019/11/12.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "LPLTabBarView.h"

@interface LPLTabBarView()

@property(nonatomic, weak) UIButton *selBtn;

@end

@implementation LPLTabBarView

- (void)setItem:(NSArray *)item{
    
    _item = item;
    
    for (int i=0; i<self.item.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        UITabBarItem *item = self.item[i];
        
        [self addSubview:btn];
        [btn setImage:item.image forState:UIControlStateNormal];
        [btn setImage:item.selectedImage forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//监听点击方法
-(void)btnClick:(UIButton *)btn{
    
    if(self.selBtn == btn){
        self.selBtn.selected = YES;
    }else{
        
        self.selBtn.selected = NO;
        btn.selected = YES;
        self.selBtn = btn;
    }
    
    if([self.delegate respondsToSelector:@selector(tabBar:index:)]){
        [self.delegate tabBar:self index:btn.tag];
    }
}

//显示tabbar
- (void)showTabBar{
    self.alpha = 1;
}

//隐藏tabbar
- (void)hideTabBar{
    self.alpha = 0;
}

- (void)layoutSubviews{
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = self.frame.size.width / self.subviews.count;
    CGFloat btnH = self.frame.size.height;
    
    for (UIButton *btn in self.subviews) {
        
        btnX = btn.tag * btnW;
        
        if(btn.tag == 0){
            btn.selected = YES;
            self.selBtn = btn;
        }
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

@end
