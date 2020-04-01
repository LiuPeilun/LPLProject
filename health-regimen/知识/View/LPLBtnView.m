//
//  LPLBtnView.m
//  health-regimen
//
//  Created by home on 2019/10/27.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "LPLBtnView.h"
#import "LPLBtnItem.h"
#import "UIColor+LPLColor.h"

@interface LPLBtnView()

@property(nonatomic, strong) NSArray *array;
@property(nonatomic, weak) UILabel *label;

@end

@implementation LPLBtnView

//懒加载
- (NSArray *)array{
    if(!_array){
        
        NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LPLBtn" ofType:@"plist"]];
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *dict in arr) {
            
            LPLBtnItem *item = [LPLBtnItem itemWithDict:dict];
            [array addObject:item];
        }
        
        _array = array;
    }
    return _array;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        for (int i=0; i<self.array.count; i++) {
            
            UIButton *btn = [[UIButton alloc] init];
            UILabel *label = [[UILabel alloc] init];
            
            label.tag = i;
            btn.tag = i;
            
            [self addSubview:label];
            [self addSubview:btn];
            
            label.textAlignment = NSTextAlignmentCenter;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

//按钮点击
-(void)btnClick:(UIButton *)btn{
    
//    NSInteger tag = btn.tag;
//
//    LPLBtnItem *item = [[LPLBtnItem alloc] init];
//    item = self.array[tag];
    
    if([self.delegate respondsToSelector:@selector(btnView:btnTag:)]){
        [self.delegate btnView:self btnTag:btn.tag];
    }
    
}

//布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat space = 20;
    CGFloat spaceTop = 0;
    
    CGFloat btnW = (self.frame.size.width - (self.array.count + 1) * space)/self.array.count;
    CGFloat btnH = btnW;
    CGFloat btnX = 0;
    CGFloat btnY = spaceTop;
    
    NSInteger btnIndex = 0;
    NSInteger labelIndex = 0;
    
    CGFloat labelW = btnW;
    CGFloat labelH = 20;
    CGFloat labelX = 0;
    CGFloat labelY = btnY + btnH;
    
    UIButton *btn = [[UIButton alloc] init];
    UILabel *label = [[UILabel alloc] init];
    LPLBtnItem *item = [[LPLBtnItem alloc] init];
    for (id view in self.subviews) {
        
        if([view isKindOfClass:[UIButton class]]){
            
            btn = view;
            
            //给模型对象赋值
            item = self.array[btn.tag];
            
            //获取索引
            btnIndex = btn.tag;
            
            //按钮横坐标
            btnX = space + btnIndex * (space + btnW);
            
            //按钮frame
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            //按钮图片
            [btn setImage:[UIImage imageNamed:item.btnImage] forState:UIControlStateNormal];
//            btn.backgroundColor = [UIColor blackColor];
            
        }else if ([view isKindOfClass:[UILabel class]]){
            
            label = view;
            
            //label索引值
            labelIndex = label.tag;
            //赋值模型
            item = self.array[label.tag];
            
            //如果btn 和 label 索引值一样，让label 和 btn对齐
            
            //赋值模型
            item = self.array[label.tag];
            //label索引
            labelIndex = label.tag;
            //label横坐标
            labelX = space + labelIndex * (space + labelW);
            //label frame
            label.frame = CGRectMake(labelX, labelY, labelW, labelH);
            //label 文本
            label.text = item.btnName;
            //label 文字颜色
            label.textColor = [UIColor labelColor];
            }
        
        
    }
//    if([self.delegate respondsToSelector:@selector(btnView:height:)]){
//
//        [self.delegate btnView:self height:space * 3 + btnH + labelH];
//    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
