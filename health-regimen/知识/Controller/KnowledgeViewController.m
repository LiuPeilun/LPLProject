//
//  KnowledgeViewController.m
//  health-regimen
//
//  Created by home on 2019/10/21.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "KnowledgeViewController.h"
#import "LPLMainTableViewCell.h"
#import "LPLBtnView.h"
#import "BoxViewController.h"
#import "UIColor+LPLColor.h"
#import "KonwTableItem.h"
#import "KonwTableItem.h"
#import "KnowWebViewController.h"
#import "MassageWebViewController.h"
#import "FoodWebViewController.h"
#import "ARSCNViewController.h"
#import "SelfTableViewController.h"
#import "FMDB.h"

@interface KnowledgeViewController ()<UINavigationControllerDelegate,LPLBtnViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate, ARSCNViewControllerDelegate, UITabBarControllerDelegate, SelfTableViewControllerDelegate>

@property(nonatomic, assign) CGFloat btnViewHeight;
@property(nonatomic, strong) LPLBtnView *btnView;
@property(nonatomic, copy) NSArray *tableArray;
@property(nonatomic, strong) NSFileHandle *handle;
@property(nonatomic, copy) NSString *fullPath;
@property(nonatomic, strong) NSMutableArray *historyArr;
@property(nonatomic, assign) NSInteger selectedIndex;
// 数据库对象
@property (nonatomic, strong) FMDatabase *fmDatabase;
@end

@implementation KnowledgeViewController
////懒加载
- (NSMutableArray *)historyArr{
    if(!_historyArr){
        if([[NSFileManager defaultManager] fileExistsAtPath:self.fullPath] != NO){
            _historyArr = [NSMutableArray arrayWithContentsOfFile:self.fullPath];
        }else{
            _historyArr = [NSMutableArray array];
        }
    }
    NSLog(@"%@", _historyArr);
    return _historyArr;
}

- (NSString *)fullPath{
    if(!_fullPath){
        _fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"History.txt"];
    }
    return _fullPath;
}

- (NSArray *)tableArray{
    if(!_tableArray){
        
        //数据库文件路径
        NSString *DataBasePath = @"/Users/home/Desktop/大学/iOS/健康养生APP/health-regimen/health.sqlite";
        NSLog(@"%@", DataBasePath);
        //创建数据库对象
        FMDatabase *db = [FMDatabase databaseWithPath:DataBasePath];
        _fmDatabase = db;
        
        // 打开数据库，true，打开成功；false，打开失败
        BOOL isSuccess = [db open];
        // 判断是否打开成功
        if (isSuccess) {
            NSLog(@"打开数据库成功");
            NSLog(@"数据库路径：%@", DataBasePath);
        } else {
            NSLog(@"打开数据库失败");
        }
        
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM KnowledgePage"];
        //遍历查询
        while([rs next]){
            
        }
        //读取plist文件数据
        NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"KnowTable" ofType:@"plist"]];
        
        NSMutableArray *Marr = [NSMutableArray array];
        
        //遍历数组
        for (NSDictionary *dic in arr) {
            //转为模型
            KonwTableItem *item = [KonwTableItem knowTableDataWithDict:dic];
            
//            NSLog(@"%@", item.url);
            
            [Marr addObject:item];
        }
        _tableArray = Marr;
        
    }
    return _tableArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //让控制器的view的大小计算在导航栏以下，tabBar以上
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.rowHeight = 230;
    
    self.tableView.estimatedSectionHeaderHeight = 100;
    
    self.tableView.backgroundColor = [UIColor tableViewBackColor];
    
    [self setDelegate];
    
}

//界面即将显示的时候
- (void)viewWillAppear:(BOOL)animated{
    self.view.alpha = 1;
    self.tabBarController.tabBar.hidden = NO;
    
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated{
    self.selectedIndex = self.tabBarController.selectedIndex;
    NSLog(@"self.selectedIndex----------------------%lu", self.selectedIndex);
}

-(void)setDelegate{
    self.btnView = [[LPLBtnView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    
    self.btnView.delegate = self;
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LPLMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"two"];
    
    if(cell == nil){
        cell = [[LPLMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"two"];
    }
    
    KonwTableItem *item = self.tableArray[indexPath.row];
    
    
    
    cell.title.text = item.title;
    cell.imageV1.image = [UIImage imageNamed:item.icon1];
    cell.imageV2.image = [UIImage imageNamed:item.icon2];
    cell.imageV3.image = [UIImage imageNamed:item.icon3];
    cell.label.text = item.text;
    
    cell.backgroundColor = [UIColor cellColor];
        
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
//    LPLBtnView *btn = [[LPLBtnView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
//    btn.backgroundColor = [UIColor yellowColor];
    
    return self.btnView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KnowWebViewController *webVC = [[KnowWebViewController alloc] init];
    self.delegate = webVC;
    
    KonwTableItem *item = self.tableArray[indexPath.row];
    
    //创建存储文件路径
    self.fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"History.txt"];
    
    //利用字典存储模型属性
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:item.icon1, @"icon", item.title, @"title", item.url, @"url", nil];
    
    //去重
    //便历数组，比较数据的url，出现相同的，将旧的记录删除，将新的添加到数组末尾
    NSLog(@"%lu", self.historyArr.count);
    for(int i=0; i<self.historyArr.count; i++){
        NSDictionary *dic = self.historyArr[i];
        if ([dict[@"url"] isEqual:dic[@"url"]]) {
            //移除元素后，后面元素会进行补位，所以索引计数遍历时每删除一个元素，索引都要减一
            [self.historyArr removeObjectAtIndex:i];
            i--;
        }
    }
    
    NSLog(@"%lu", self.historyArr.count);
    NSLog(@"%@", dict);
    
    [self.historyArr addObject:dict];
    NSLog(@"%@", self.historyArr);
    NSLog(@"%@", self.fullPath);
    
//    //创建文件句柄
//    self.handle = [NSFileHandle fileHandleForWritingAtPath:self.fullPath];
//
//    NSMutableArray *historyArray = [NSMutableArray array];
//
////    NSLog(@"%@", self.handle);
//    if(self.handle == nil){
//        //利用字典存储模型属性
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:item.icon1, @"icon", item.title, @"title", item.url, @"url", nil];
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
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:item.icon1, @"icon", item.title, @"title", item.url, @"url", nil];
//        //字典添加进数组中
//        [historyArray addObject:dict];
//        //数组转化为data
//        NSData *data = [NSJSONSerialization dataWithJSONObject:historyArray options:NSJSONWritingPrettyPrinted error:nil];
//
//        //写数据
//        [self.handle writeData:data];
//    }
    
//    NSLog(@"%@", item);
//    NSLog(@"%@", item.url);
    
    if([self.delegate respondsToSelector:@selector(cellClickWithURL:)]){
        
        NSLog(@"%@", item.url);
        
        
        [self.delegate cellClickWithURL:item.url];
        
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
}
#pragma mark - SelfTableViewControllerDelegate
//清理数组数据
- (void)removeHistory{
    NSLog(@"before++++++++++++%@", self.historyArr);
    [self.historyArr removeAllObjects];
    NSLog(@"after++++++++++++%@", self.historyArr);
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    if((tabBarController.selectedIndex != self.selectedIndex) && self.selectedIndex == 2){
        if((tabBarController.selectedIndex != 1) && (self.selectedIndex != 1) && (self.selectedIndex != 3)){
            if(self.historyArr.count != 0){
                [self.historyArr writeToFile:self.fullPath atomically:YES];
                self.historyArr = nil;
            }
            
        }
        
    }
}

#pragma mark - LPLBtnViewDelegate
//-(void)btnView:(LPLBtnView *)btnView height:(CGFloat)height{
//
//    self.btnViewHeight = height;
//
//    self.btnView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.btnViewHeight);
//    NSLog(@"%f", height);
//}

#pragma  mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView == self.tableView){
        CGFloat sectionHeaderHeight = 100;
        
        if(scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0){
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            
        }else if(scrollView.contentOffset.y >= sectionHeaderHeight){
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
        
    }
}

- (void)btnView:(LPLBtnView *)btnView btnTag:(NSInteger)tag{
    
//    NSLog(@"%lu------tag", tag);
    
    self.view.alpha = 0;
    
    if(0 == tag){
        
        FoodWebViewController *foodVC = [[FoodWebViewController alloc] init];
        
        [self.navigationController pushViewController:foodVC animated:YES];
        
    }else if(1 == tag){
        
        MassageWebViewController *masVC = [[MassageWebViewController alloc] init];
        
        [self.navigationController pushViewController:masVC animated:YES];
        
    }else if(2 == tag){
        
        BoxViewController *boxVC = [[BoxViewController alloc] init];
        
        [self.navigationController pushViewController:boxVC animated:YES];
    }else if(3 == tag){
        
        //创建自定义AR控制器
        ARSCNViewController *arVC = [[ARSCNViewController alloc] init];
        //跳转
       
        [self.navigationController pushViewController:arVC animated:YES];
    }
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    NSLog(@"%s", __func__);
//}

#pragma mark - ARSCNViewControllerDelegate
//- (void)reload{
//
//}

//
//- (void)viewDidAppear:(BOOL)animated{
//
//}


//- (void)viewDidLayoutSubviews{
//
//}
//
//- (void)viewWillLayoutSubviews{
//
//}
//
//- (void)viewWillAppear:(BOOL)animated{
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
