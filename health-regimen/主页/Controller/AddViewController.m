//
//  AddViewController.m
//  health-regimen
//
//  Created by home on 2019/10/22.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "AddViewController.h"
#import "ChooseBtnItem.h"
#import "AddView.h"
#import "UIColor+LPLColor.h"

@interface AddViewController ()

//@property(nonatomic, strong) NSArray *array;
//@property(nonatomic, strong) UIButton *button;
@property(nonatomic, strong) AddView *addView;

@end

@implementation AddViewController

//懒加载

- (AddView *)addView{
    if(!_addView){
        _addView = [[AddView alloc] initWithFrame:self.view.frame];
        
//        NSLog(@"%@", NSStringFromCGRect(_addView.frame));
    }

    return _addView;
}

//- (NSArray *)array{
//    if(!_array){
//
//        NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Channels" ofType:@"plist"]];
//
//        NSMutableArray *array = [NSMutableArray array];
//        for (NSMutableDictionary *dic in arr) {
//            ChooseBtnItem *item = [ChooseBtnItem initWithDict:dic];
//            [array addObject:item];
//        }
//
//        _array = array;
//    }
//
//    return _array;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //让控制器的view的大小计算在导航栏以下，tabBar以上
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //隐藏返回按钮
    self.navigationItem.hidesBackButton = YES;
    
    self.view.backgroundColor = [UIColor tableViewBackColor];
    
    [self setUpRightBtn];
    //添加view
//    [self.view addSubview:self.addView];
    
//    [self setUpBtn];
}

//创建导航栏右侧按钮
-(void)setUpRightBtn{
    
    //创建按钮
    UIButton *btn = [[UIButton alloc] init];
    
    //设置图片
    [btn setImage:[UIImage imageNamed:@"FinishChooseBtn"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //自动调整尺寸
    [btn sizeToFit];
    //添加按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)rightBtnClick{
    
    //返回上一级控制器
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView{
    [super loadView];
    
    //替换self.view
    self.view = [[AddView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
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
//        //创建按钮
//        UIButton *btn = [[UIButton alloc] init];
//        btn.tag = i;
//        self.button = btn;
//
//        [self.view addSubview:btn];
//
//        //设置按钮
//        //按钮文字
//        [btn setTitle:item.name forState:UIControlStateNormal];
//        //按钮图片
//        [btn setImage:[UIImage imageNamed:@"ChooseBtn"] forState:UIControlStateNormal];
//    }
//}
//
//
////布局子控件
//-(void)viewWillLayoutSubviews{
//
//    [super viewWillLayoutSubviews];
//    //计算行数
//    CGFloat row = (self.button.tag/3) % 1;
//
//    NSLog(@"%f", row);
//    //计算列数
//    CGFloat col = self.button.tag % 3;
//
//    //按钮间隙
//    CGFloat spaceX = 30;
//    CGFloat spaceY = 12;
//
//    //按钮尺寸,位置
//    CGFloat width = ([UIScreen mainScreen].bounds.size.width - spaceX * 4)/3;
//    CGFloat height = 50;
//    CGFloat x = spaceX + col * (width + spaceX);
//    CGFloat y = 50 + row * spaceY;
//
//    self.button.frame = CGRectMake(x, y, width, height);
//
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
