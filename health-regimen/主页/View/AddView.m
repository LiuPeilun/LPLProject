//
//  AddView.m
//  health-regimen
//
//  Created by home on 2019/10/24.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "AddView.h"
#import "ChooseBtnItem.h"
#import "UIColor+LPLColor.h"

@interface AddView()

@property(nonatomic, strong) NSArray *array;
@property(nonatomic, strong) UIButton *button;
@property(nonatomic, strong) NSMutableArray *btnSelectedArr;

@end

@implementation AddView

//懒加载
- (NSMutableArray *)btnSelectedArr{
    if(!_btnSelectedArr){
        //文件路径
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"BtnSelected.txt"];

        //读取文件
        NSMutableArray *mArr = [NSMutableArray arrayWithContentsOfFile:fullPath];
//        NSLog(@"%@", mArr);
        _btnSelectedArr = mArr;
    }

    return _btnSelectedArr;
}

- (UIButton *)button{
    if(!_button){
        _button = [[UIButton alloc] init];

    }
    return _button;
}

//懒加载
- (NSArray *)array{
    if(!_array){

        NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Channels" ofType:@"plist"]];

        NSMutableArray *array = [NSMutableArray array];
        for (NSMutableDictionary *dic in arr) {
            ChooseBtnItem *item = [ChooseBtnItem initWithDict:dic];
            [array addObject:item];
        }

        _array = array;
        
//        NSLog(@"%lu", array.count);
    }

    return _array;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
//        NSLog(@"%@". self.btnArr);
        
        if(self.btnSelectedArr == nil){
        
            for(int i = 0; i<self.array.count; i++){
                //创建按钮
                UIButton *btn = [[UIButton alloc] init];
                
                //为按钮设置tag值
                btn.tag = i;
                
                //添加监听
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                self.button = btn;
                
                //添加按钮
                [self addSubview:self.button];
                
            }
            
        }else{//不是第一次进入这个界面的时候，在这里创建按钮
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            //判断选中状态布尔变量
            NSNumber *selected = nil;
            BOOL isSelected = nil;
            
            //按钮tag值
            NSNumber *tag1 = nil;
            NSInteger tag = 0;
            
//            NSLog(@"%lu++++++++++++++++++", self.btnSelectedArr.count);
            for(int i=0; i<self.btnSelectedArr.count; i++){
                
                //创建按钮
                UIButton *btn = [[UIButton alloc] init];
                
                //字典接收数组中数据
                dic = self.btnSelectedArr[i];
                
                //接收bool值
                selected = dic[@"isSelected"];
                isSelected = selected.boolValue;
                tag1 = dic[@"tag"];
                
//                NSLog(@"isSelected = %@----tag = %@", selected, tag1);
                
                if(isSelected == NO){
                    btn.selected = NO;
                }else{
                    btn.selected = YES;
                }
                
                //转换数据类型
                tag = tag1.integerValue;
                btn.tag = tag;
                
                //添加监听
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
               
                [self addSubview:btn];
            }
            
        }
        
    }
    return self;
}

//按钮点击监听
-(void)btnClick:(UIButton *)btn{
    
    //如果点击的时候按钮是被选中的状态
    if(btn.selected == YES){
        
        //取消选中
        btn.selected = NO;
        
    }else{
        
        //否则变成选中状态
        btn.selected = YES;
        
    }
    
    //判断选中状态布尔变量
    NSNumber *selected = nil;
    
    //按钮tag值
    NSNumber *tag1 = nil;
    NSInteger tag = 0;
    
    //遍历数组，将按钮的状态重新保存
    for (NSMutableDictionary *dic in self.btnSelectedArr) {
        
        tag1 = dic[@"tag"];
        tag = tag1.integerValue;
        
        //tag值相等，则是同一个按钮，找到按钮在数组中的位置，更改其状态数据
        if(tag == btn.tag){
            
            //转化按钮状态数据的类型
            selected = [NSNumber numberWithBool:btn.selected];
            
            //更改字典键值
            [dic setObject:selected forKey:@"isSelected"];
        }
    }
    //获取文件路径
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"BtnSelected.txt"];
    
    //将更改之后的数据重新存入沙盒缓存
    [self.btnSelectedArr writeToFile:fullPath atomically:YES];
    
//    NSLog(@"%@", self.btnSelectedArr);
}

//-(void)setUpBtn{
//
//    //创建模型
//    ChooseBtnItem *item = [[ChooseBtnItem alloc] init];
//
//    for(int i = 0; i<self.array.count; i++){
//
//        //给模型赋值
//        item = self.array[i];
//
//        NSLog(@"%@", item);
//
//        //创建按钮
//        UIButton *btn = [[UIButton alloc] init];
//        btn.tag = i;
//        self.button = btn;
//
//        [self addSubview:btn];
//        NSLog(@"%@", NSStringFromCGRect(self.frame));
//        //设置按钮
//        //按钮文字
//        [btn setTitle:item.name forState:UIControlStateNormal];
//
//        NSLog(@"%@", item.name);
//        //按钮图片
//        [btn setImage:[UIImage imageNamed:@"ChooseBtn"] forState:UIControlStateNormal];
//    }
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //计算列数
    //CGFloat col = self.button.tag % 3;
    //计算行数
    //CGFloat row = (self.button.tag/3) % 1;
    
    //按钮间隙
    CGFloat spaceX = 32;
    CGFloat spaceY = 15;
    
    //行，列
    CGFloat row = 0;
    CGFloat col = 0;

    //按钮尺寸,位置
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - spaceX * 4)/3;
    CGFloat height = 40;
    CGFloat x = 0;               //spaceX + col * (width + spaceX);
    CGFloat y = 0;               //50 + row * spaceY;

    //计算
//    row = (self.button.tag/3) % 1;
//    col = self.button.tag % 3;
     
    //获取文件全路径
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"BtnSelected.txt"];
    
    NSMutableArray *mArr = [NSMutableArray array];
    
    for (UIButton *btn in self.subviews) {
        //计算行数，列数
        row = (int)btn.tag/3;
        col = btn.tag % 3;
        
        //计算横纵坐标
        x = spaceX + col * (width + spaceX);
        y = (height + spaceY) * row + height;
        
        [self settingBtn:btn];
        
        btn.frame = CGRectMake(x, y, width, height);
        btn.titleLabel.textColor = [UIColor labelColor];
        
        //按钮索引状态
        NSNumber *tag = [NSNumber numberWithInteger:btn.tag];
        NSNumber *isSelected = [NSNumber numberWithBool:btn.isSelected];
        
//        NSLog(@"%@----isSelected", isSelected);
        
        //创建字典
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tag, @"tag", isSelected, @"isSelected", nil];
        
        //将字典加入数组中
        [mArr addObject:dict];
        
        
    }
    
//    NSLog(@"%@", fullPath);
//    NSLog(@"%@+++++++btnSelectedArr", mArr);
    
    
    self.btnSelectedArr = mArr;
    
    //将数组写入沙盒缓存
    [self.btnSelectedArr writeToFile:fullPath atomically:YES];
    
}

//设置按钮各项属性
-(void)settingBtn:(UIButton *)btn{
 
    ChooseBtnItem *item = [[ChooseBtnItem alloc] init];
    item = self.array[btn.tag];
    
    //设置默认图片
    [btn setImage:[UIImage imageNamed:@"ChooseBtn-N"] forState:UIControlStateNormal];
    //设置高亮状态图片
    [btn setImage:[UIImage imageNamed:@"ChooseBtn-H"] forState:UIControlStateSelected];
    
    //圆角
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:10.0];
    
    //边框颜色
    btn.layer.borderWidth = 1;
    [btn.layer setBorderColor:[UIColor grayColor].CGColor];
    
    //设置按钮中图片的位置偏移量（距离上，左，下，右）
    btn.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 60);
    
    //设置文字
    [btn setTitle:item.name forState:UIControlStateNormal];
    
    //文字颜色
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //字体大小
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    //文字偏移
    btn.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 0);
    
    //文字靠左侧对齐
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    btn.imageView.backgroundColor = [UIColor greenColor];
}



@end
