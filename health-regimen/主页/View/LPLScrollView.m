//
//  LPLScrollView.m
//  health-regimen
//
//  Created by home on 2019/10/25.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "LPLScrollView.h"
#import "LBItem.h"

@interface LPLScrollView()

@property(nonatomic, weak) UIImageView *imageV;
@property(nonatomic, strong) NSArray *array;
@property(nonatomic, weak) UIImageView *imageVOne;
@property(nonatomic, weak) UIImageView *imageVLast;

@end

@implementation LPLScrollView
//懒加载
- (NSArray *)array{
    if(!_array){
        _array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LB" ofType:@"plist"]];
        
        NSMutableArray *array = [NSMutableArray array];
        for(NSDictionary *dict in _array){
            LBItem *item = [[LBItem alloc] initWithDict:dict];
            
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
        
        self.pagingEnabled = YES;
        
        //第一张图片(显示的是最后一张)
        UIImageView *imageV = [[UIImageView alloc] init];
        [self addSubview:imageV];
        self.imageVOne = imageV;
        
        for (int i=0; i<4; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [self addSubview:imageView];
            
            imageView.tag = i;
//            imageView.backgroundColor = [UIColor orangeColor];
            
            //设置imageView的交互属性
            imageView.userInteractionEnabled = YES;
            
            self.imageV = imageView;
        }
        
        //最后一张图片(显示的是第一张)
        UIImageView *imageV1 = [[UIImageView alloc] init];
        [self addSubview:imageV1];
        self.imageVLast = imageV1;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //计算位置尺寸
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat x = 0;
    CGFloat y = 0;
    
    LBItem *item = [[LBItem alloc] init];
    item = [self.array lastObject];
    
    self.imageVOne.frame = CGRectMake(0, 0, width, height);
    self.imageVOne.image = [UIImage imageNamed:item.imageName];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    for (id child in self.subviews) {
        
        if([child isKindOfClass:[UIImageView class]] && child != self.imageVOne && child != self.imageVLast){
        
            imageView = child;
            
            x = (imageView.tag + 1) * width;
            item = self.array[imageView.tag];
            
//            NSLog(@"%f", x);
//            NSLog(@"%lu---------imageView.tag", imageView.tag);
            
            imageView.frame = CGRectMake(x, y, width, height);
            imageView.image = [UIImage imageNamed:item.imageName];
            
            if(imageView.tag + 1 == self.array.count){
                
                //模型获取数据
                item = [self.array firstObject];
                x = width * (self.array.count + 1);
                //设置图片属性
                self.imageVLast.frame = CGRectMake(x, y, width, height);
                self.imageVLast.image = [UIImage imageNamed:item.imageName];
            }
        }
        
    }
//    self.imageV.frame = CGRectMake(x, y, width, height);
//    self.imageV.image = [UIImage imageNamed:@""];
}


@end
