//
//  VideoTableViewController.m
//  health-regimen
//
//  Created by home on 2019/10/21.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "VideoTableViewController.h"
#import "UIColor+LPLColor.h"
#import "LPLPlayerTableViewCell.h"
#import "VideoItem.h"
#import "AFNetworking.h"
#import "LPLRefreshControl.h"
#import "MJRefresh.h"
#import "JsonUrlItem.h"

@interface VideoTableViewController ()<UIScrollViewDelegate>
//自定义cell
@property(nonatomic, strong) LPLPlayerTableViewCell *lplCell;
//视频播放器
@property(nonatomic, strong) AVPlayer *player;
//视频播放器layer层
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
//视频播放器数据
@property (nonatomic, strong) AVPlayerItem *item;
//数组
@property(nonatomic, strong) NSArray *array;
//接收视频json数据数组
@property(nonatomic, strong) NSMutableArray *videoArr;
//视频数据数组转模型
@property(nonatomic, strong) NSMutableArray *videoArray;
//点击的cell的indexPath
@property (nonatomic, strong) NSIndexPath *optionIndexPath;
//自定义 cell
@property (nonatomic, strong) LPLPlayerTableViewCell *cell;

//@property (nonatomic, assign) CGPoint beforeP;
//@property (nonatomic, assign) CGPoint currentP;
//@property (nonatomic, assign) CGFloat offsetY;

//视频信息模型
@property(nonatomic, strong) VideoItem *videoItem;
//视频json文件路径
@property(nonatomic, copy) NSString *videoPath;
//装载json文件url地址的数组
@property(nonatomic, strong) NSArray *jsonUrlArray;
//展示视频数据的索引
@property(nonatomic, assign) NSInteger dataGroupCount;
//装载占位图的数组
@property(nonatomic, strong) NSMutableArray *imageUrlArray;
//主线程队列
//@property (nonatomic, strong) NSOperationQueue *mainQueue;
//子线程队列
@property (nonatomic, strong) NSOperationQueue *queue;
//下载任务字典缓存
@property (nonatomic, strong) NSMutableDictionary *operationDict;
//图片缓存
@property (nonatomic, strong) NSMutableDictionary *imageCache;
//网络状态
@property (nonatomic, assign) BOOL isHaveNetworking;
//cell缓存
@property (nonatomic, strong) NSMutableArray *cellArray;

@end

@implementation VideoTableViewController

//懒加载
//主线程队列懒加载
//- (NSOperationQueue *)mainQueue{
//    if(_mainQueue == nil){
//        _mainQueue = [NSOperationQueue mainQueue];
//    }
//    return _mainQueue;
//}


//播放器缓存数组
- (NSMutableArray *)cellArray{
    if(_cellArray == nil){
        _cellArray = [NSMutableArray array];
    }
    return _cellArray;
}

//图片缓存
- (NSMutableDictionary *)imageCache{
    if(_imageCache == nil){
        _imageCache = [[NSMutableDictionary alloc] init];
    }
    return _imageCache;
}

//任务字典懒加载
- (NSMutableDictionary *)operationDict{
    if(_operationDict == nil){
        _operationDict = [NSMutableDictionary dictionary];
    }
    return _operationDict;
}

//线程队列懒加载
- (NSOperationQueue *)queue{
    if(_queue == nil){
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

//存储 返回json资源文件的url 的数组懒加载
- (NSArray *)jsonUrlArray{
    if(_jsonUrlArray == nil){
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JsonUrlList" ofType:@"plist"]];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            JsonUrlItem *item = [JsonUrlItem jsonUrlWithDict:dic];
            [arr addObject:item];
        }
        
        _jsonUrlArray = arr;
    }
    
    return _jsonUrlArray;
}

//装载视频信息模型的数组 懒加载
- (NSMutableArray *)videoArray{
    if(_videoArray == nil){
        
//        NSData *data = [NSData dataWithContentsOfFile:self.videoPath];
//        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        self.videoArr = dict[@"data"];
        
        NSMutableArray *Marr = [NSMutableArray array];
        if(self.videoArr == nil){
            return nil;
        }
        
        //字典转模型
        for (NSDictionary *dic in self.videoArr) {
            VideoItem *item = [VideoItem videoDataWithDict:dic];
            [Marr addObject:item];
        }
        _videoArray = Marr;
    }
    
//    NSLog(@"_videoArray.count-----%lu", _videoArray.count);
//    NSLog(@"_videoArr.count-----%lu", self.videoArr.count);
    return _videoArray;
}


//json资源文件路径懒加载
- (NSString *)videoPath{
    if(!_videoPath){
        
        _videoPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%lu", @"videos", self.dataGroupCount]];
        
    }
    return _videoPath;
}

//视频模型数组
- (NSArray *)array{
    if(!_array){
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Video" ofType:@"plist"]];
        NSMutableArray *array1 = [NSMutableArray array];
        
        for (NSDictionary *dic in array) {
            NSString *string = dic[@"videoName"];
            NSString *str = [[NSBundle mainBundle] resourcePath];
            NSString *filePath = [NSString stringWithFormat:@"%@%@%@",str, @"/", string];
            
            [array1 addObject:filePath];
        }
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSString *filePath in array1) {
            
//            NSLog(@"%@", array1);
          
            
            VideoItem *item = [VideoItem videoNameWithString:filePath];
            [arr addObject:item];
        }
        
//        NSLog(@"%@", arr);
        _array = arr;
    }
    return _array;
}


//播放器
- (AVPlayer *)player{
    if(!_player){

        NSString *str = [[NSBundle mainBundle] resourcePath];
        NSString *filePath = [NSString stringWithFormat:@"%@%@",str,@"/1.mp4"];
        
        NSURL *url = [NSURL fileURLWithPath:filePath];

        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
        _player = [[AVPlayer alloc] initWithPlayerItem:item];

    }
    return _player;
}


//下载json数据
-(void)download{
    
    //json数据模型
    JsonUrlItem *item = [[JsonUrlItem alloc] init];
    
    //根据当前的数据组数,返回相应数据组的json数据url
    item = self.jsonUrlArray[self.dataGroupCount];
    
    //根据对应的json数据url发送请求下载json资源文件
    NSURL *url = [NSURL URLWithString:item.jsonUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //无条件的信任服务器上的证书
    AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
    
    // 客户端是否信任非法证书
    securityPolicy.allowInvalidCertificates = YES;
    
    // 是否在证书域字段中验证域名
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    
    

    //下载任务
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //打印下载进度
//        NSLog(@"%f", 1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //该框架省略了剪切文件的步骤，用户返回文件的路径就可以了
        //自行拼接资源文件的存储路径
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%lu",@"videos", self.dataGroupCount]];
        
        NSLog(@"%@", fullPath);
        self.videoPath = fullPath;
        
        return [NSURL fileURLWithPath:fullPath];
        
        //下载完成回调
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
         NSLog(@"%@", self.videoPath);
        
        NSData *data = [NSData dataWithContentsOfFile:self.videoPath];
        
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        //第一次加载首页视频数据，进入if，将数组赋给self.videoArr，在后面刷新表格数据
        if(self.videoArray == nil){
            
            self.videoArr = dict[@"data"];
            
            //遍历拿到数据的self.videoArr数组，拿到里面图片的url，下载并存到imageArray数组中
            for (NSDictionary *dic in self.videoArr) {
                NSURL *url = [NSURL URLWithString:dic[@"video_image"]];
                
                [self.imageUrlArray addObject:url];
            }
        }else{//不是第一次进入，将新下载的数据用临时数组arr拿到，遍历arr将每个元素转模型videoitem，逐一添加到self.videoArray数组中，并在后面刷新数据更新表格，增加数据数量
            
            NSArray *arr = dict[@"data"];
            
            for(int i=0; i<arr.count; i++){
                
                VideoItem *item = [VideoItem videoDataWithDict:arr[i]];
                
                NSURL *url = [NSURL URLWithString:item.video_image];
                
                [self.imageUrlArray addObject:url];
                
                [self.videoArray addObject:item];
                
            }
        }
        
//        NSLog(@"%@", dict);
//        NSLog(@"%@", self.videoArr);
        
        //第一次进入界面，刷新数据
        if(self.dataGroupCount == 0){
            
            [self.tableView reloadData];
            
        }else{//不是第一次进入，加载数据的情况，刷新数据并且刷新后结束刷新状态
            
//            [self.tableView reloadData];
            
            [self.tableView.mj_footer endRefreshing];
            
        }
        
    }];
    
    //开始任务
    [downloadTask resume];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self networkMonitoring];
    
    self.imageUrlArray = [NSMutableArray array];
    
    //数据组数
    self.dataGroupCount = 0;
    
    //下载数据任务
    [self download];
    //分割线
    //单线默认
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.backgroundColor = [UIColor tableViewBackColor];
    self.tableView.rowHeight = 300;
    
    
    
    //header
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadTableViewFirstPage)];
    
    //自动切换透明度（导航栏下自动隐藏）
    header.automaticallyChangeAlpha = YES;
    
    //当table 上面插入了其他元素时，忽略多少paddingTop
//    header.ignoredScrollViewContentInsetTop = 50;
    
    //设置文字
    //普通状态
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    //正在刷新
    [header setTitle:@"玩命加载中..." forState:MJRefreshStateRefreshing];
    //即将要刷新的状态（松手就刷新）
    [header setTitle:@"刷新准备完毕!" forState:MJRefreshStatePulling];
    
    //设置字体大小
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    //设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    
    //马上进入刷新状态
    [header beginRefreshing];
    
    //设置刷新控件
    self.tableView.mj_header = header;
    
    
    
    
    
    //footer
    //auto 模式会自动跟在最后的元素后面
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadTableViewNextPage)];
    
    //开始是隐藏的
//    footer.hidden = YES;
    //多次拉取也只加载一次
//    footer.onlyRefreshPerDrag = YES;
    //离bottom多远的时候触发
    footer.triggerAutomaticallyRefreshPercent = 1;
    
    footer.automaticallyRefresh = NO;
    
    //默认状态
    [footer setTitle:@"上拉加载新内容" forState:MJRefreshStateIdle];
    //即将加载状态
    [footer setTitle:@"刷新准备完毕!" forState:MJRefreshStatePulling];
    //正在加载
    [footer setTitle:@"玩命加载中" forState:MJRefreshStateRefreshing];
    //没有数据了
    [footer setTitle:@"我也是有底线的" forState:MJRefreshStateNoMoreData];

    
    //设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    
    //设置颜色
    footer.stateLabel.textColor = [UIColor grayColor];
    
    //自动切换透明度
//    footer.automaticallyChangeAlpha = YES;
    
    
    //设置footer
    self.tableView.mj_footer = footer;
    
}

// 网络监测
- (void)networkMonitoring
{
    //创建网络状态监测管理者
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    //监听网络状态的改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown = -1,
         AFNetworkReachabilityStatusNotReachable = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"此时没有网络");
                self.isHaveNetworking = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"移动网络");
              
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
             
                break;
            default:
                break;
        }
    }];
    
    //开启监听
    [manger startMonitoring];
}


- (NSString *)cacheDir{
    
    NSString *path = [[NSString alloc] init];
    
    //获取cache(本地缓存)目录
    path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"haha"];
    
    NSLog(@"%@", path);
    
    //拼接绝对路径
    return path;
    
}

//下拉刷新
-(void)loadTableViewFirstPage{
    //刷新数据
//    [self.tableView reloadData];
    
    //结束刷新状态
    [self.tableView.mj_header endRefreshing];
}

//上拉加载
-(void)loadTableViewNextPage{
    
    if(self.isHaveNetworking == YES){
        
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        
    }else{
        
        //每刷新一次，数据组数就加一
        self.dataGroupCount += 1;
        
        //数据上限6组，少于六组，继续下载任务，多于六组，返回没有数据的状态，不在刷新下载资源数据
        if(self.dataGroupCount == 6){
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }else{
            //继续下载新数据
            [self download];
            
            //刷新数据
            [self.tableView reloadData];
    //
    //        //结束刷新状态
    //        [self.tableView.mj_footer endRefreshing];
        }
        
    }
    
}

////刷新
//-(void)refreshC{
//    if(self.refresh.isRefreshing){
//
//        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"加载中..."];
//        [self.tableView reloadData];
//        [self.refresh endRefreshing];
//    }
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(self.videoArray == nil){
        return 10;
    }else{
        return self.videoArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    LPLPlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[LPLPlayerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    //tag
    cell.tag = indexPath.row;
    
    cell.backgroundColor = [UIColor cellColor];
    
    
    
    //视频占位图
    cell.loadImageView.image = [UIImage imageNamed:@"loadVideoImage"];
    
    if(self.videoArray == nil){
        
        //刚刚进入，数据为空，什么都不执行，避免数组中还没有数据，报错
        
    }else{
        
        VideoItem *item = self.videoArray[indexPath.row];
        
        //视频名称
        cell.label.text = item.video_title;
        cell.labelTime.text = item.video_duration;
        cell.labelBottom.text = item.intro;
        
        cell.label.textColor = [UIColor whiteColor];
        cell.labelTime.textColor = [UIColor whiteColor];
        
        //尝试从缓存中取出图片
        UIImage *image = self.imageCache[[self.imageUrlArray[indexPath.row] absoluteString]];
        
        //如果缓存中图片为空
        if(image == nil){
            
            //继续判断本地文件中是否有图片
            //拼接image的本地存储路径
            NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[self.imageUrlArray[indexPath.row] absoluteString]];
            
            //获取image存储在本地的二进制数据
            NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
            
            //如果本地存储的图片为空
            if(imageData == nil){
                
                //获取下载操作缓存
                NSOperation *op = self.operationDict[[self.imageUrlArray[indexPath.row] absoluteString]];
                
                //如果在operationDict中的下载操作缓存为空，则开启新线程执行下载任务
                if(op == nil){
                    
                        
                    //创建队列
                    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                        
                    self.queue.maxConcurrentOperationCount = 5;
                        
                    //子线程中执行下载图片任务
                    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                        
                        //获取图片url
                        NSURL *url = self.imageUrlArray[indexPath.row];
                        
                        //转化为data
                        NSData *data = [NSData dataWithContentsOfURL:url];
                        
                        //如果下载失败或者data为空，则要把操作从缓存中移除
                        if(data == nil){
                            [self.operationDict removeObjectForKey:[self.imageUrlArray[indexPath.row] absoluteString]];
                            
                            //data为空不再往下执行
                            return ;
                        }
                        
                        //data转化为image
                        UIImage *image = [UIImage imageWithData:data];
                        
                        //将下载好的图片放到缓存中
                        self.imageCache[[self.imageUrlArray[indexPath.row] absoluteString]] = image;
                        
                        //将下载好的图片写入本地
                        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[self.imageUrlArray[indexPath.row] absoluteString]];
                        [data writeToFile:path atomically:YES];
                        
                        //回到主线程
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            
                            //添加占位图片
                            cell.loadImageView.image = image;
                            
                            //刷新添加图片这一行的数据
            //                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                
                            
//                            NSLog(@"%@-=-=---=---=", [NSThread currentThread]);
                            
                        }];
                        
//                        NSLog(@"%@-=-=-=--=-==-=", [NSThread currentThread]);
                        
                    }];
                    
                    //将下载任务添加到操作缓存
                    self.operationDict[[self.imageUrlArray[indexPath.row] absoluteString]] = operation;
                    
                    //将任务添加到队列，开始下载任务
                    [queue addOperation:operation];
                    
                    self.queue = queue;
                    
//                    NSLog(@"%@", [NSThread currentThread]);
                                    
                    
                    
                }else{
                    
                    //如果operation缓存中有相应的下载任务，就什么都不做
                    
                }
                
                
            }else{
                
                //本地有相应的图片资源，加载本地图片
                image = [UIImage imageWithData:imageData];
                
                //将本地图片缓存到缓存中，以后直接在缓存中取
                //如果不添加到缓存中，那么每次程序启动都是从本地读取，而不是从缓存中读取图片
                self.imageCache[[self.imageUrlArray[indexPath.row] absoluteString]] = image;
                
                //更新UI
                cell.loadImageView.image = image;
            }
            
        }else{
            
            //缓存中有相应图片，加载缓存中的图片
            image = self.imageCache[[self.imageUrlArray[indexPath.row] absoluteString]];
            
//            NSLog(@"%@", self.imageCache[[self.imageUrlArray[indexPath.row] absoluteString]]);
            
            //更新UI
            cell.loadImageView.image = image;
            
        }
        
    }
                
    
//    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
//
//    cell.playerVC = playerVC;
//
//    cell.playerVC.player = player;
//
//    //视图的填充模式
//    playerVC.videoGravity = AVLayerVideoGravityResizeAspect;
//
//    //是否显示播放控制条
//    playerVC.showsPlaybackControls = YES;
//
//    //设置显示的frame
//    playerVC.view.frame = cell.view.bounds;
//
//    //将播放器控制器添加到当前页面控制器中
//    [cell.view addSubview:playerVC.view];
//
//    NSLog(@"%@", cell.playerVC);
    
    
    //block传值
    cell.block = ^(LPLPlayerTableViewCell * _Nonnull cell, UIButton * _Nonnull button) {
        
        if(self.cell){
            //这一次点击和上一次是同一个cell
            if(cell == self.cell){
                
                if(cell.button.alpha == 1){
                    
                    if(cell.playerVC == nil){
                        
                        AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
                        
                        AVPlayer *player = [[AVPlayer alloc] init];
                        
                        cell.playerVC = playerVC;
                        
                        cell.playerVC.player = player;
                        
                        //视图的填充模式
                        playerVC.videoGravity = AVLayerVideoGravityResizeAspect;
                        
                        //是否显示播放控制条
                        playerVC.showsPlaybackControls = YES;
                        
                        //设置显示的frame
                        playerVC.view.frame = cell.view.bounds;
                        
                        //将播放器控制器添加到当前页面控制器中
                        [cell.view addSubview:playerVC.view];
                        
                        //拿到当前点击的cell对应的视频信息模型
                        self.videoItem = self.videoArray[cell.tag];
                        
                        //给当前cell的视频播放器添加视频url
                        cell.playerVC.player = [AVPlayer playerWithURL:[NSURL URLWithString:self.videoItem.video_url]];
                        
                    }
                    
                    //播放视频
                    [cell.playerVC.player play];
                    
                    //占位图隐藏
                    cell.loadImageView.alpha = 0;
                    
                    //标题隐藏
                    cell.label.alpha = 0;
                    
                    //时间隐藏
                    cell.labelTime.alpha = 0;
                    
                    //播放按钮隐藏
                    cell.button.alpha = 0;
                }
                else{
                    
                    //暂停
                    [cell.playerVC.player pause];
                    
                }
                
                
            }else{
                
                //将cell添加进缓存数组，方便之后的移出屏幕之后占位图的恢复操作
                [self.cellArray addObject:cell];
                
                if(cell.playerVC == nil){
                    
                    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
                    
                    AVPlayer *player = [[AVPlayer alloc] init];
                    
                    cell.playerVC = playerVC;
                    
                    cell.playerVC.player = player;
                    
                    //视图的填充模式
                    playerVC.videoGravity = AVLayerVideoGravityResizeAspect;
                    
                    //是否显示播放控制条
                    playerVC.showsPlaybackControls = YES;
                    
                    //设置显示的frame
                    playerVC.view.frame = cell.view.bounds;
                    
                    
                    //将播放器控制器添加到当前页面控制器中
                    [cell.view addSubview:playerVC.view];
                    
                    //拿到当前点击的cell对应的视频信息模型
                    self.videoItem = self.videoArray[cell.tag];
                    
                    //给当前cell的视频播放器添加视频url
                    cell.playerVC.player = [AVPlayer playerWithURL:[NSURL URLWithString:self.videoItem.video_url]];
                    
                }
                
                //当前播放
                [cell.playerVC.player play];
                
                //上一个cell视频暂停
                [self.cell.playerVC.player pause];
                
                //上一个cell的播放按钮显示
                self.cell.button.alpha = 1;
                
                self.cell.label.alpha = 1;
                
                //当前cell播放按钮隐藏
                cell.button.alpha = 0;
                
                //标题隐藏
                cell.label.alpha = 0;
                
                //时间隐藏
                cell.labelTime.alpha = 0;
                
                //当前cell占位图隐藏
                cell.loadImageView.alpha = 0;
            }
        }else{//第一次点击
            
            
            [self.cellArray addObject:cell];
            
            NSLog(@"%@", self.cellArray);
            
            AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
            
            AVPlayer *player = [[AVPlayer alloc] init];
            
            cell.playerVC = playerVC;
            
            cell.playerVC.player = player;
            
            //视图的填充模式
            playerVC.videoGravity = AVLayerVideoGravityResizeAspect;
            
            //是否显示播放控制条
            playerVC.showsPlaybackControls = YES;
            
            //设置显示的frame
            playerVC.view.frame = cell.view.bounds;
            
            
            //将播放器控制器添加到当前页面控制器中
            [cell.view addSubview:playerVC.view];
            
            //拿到当前点击的cell对应的视频信息模型
            self.videoItem = self.videoArray[cell.tag];
            
            //给当前cell的视频播放器添加视频url
            cell.playerVC.player = [AVPlayer playerWithURL:[NSURL URLWithString:self.videoItem.video_url]];
            
            //当前cell视频播放
            [cell.playerVC.player play];
            
            //当前cell占位图隐藏
            cell.loadImageView.alpha = 0;
            
            //d当前cell播放按钮隐藏
            cell.button.alpha = 0;
            
            //标题隐藏
            cell.label.alpha = 0;
            
            //时间隐藏
            cell.labelTime.alpha = 0;
        }
        
        //将此cell暂存下来
        self.cell = cell;
        
        //将播放的cell的indexPath保存下来，用于计算位置
        self.optionIndexPath = indexPath;
    };
    return cell;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //暂停下载
    [self.queue setSuspended:YES];
    
    //cell在tableView中的坐标值
    CGRect rectIntableView = [self.tableView rectForRowAtIndexPath:self.optionIndexPath];
    
    //当前cell在屏幕中的坐标值
    CGRect rectInSuperView = [self.tableView convertRect:rectIntableView toView:[self.tableView superview]];
    
//    NSLog(@"cell当前坐标值：%f", rectInSuperView.origin.y);
    
    //对滑出屏幕的cell进行处理
    if(rectInSuperView.origin.y > self.view.frame.size.height){
        //移出屏幕的cell的相关处理
        //视频暂停
        [self.cell.playerVC.player pause];
//        [self.cell.playerVC.view removeFromSuperview];
        
        //遍历字典的cell，显示占位图
        for (LPLPlayerTableViewCell *cell in self.cellArray) {
            
            cell.loadImageView.alpha = 1;
            
            cell.label.alpha = 1;
            
            cell.labelTime.alpha = 1;
            
            cell.playerVC = nil;
        }
        
        //字典不为空就将内容全部移除
        if(self.cellArray != nil)
        [self.cellArray removeAllObjects];
        
        //播放按钮显示
        self.cell.button.alpha = 1;
        
        self.cell.label.alpha = 1;
        
        self.cell.labelTime.alpha = 1;
        
        //占位图显示
        self.cell.loadImageView.alpha = 1;
        
    }else if(rectInSuperView.origin.y + rectInSuperView.size.height < 0){
        //滑到屏幕上方cell相关处理
        //视频暂停
        [self.cell.playerVC.player pause];
//        [self.cell.playerVC.view removeFromSuperview];
        
        //遍历字典的cell，显示占位图
        for (LPLPlayerTableViewCell *cell in self.cellArray) {
            
            cell.loadImageView.alpha = 1;
            
            cell.label.alpha = 1;
            
            cell.labelTime.alpha = 1;
            
            cell.playerVC = nil;
        }
        
        //字典不为空就将内容全部移除
        if(self.cellArray != nil)
        [self.cellArray removeAllObjects];
        
        //播放按钮显示
        self.cell.button.alpha = 1;
        
        self.cell.label.alpha = 1;
        
        self.cell.labelTime.alpha = 1;
        
        //占位图显示
        self.cell.loadImageView.alpha = 1;
    }
    
    
}

//tableView停止滚动的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //恢复下载任务
    [self.queue setSuspended:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self.cell.playerVC.player pause];
    
}


- (void)didReceiveMemoryWarning{
        
    //释放队列和任务
    [self.operationDict removeAllObjects];
    self.queue = nil;
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
