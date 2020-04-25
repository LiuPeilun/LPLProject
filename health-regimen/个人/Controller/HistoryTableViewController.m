//
//  HistoryTableViewController.m
//  health-regimen
//
//  Created by home on 2019/11/28.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "HistoryItem.h"
#import <SafariServices/SafariServices.h>
#import "UIColor+LPLColor.h"
#import "HistoryTableViewCell.h"

@interface HistoryTableViewController ()

@property(nonatomic, copy) NSArray *array;

@end

@implementation HistoryTableViewController
//懒加载
- (NSArray *)array{
    if(!_array){
        //数组读取沙盒文件
        NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"History.txt"]];
        
        //倒序排列数据
        NSMutableArray *Marray = [NSMutableArray array];
        NSInteger m = 0;
        for(NSInteger i=arr.count-1; i>=0; i--){
            Marray[m] = arr[i];
            m++;
        }
        //读取沙盒文件数据转化为NSdata
//        NSData *data = [NSData dataWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"History.txt"]];
//
//        NSLog(@"------%@", data);
        
//        NSString *str = [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8];
//        NSLog(@"%@", str);
        
        //将data 读出存储到数组里
//        NSError *error;
//        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//
//        NSLog(@"-error%@",error);
        
//        NSLog(@"%@", arr);
        
        //字典转模型
        NSMutableArray *Marr = [NSMutableArray array];
        for(NSDictionary *dict in Marray){
            HistoryItem *item = [HistoryItem itemWithDict:dict];
            [Marr addObject:item];
        }
        
        _array = Marr;
        
//        NSLog(@"%@", _array);
    }
    
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 80;
    
    self.tableView.backgroundColor = [UIColor tableViewBackColor];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    NSLog(@"%lu", self.array.count);
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"history"];
    if(cell == nil){
        cell = [[HistoryTableViewCell alloc] init];
    }
    
    HistoryItem *item = self.array[indexPath.row];
    
    cell.icon.image = [UIImage imageNamed:item.icon];
    cell.title.text = item.title;
    
    cell.backgroundColor = [UIColor cellColor];
    
    // Configure the cell...
    
    return cell;
}

//cell点击监听
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    HistoryItem *item = self.array[indexPath.row];
    
    SFSafariViewController *sfVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:item.url]];
    [self presentViewController:sfVC animated:YES completion:nil];
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
