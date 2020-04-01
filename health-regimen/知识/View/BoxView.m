//
//  BoxView.m
//  health-regimen
//
//  Created by home on 2019/10/27.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "BoxView.h"
#import "BoxItem.h"

@interface BoxView()

@property(nonatomic, strong)NSArray *array;
@property(nonatomic, weak)UIButton *btn;
@property(nonatomic, weak) UILabel *label;

@end

@implementation BoxView

//懒加载
- (NSArray *)array{
    if(!_array){
        //读取plist文件
        NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tools" ofType:@"plist"]];
        
        NSMutableArray *MutableArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            BoxItem *item = [BoxItem initWithDict:dic];
            
            [MutableArr addObject:item];
        }
        _array = MutableArr;
    }
    
    return _array;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        for(int i = 0; i<self.array.count; i++){
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = i;
        
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:btn];
            
            UILabel *label = [[UILabel alloc] init];
            label.tag = i;
            
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            
            NSLog(@"%f", self.frame.size.height);
        }
        
    }
    return self;
}

-(void)btnClick:(UIButton *)btn{
    
    BoxItem *item = [[BoxItem alloc] init];
    item = self.array[btn.tag];
    
    if([self.delegate respondsToSelector:@selector(boxView:tag:title:)]){
        
        [self.delegate boxView:self tag:btn.tag title:item.title];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];

    //边框宽度
    CGFloat borderW = self.frame.size.width/3;
    CGFloat borderH = self.frame.size.height/5;
    
    //按钮行数
    CGFloat rowBtn = 0;
    //按钮宽高
    CGFloat btnW = self.frame.size.width/6;
    CGFloat btnH = btnW;

    //label高
    CGFloat labelH = 20;
    //label行数
    CGFloat rowLabel = 0;
    
    //按钮和文字间距
    CGFloat space = 10;
    
    NSLog(@"%lu", self.array.count);
    
    //创建模型
    BoxItem *item = [[BoxItem alloc] init];
        
    for (id child in self.subviews) {
        
        if([child isKindOfClass:[UIButton class]]){
            
            self.btn = child;
            
            item = self.array[self.btn.tag];
                       
            if(self.btn.tag%3 == 0 && self.btn.tag!=0){
                rowBtn += 1;
            }
            
            //列数
            CGFloat col = self.btn.tag % 3;
            
            //btn
            CGFloat x = (borderW - btnW)/2 + borderW * col;
            CGFloat y = (borderH - btnH) *1/10 + rowBtn * borderH ;
            
            //设置大小
            self.btn.frame = CGRectMake(x, y, btnW, btnH);
           
            //设置按钮图片
            [self.btn setImage:[UIImage imageNamed:item.icon] forState:UIControlStateNormal];
        }else{
            
            //label
            CGFloat labelW = self.frame.size.width/3;
            
            self.label = child;
            
            item = self.array[self.label.tag];
                
            if(self.label.tag%3 == 0 && self.label.tag!=0){
                rowLabel += 1;
                
                NSLog(@"%f", rowLabel);
            }
            
            //列数
            CGFloat col = self.label.tag % 3;
            
            //label
            CGFloat labelX = col * labelW;
            CGFloat labelY = (borderH - btnH) *1/10 + btnH + space + rowLabel * borderH ;
            
            self.label.frame = CGRectMake(labelX, labelY, labelW, labelH);
            
            self.label.text = item.title;
        }
        
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
