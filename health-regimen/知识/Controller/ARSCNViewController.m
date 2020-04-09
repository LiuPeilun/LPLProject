//
//  ARSCNViewController.m
//  health-regimen
//
//  Created by 312 on 2019/11/23.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "ARSCNViewController.h"
//3D游戏框架
#import <SceneKit/SceneKit.h>
//ARKit框架
#import <ARKit/ARKit.h>
#import "KnowledgeViewController.h"

@interface ARSCNViewController ()<ARSCNViewDelegate, ARSessionDelegate>
//AR视图：展示3D界面
@property (nonatomic, strong)ARSCNView *arSCNView;
//AR会话，负责管理相机追踪配置及3D坐标
@property (nonatomic, strong) ARSession *arSession;
//会话追踪配置：负责追踪相机的运动
@property (nonatomic, strong) ARConfiguration *arConfiguration;
//3D模型
@property (nonatomic, strong) SCNNode *planeNode;

//捏合手势开始时获取当前模型的scale
@property (nonatomic, assign) CGFloat beginPinchScale;
//捏合手势开始时获取手势的额比例scale
@property (nonatomic, assign) CGFloat beginObjScale;

//拖拽手势开始的时候记录的定位
@property (nonatomic, assign) CGPoint beginPanLocation;
//拖拽手势改变的时候记录的定位
@property (nonatomic, assign) CGPoint currentPanLocation;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) CGFloat endOffset;

@end

@implementation ARSCNViewController
//懒加载
//会话追踪配置
- (ARConfiguration *)arConfiguration{
    if(!_arConfiguration){
        //1.创建世界追踪会话配置（使用ARWorld）
        ARWorldTrackingConfiguration *configuration = [[ARWorldTrackingConfiguration alloc] init];
        //2.设置追踪方向（追踪平面）
        configuration.planeDetection = ARPlaneDetectionHorizontal;
//        configuration.planeDetection = ARPlaneDetectionVertical;
//        configuration.planeDetection = ARPlaneDetectionNone;
        _arConfiguration = configuration;
        //3.自适应灯光（相机从暗到强光快速过渡效果会平缓一些）
        _arConfiguration.lightEstimationEnabled = YES;
    }
    
    return _arConfiguration;
}

//拍摄会话
- (ARSession *)arSession{
    if(!_arSession){
        //创建会话
        _arSession = [[ARSession alloc] init];
    }
    return _arSession;
}

//创建AR视图
-(ARSCNView *)arSCNView{
    if(!_arSCNView){
        _arSCNView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
        //设置视图会话
        _arSCNView.session = self.arSession;
        //自动刷新灯光(3D游戏用到)
        _arSCNView.automaticallyUpdatesLighting = YES;
    }
    return _arSCNView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
    [btn setImage:[UIImage imageNamed:@"C-BackIcon-White_14x24_"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.arSCNView addSubview:btn];
    
    self.arSCNView.delegate = self;
    self.arSession.delegate = self;
    
    //添加捏合手势
    [self.arSCNView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)]];
    //添加拖动手势
    [self.arSCNView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    
    
}

//返回按钮点击监听
-(void)btnClick{
    
    KnowledgeViewController *vc = [[KnowledgeViewController alloc] init];
    self.delegate = vc;
    if([self.delegate respondsToSelector:@selector(reload)]){
        [self.delegate reload];
    }
    
//    [self presentingViewController];
    [self.navigationController popViewControllerAnimated:YES];
}

//捏合手势
-(void)pinch:(UIPinchGestureRecognizer *)pinch{
    
    //手势刚刚开始
    if(pinch.state == UIGestureRecognizerStateBegan){
        self.beginPinchScale = pinch.scale;
        self.beginObjScale = self.planeNode.scale.x;
    }
    //change
    if(pinch.state == UIGestureRecognizerStateChanged){
        CGFloat scale = self.beginObjScale *(CGFloat)(pinch.scale/self.beginPinchScale);
        
        self.planeNode.scale = SCNVector3Make(scale, scale, scale);
    }
}

//拖拽手势
-(void)pan:(UIPanGestureRecognizer *)pan{
    //手势刚刚开始
    if(pan.state == UIGestureRecognizerStateBegan){
        //刚开始接触屏幕还没有开始拖动手指的时候，记录下手指的位置
        self.beginPanLocation = [pan locationInView:self.arSCNView];
    }
    
    //change
    if(pan.state == UIGestureRecognizerStateChanged){
        //持续记录每时每刻手指的位置
        self.currentPanLocation = [pan locationInView:self.arSCNView];
        
        //手指向右拖拽
        if(self.currentPanLocation.x - self.beginPanLocation.x > 0){
            //记录手指位移量
            self.offset = self.currentPanLocation.x - self.beginPanLocation.x;
            
//            NSLog(@"%f+++++++++++++self.offset", self.offset);
        //向左拖拽
        }else{
            
            //记录手指位移量
            self.offset = self.currentPanLocation.x - self.beginPanLocation.x;
//            NSLog(@"%f+++++++++++++self.offset", self.offset);
        }
        
        //旋转模型x/y/z(x轴水平向右，z轴垂直指向屏幕外。y轴垂直向上)
        self.planeNode.eulerAngles = SCNVector3Make(0 , (self.endOffset + self.offset)/self.view.bounds.size.width * 2, 0);
//        NSLog(@"%f+++++++++++++self.endOffset + self.offset", self.endOffset + self.offset);
    }
    if(pan.state == UIGestureRecognizerStateEnded){
        //记录收支每一次滑动旋转到最后的角度
        self.endOffset = self.offset + self.endOffset;
//        NSLog(@"%f----------self.endOffset", self.endOffset);
        //结束后将每一次的位移清零
        self.offset = 0;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
//    //1.将AR视图添加到当前视图
//    [self.view addSubview:self.arSCNView];
//    //2.开启AR会话
//    [self.arSession runWithConfiguration:self.arConfiguration];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    //1.将AR视图添加到当前视图
    [self.view addSubview:self.arSCNView];
    //2.开启AR会话
    [self.arSession runWithConfiguration:self.arConfiguration];
}

//点击屏幕添加模型
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //如果有模型了，就不再创建，直接返回
    if(self.planeNode != nil){
        return;
    }
    
    NSLog(@"%s", __func__);
    
    //1.使用场景加载scn文件，scn格式文件是一个基于3D建模的文件，使用3DMax软件可以创建
    SCNScene *scene = [SCNScene sceneNamed:@"Model.scnassets/IronMan.scn"];
    //2.获取飞机节点（一个场景会有许多节点，飞机节点默认是场景子节点的第一个）
    //加载ios自带的ship.scn模型,取scn里面名为ship的子节点.多有场景都有且只有一个根结点，其他所有节点都是根结点的子节点
    SCNNode *shipNode = scene.rootNode.childNodes[0];
    
    //调整距离x/y/z （右/）
    shipNode.position = SCNVector3Make(0, -100, -100);
    shipNode.scale = SCNVector3Make(0.3, 0.3, 0.3);
    
    self.planeNode = shipNode;
    
    //3.将飞机节点添加到当前屏幕中
    [self.arSCNView.scene.rootNode addChildNode:shipNode];
    
    
}

#pragma mark - <ARSCNViewDelegate>
//添加节点的时候调用这个方法
-(void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    NSLog(@"添加节点");
}

////更新节点
//-(void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
//    NSLog(@"更新节点");
//}
//
////移除节点
//-(void)renderer:(id<SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
//    NSLog(@"移除节点");
//}

#pragma mark - <ARSessionDelegate>
//相机移动的时候持续调用这个方法，如果想要模型跟随镜头移动的话就要在这里持续改变模型的坐标
//- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame{
//
//    if(){
//
//    }
//
//    //移动飞机
//    if(self.planeNode){
//
//        self.planeNode.position = SCNVector3Make(frame.camera.transform.columns[3].x, frame.camera.transform.columns[3].y, frame.camera.transform.columns[3].z);
//    }
//
//}

////添加锚点
//-(void)session:(ARSession *)session didAddAnchors:(NSArray<__kindof ARAnchor *> *)anchors{
//    NSLog(@"添加锚点");
//}
//
////刷新锚点
//-(void)session:(ARSession *)session didUpdateAnchors:(NSArray<__kindof ARAnchor *> *)anchors{
//    NSLog(@"刷新锚点");
//}
//
////移除锚点
//-(void)session:(ARSession *)session didRemoveAnchors:(NSArray<__kindof ARAnchor *> *)anchors{
//    NSLog(@"移除锚点");
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
