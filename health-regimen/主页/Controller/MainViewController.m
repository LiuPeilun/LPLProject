//
//  MainViewController.m
//  health-regimen
//
//  Created by home on 2019/10/21.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "MainViewController.h"
#import "AddViewController.h"
#import "LPLTabBarController.h"
#import "LPLScrollView.h"
#import "MainTableViewCell.h"
#import "LPLMainTableViewCell.h"
#import "LBItem.h"
#import "UIColor+LPLColor.h"
#import "TableItem.h"
#import "MainWebViewController.h"
#import "SelfTableViewController.h"

@interface MainViewController ()<UIScrollViewDelegate, UITabBarControllerDelegate, SelfTableViewControllerDelegate>

//headView高度
@property(nonatomic, assign)CGFloat headViewHeight;
//页数控制器
@property(nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic, strong) UIScrollView *scrollView;
//页数
@property(nonatomic, assign) int pageCount;
//模型数组
//@property(nonatomic, strong) TableItem *item;
@property(nonatomic, copy) NSArray *array;
@property(nonatomic, copy) NSArray *tableArray;
//浏览历史数组
@property(nonatomic, strong) NSMutableArray *historyArray;
//存储浏览历史文件的路径
@property(nonatomic, copy) NSString *fullPath;
//文件句柄
@property(nonatomic, strong) NSFileHandle *handle;

//计时器
@property(nonatomic, strong) dispatch_source_t timer;
//手指之前位置
@property(nonatomic, assign) CGPoint beforeP;
//当前手指位置
@property(nonatomic, assign) CGPoint currentP;
//位移差
@property(nonatomic, assign) CGFloat num;
@property(nonatomic, assign) NSInteger selectedIndex;

@end

@implementation MainViewController
//懒加载
- (NSMutableArray *)historyArray{
    if(!_historyArray){
        //如果开始的时候有文件就读取，没有就创建
        if([[NSFileManager defaultManager] fileExistsAtPath:self.fullPath] != NO){
            _historyArray = [NSMutableArray arrayWithContentsOfFile:self.fullPath];
            
        }else{
             _historyArray = [NSMutableArray array];
            
        }
    }
    return _historyArray;
}

- (NSString *)fullPath{
    if(!_fullPath){
        _fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"History.txt"];
    }
    return _fullPath;
}

- (NSArray *)tableArray{
    if(!_tableArray){
        //读取plist文件数据
        NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Table" ofType:@"plist"]];
        
        NSMutableArray *Marr = [NSMutableArray array];
        
        //遍历数组
        for (NSDictionary *dic in arr) {
            //转为模型
            TableItem *item = [TableItem tableDataWithDict:dic];
            
//            NSLog(@"%@", item.url);
            
            [Marr addObject:item];
        }
        _tableArray = Marr;
        
    }
    return _tableArray;
}

- (UIPageControl *)pageControl{
    
    if(!_pageControl){
        
        CGFloat width = 80;
        CGFloat height = 30;
        CGFloat x = (self.scrollView.frame.size.width - width)/2;
        CGFloat y = self.scrollView.frame.size.height - height;
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(x, y, width, height)];
        
        _pageControl.numberOfPages = self.array.count;
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor greenColor];
        
//        _pageControl.backgroundColor = [UIColor blackColor];
    }
    
    return _pageControl;
}

- (UIScrollView *)scrollView{
    
    if(!_scrollView){
        _scrollView = [[LPLScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.headViewHeight)];
        
        //设置scrollView内容尺寸
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * (2 + self.array.count), self.headViewHeight);
        
        //颜色
        _scrollView.backgroundColor = [UIColor blackColor];
        
        //取消横向滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        //设置偏移量在第二个位置
        _scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
        
    }
    
    return _scrollView;
}

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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    
    //让控制器的view的大小计算在导航栏以下，tabBar以上
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    NSLog(@"%f+++++++++",self.view.bounds.size.height);

    //设置组头高度
    self.tableView.estimatedSectionHeaderHeight = self.view.frame.size.height*3/10;
    
    //行高
    self.headViewHeight = self.view.frame.size.height*3/10;
    
//    NSLog(@"%f", self.headViewHeight);
    self.tableView.rowHeight = 120;
    
    //设置代理
    self.scrollView.delegate = self;
    
//    NSLog(@"%lu", self.selectedIndex);
    //计时器
    [self addTimer];
    
    //创建导航栏右侧添加按钮
    [self setUpRightBarBtn];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.alpha = 1;
    self.tabBarController.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.selectedIndex = self.tabBarController.selectedIndex;
//    NSLog(@"self.selectedIndex----------------------%lu", self.selectedIndex);
}

-(void)addTimer{
    //GCD计时器在GCD资源里面

    self.timer = dispatch_source_create(&_dispatch_source_type_timer, 0, 0,dispatch_get_main_queue());

//    self.timer = timer;
    //调用GCD的set方式

    //参数：1，GCD计时器    2，延迟几秒后开始执行   3，计时器间隔    4，计时器精度

    dispatch_source_set_timer(_timer,DISPATCH_WALLTIME_NOW, 4.0*NSEC_PER_SEC, 0ull*NSEC_PER_SEC);

    //handle方法(该方法在开启了计时器时调用)

    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        
        [weakSelf nextImage];
    });

    //开启计时器

    dispatch_resume(_timer);
}

-(void)nextImage{
    
    CGFloat currentX = _scrollView.contentOffset.x;
    
    CGFloat nextX = currentX + self.view.frame.size.width;
    
    [UIView animateWithDuration:0.5 animations:^{
//        __weak typeof(self) weakSelf = self;
        self.scrollView.contentOffset = CGPointMake(nextX, 0);
    }];
     
    
    //当UIScrollView滑动到第一位(第一张图片也就是显示着最后一张图片的图片)停止时，将UIScrollView的偏移量改变
    if(_scrollView.contentOffset.x == 0){

        //改变到倒数第二张图片位置
        _scrollView.contentOffset = CGPointMake(self.array.count * self.view.frame.size.width, 0);
        self.pageControl.currentPage = self.array.count;

        //当图片移动到最后一位，显示的是第一张图片，改变偏移量
    }else if (_scrollView.contentOffset.x == (self.array.count + 1) * self.view.frame.size.width){

        //改到第二位图片的位置
        _scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
        self.pageControl.currentPage = 0;

    }else{
        self.pageControl.currentPage = self.scrollView.contentOffset.x / self.view.frame.size.width - 1;
    }
}

//-(void)pan:(UIPanGestureRecognizer *)pan{
//
//    //判断手势状态
//    //开始手势的时候
//    if (pan.state == UIGestureRecognizerStateBegan) {
//
//        //获取当前手指位置
//        self.beforeP = [pan locationInView:self.scrollView];
//
//        //拖拽
//        if(pan.state == UIGestureRecognizerStateChanged){
//
//            //获取手指位置
//            self.currentP = [pan locationInView:self.scrollView];
//
//            //两点之间横移差值
//            self.num = self.currentP.x - self.beforeP.x;
//
//            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + self.num, 0);
//
//            if(fabs(self.num) > self.view.frame.size.width/2){
//
//                if(self.num > 0){
//
//                    if(self.pageControl.currentPage < 4 && self.pageControl.currentPage >=1){
//                        self.pageControl.currentPage = self.pageControl.currentPage + 1;
//                    }else{
//                        self.pageControl.currentPage = 1;
//                    }
//
//                }else {
//
//                    if(self.pageControl.currentPage >1 && self.pageControl.currentPage <= 4){
//                        self.pageControl.currentPage = self.pageControl.currentPage - 1;
//                    }else{
//                        self.pageControl.currentPage = 4;
//                    }
//
//                }
//            }
//
//            //结束拖拽
//            if(pan.state == UIGestureRecognizerStateEnded){
//
//                self.currentP = [pan locationInView:self.scrollView];
//
//                self.num = self.num = self.currentP.x - self.beforeP.x;
//
//                if(){
//
//                }
//            }
//        }
//    }
//}

//创建导航栏右侧按钮
-(void)setUpRightBarBtn{
    
    //创建添加按钮
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn setImage:[UIImage imageNamed:@"barBtn_4"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"barBtn_4"] forState:UIControlStateSelected];
    
    //添加按钮点击监听
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //自动调整
    [addBtn sizeToFit];
    
    //添加右侧添加按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    
}

//按钮点击监听
-(void)addBtnClick{
    
    self.view.alpha = 0;
    
    AddViewController *addVC = [[AddViewController alloc] init];
    
    //定义一个动画变换类型
    CATransition *animate = [CATransition animation];
    
    //设置动画的时间长度
    animate.duration = 0.5;
    
    //设置动画的类型，决定动画的效果形式
    //从下向上推出
    animate.type = kCATransitionPush;
    
    //翻转切换
    animate.type = @"oglFlip";
    
    //设置动画的子类型，动画的方向
    animate.subtype = kCATransitionFromTop;
    
    //设置动画的轨迹模式
    animate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    animate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    //将动画设置对象添加到动画上
    [self.navigationController.view.layer addAnimation:animate forKey:nil];
    
    //点击切换控制器
    [self.navigationController pushViewController:addVC animated:YES];
    
    
}
#pragma mark - SelfTableViewControllerDelegate
- (void)removeHistory{
//    NSLog(@"before++++++++++++%@", self.historyArray);
    [self.historyArray removeAllObjects];
//    NSLog(@"after++++++++++++%@", self.historyArray);
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    //筛选条件，减少工作量，跳转到视频界面的时候不进行文件存取
    if((tabBarController.selectedIndex != self.selectedIndex) && self.selectedIndex == 0){
        if((tabBarController.selectedIndex != 1) && (self.selectedIndex != 1) && (self.selectedIndex != 3)){
            
//            NSLog(@"%lu", self.historyArray.count);
            //数组不为空
            if(self.historyArray.count != 0){
                [self.historyArray writeToFile:self.fullPath atomically:YES];
                //清空数组，否则数据错乱
                self.historyArray = nil;
            }
            
        }
    }
    
}

#pragma mark - TableViewDelegate

//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}


//设置cell数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
    
    if(cell == nil){
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
    }
    
    cell.tag = indexPath.row;
    
    TableItem *item = self.tableArray[indexPath.row];
    
    cell.imageV.image = [UIImage imageNamed:item.icon];
    cell.label.text = item.text;
    cell.title.text = item.title;
    
    cell.backgroundColor = [UIColor cellColor];
    
    return cell;
    
}

//设置section的 headView，轮播图子控件就在这里添加
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.headViewHeight)];

//    NSLog(@"self.view.frame.size.height*3/10 = %lf", self.view.frame.size.height*3/10);
//    NSLog(@"%@-=-=-=-=-=", NSStringFromCGRect(scrollView.frame));
    
    [view addSubview:self.scrollView];
    [view addSubview:self.pageControl];

//    self.scrollView = scrollView;

    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MainWebViewController *webVC = [[MainWebViewController alloc] init];
    self.delegate = webVC;
    
    TableItem *item = self.tableArray[indexPath.row];
    
    //创建存储文件路径
    self.fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"History.txt"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:item.icon, @"icon", item.title, @"title", item.url, @"url", nil];
    
    //去重
    //便历数组，比较数据的url，出现相同的，将旧的记录删除，将新的添加到数组末尾
//    NSLog(@"MainViewController-------------------%lu", self.historyArray.count);
    for(int i=0; i<self.historyArray.count; i++){
        NSDictionary *dic = self.historyArray[i];
        if ([dict[@"url"] isEqual:dic[@"url"]]) {
            //移除元素后，后面元素会进行补位，所以索引计数遍历时每删除一个元素，索引都要减一
            [self.historyArray removeObjectAtIndex:i];
            i--;
        }
    }
    
    [self.historyArray addObject:dict];
    //创建文件句柄
//    self.handle = [NSFileHandle fileHandleForWritingAtPath:self.fullPath];
    
//    NSMutableArray *historyArray = [NSMutableArray array];
//
//    NSLog(@"%@", self.handle);
//    if(self.handle == nil){
//        //利用字典存储模型属性
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:item.icon, @"icon", item.title, @"title", item.url, @"url", nil];
//        //字典添加进数组中
//        [historyArray addObject:dict];
//        //数组转化为data
//        NSData *data = [NSJSONSerialization dataWithJSONObject:historyArray options:NSJSONWritingPrettyPrinted error:nil];
//
//        //写数据
//        [data writeToFile:self.fullPath atomically:YES];
//    }else{
//
//        //句柄移动到文件末尾
//        [self.handle seekToEndOfFile];
//
//        //利用字典存储模型属性
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:item.icon, @"icon", item.title, @"title", item.url, @"url", nil];
//        //字典添加进数组中
//        [historyArray addObject:dict];
//        //数组转化为data
//        NSData *data = [NSJSONSerialization dataWithJSONObject:historyArray options:NSJSONWritingPrettyPrinted error:nil];
//
//        //写数据
//        [self.handle writeData:data];
//    }
    
//    [self.historyArray writeToFile:self.fullPath atomically:YES];
    
//    NSLog(@"%@", self.historyArray);
    NSLog(@"%@", self.fullPath);
    
//    NSLog(@"%@", item);
//    NSLog(@"%@", item.url);
    
    if([self.delegate respondsToSelector:@selector(cellClickWithURL:cellTag:)]){
        
//        NSLog(@"%@", item.url);
        
        
        
        [self.delegate cellClickWithURL:item.url cellTag:indexPath.row];
        
        self.navigationController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
}

#pragma  mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if(self.scrollView == scrollView){

        //暂停计时器
//        dispatch_suspend(self.timer);

        NSLog(@"%@------------暂停计时器", self.timer);
    }
   
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //继续计时器
//    dispatch_resume(self.timer);
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    //GCD停止计时器方法，会触发dispatch_source_set_cancel_handler方法
//
//    dispatch_source_cancel(self.timer);
//
//    dispatch_source_set_cancel_handler(self.timer, ^{
//
//        NSLog(@"计时器已经停止了");
//
//    });
    
    
    
    //如果滚动的控件是tableView
    if(scrollView == self.tableView){
        CGFloat sectionHeaderHeight = self.headViewHeight;
        
//        NSLog(@"%f-----------scrollView.contentOffset.y", scrollView.contentOffset.y);
        
        //如果纵向位移小于tableViewHeadView的高度
        if(scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0){
            //headView跟着位移
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            
            //如果位移超过headView高度
        }else if(scrollView.contentOffset.y >= sectionHeaderHeight){
            
            //移出屏幕
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            
        }
        
    }



}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    
    if(self.scrollView == scrollView){
        
        //当UIScrollView滑动到第一位(第一张图片也就是显示着最后一张图片的图片)停止时，将UIScrollView的偏移量改变
        if(scrollView.contentOffset.x == 0){

            //改变到倒数第二张图片位置
            scrollView.contentOffset = CGPointMake(self.array.count * self.view.frame.size.width, 0);
            self.pageControl.currentPage = self.array.count;

            //当图片移动到最后一位，显示的是第一张图片，改变偏移量
        }else if (scrollView.contentOffset.x == (self.array.count + 1) * self.view.frame.size.width){

            //改到第二位图片的位置
            scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
            self.pageControl.currentPage = 0;

        }else{
            self.pageControl.currentPage = scrollView.contentOffset.x / self.view.frame.size.width - 1;
        }
        
//            //GCD计时器在GCD资源里面
//
//            dispatch_source_t timer =dispatch_source_create(&_dispatch_source_type_timer, 0, 0,dispatch_get_main_queue());
//
//            self.timer = timer;
//            //调用GCD的set方式
//
//            //参数：1，GCD计时器    2，延迟几秒后开始执行   3，计时器间隔    4，计时器精度
//
//            dispatch_source_set_timer(timer,DISPATCH_WALLTIME_NOW, 3.0*NSEC_PER_SEC, 0ull*NSEC_PER_SEC);
//
//            //handle方法(该方法在开启了计时器时调用)
//
//            dispatch_source_set_event_handler(timer, ^{
//
//                [self nextImage];
//            });

            //开启计时器

        
        
        NSLog(@"%@------------重建计时器", self.timer);
        
        
    }
    
    
    
}


- (void)dealloc
{
    
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
