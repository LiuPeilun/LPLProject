//
//  SelfTableViewController.m
//  health-regimen
//
//  Created by home on 2019/10/21.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "SelfTableViewController.h"
#import "SelfItem.h"
#import "SelfTableViewCell.h"
#import "CacheManager.h"
#import "UIColor+LPLColor.h"
#import "CollectionViewController.h"
#import "HistoryTableViewController.h"
#import "MainViewController.h"
#import "KnowledgeViewController.h"


@interface SelfTableViewController ()<SelfTableViewCellDelegate, UITabBarControllerDelegate>

@property(nonatomic, strong) NSArray *array;
@property(nonatomic, assign) NSInteger sectionNum;
@property(nonatomic, assign) NSInteger rowNum;
@property(nonatomic, assign) NSInteger tag;

@property(nonatomic, strong) SelfItem *item;
@property(nonatomic, strong) UIColor *labelColor;
@property(nonatomic, strong) UIColor *tableViewBackColor;
@property(nonatomic, strong) UIColor *tableViewHeadColor;

@end

@implementation SelfTableViewController

- (NSArray *)array{
    if(!_array){
        NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Self" ofType:@"plist"]];
                        
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in arr) {
            //创建模型
            SelfItem *item = [SelfItem itemWithDict:dict];
            [array addObject:item];
        }
        _array = array;
        self.tag = 0;
    }
                        
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 50;//(self.view.frame.size.height - self.sectionNum * 20)/self.array.count
    
    self.tableView.sectionHeaderHeight = 20;
    
    self.tableView.scrollEnabled = NO;
    
    self.tableView.backgroundColor = [UIColor tableViewBackColor];
    self.tableView.tableHeaderView.backgroundColor = [UIColor tableViewHeadColor];
    
//    NSLog(@"%lu+_+_+_+_+_+_+", self.tableView.numberOfSections);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    //模型
    SelfItem *item = [[SelfItem alloc] init];
    //获取数组最后一位数据
    item = self.array[self.array.count - 1];
    
    //判断组数
    self.sectionNum = [item.group integerValue];
    
//    NSLog(@"%lu+++++++++section", self.sectionNum);
    
    return self.sectionNum + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.rowNum = 0;

    if(section == 0){
        for (SelfItem *item in self.array) {
            //遍历数据，碰到组数相同的，行数变量加一
            if(section == [item.group integerValue]){
                self.rowNum += 1;
            }
        }
        return self.rowNum;
        
    }else if (section == 1){
        for (SelfItem *item in self.array) {
            //遍历数据，碰到组数相同的，行数变量加一
            if(section == [item.group integerValue]){
                self.rowNum += 1;
            }
            
        }
        return self.rowNum;
        
    }else{
        for (SelfItem *item in self.array) {
            //遍历数据，碰到组数相同的，行数变量加一
            if(section == [item.group integerValue]){
                self.rowNum += 1;
            }
        }
        return self.rowNum;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.item = self.array[self.tag];
    
//    NSLog(@"%lu", indexPath.row);
    
    SelfTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.item.type];
    
//    NSLog(@"%@", self.item.type);
    
    if(cell == nil){
        cell = [[SelfTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.item.type];
    }
    
    cell.backgroundColor = [UIColor cellColor];
    cell.imageView.image = [UIImage imageNamed:self.item.imageName];
    cell.textLabel.text = self.item.title;
    cell.textLabel.textColor = self.labelColor;
    
    if(self.tag < 9){
        self.tag += 1;
    }else{
        self.tag = 0;
    }
    
//    NSLog(@"%lu===========tag", self.tag);
    
    cell.delegate = self;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    view.backgroundColor = [UIColor tableViewHeadColor];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 && indexPath.section == 0){
        CollectionViewController *collectVC = [[CollectionViewController alloc] init];
        [self.navigationController pushViewController:collectVC animated:YES];
    }else if(indexPath.row == 1 && indexPath.section == 0){
        HistoryTableViewController *historyVC = [[HistoryTableViewController alloc] init];
        [self.navigationController pushViewController:historyVC animated:YES];
    }
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

}

#pragma mark - SelfTableViewCellDelegate
- (void)tableViewCell:(SelfTableViewCell *)cell sliderValue:(CGFloat)value{
    
    [[UIScreen mainScreen] setBrightness:value];
//    NSLog(@"%f------屏幕亮度值", value);
}

- (void)tableViewCell:(SelfTableViewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"在此再问你一遍哦" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *select = [UIAlertAction actionWithTitle:@"确定清除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"--确定--");
        
        //删除缓存
        [[CacheManager shareManager] clearCaches];
        
        //刷新数据
        [self.tableView reloadData];
        
        MainViewController *mainVC = [[MainViewController alloc] init];
        KnowledgeViewController *konwVC = [[KnowledgeViewController alloc] init];
        
        self.delegate1 = mainVC;
        if([self.delegate1 respondsToSelector:@selector(removeHistory)]){
            [self.delegate1 removeHistory];
        }
        
        self.delegate2 = konwVC;
        if([self.delegate2 respondsToSelector:@selector(removeHistory)]){
            [self.delegate2 removeHistory];
        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"--取消--");
    }];
    
    [alert addAction:select];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.view.alpha = 1;
    //这一步会损耗性能，切换界面的时候有延迟
    [self.tableView reloadData];
    self.tabBarController.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
//    self.view.alpha = 0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
