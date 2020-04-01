//
//  LPLPlayerTableViewCell.m
//  health-regimen
//
//  Created by home on 2019/11/5.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "LPLPlayerTableViewCell.h"

@interface LPLPlayerTableViewCell()

@end

@implementation LPLPlayerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        UIView *view = [[UIView alloc] init];
        [self.contentView addSubview:view];
        
        self.view = view;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];

        self.loadImageView = imageView;
        
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        
        self.label = label;
        
        UILabel *label1 = [[UILabel alloc] init];
        [self.contentView addSubview:label1];
        
        self.labelBottom = label1;
        
        UILabel *label2 = [[UILabel alloc] init];
        [self.contentView addSubview:label2];
        
        self.labelTime = label2;
        
        UIButton *btn = [[UIButton alloc] init];
        [self.contentView addSubview:btn];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.button = btn;
        
//        AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
//        //视图的填充模式
//        playerVC.videoGravity = AVLayerVideoGravityResizeAspect;
//        //是否显示播放控制条
//        playerVC.showsPlaybackControls = YES;
//        self.playerVC = playerVC;
//
//        //将播放器控制器添加到当前页面控制器中
//        [self.contentView addSubview:playerVC.view];
    }
    
    return self;
}

-(void)setTagButtonBlock:(CellBlock)cellBlock{
    
    self.block = cellBlock;
}

-(void)btnClick:(UIButton *)btn{
    self.block(self, btn);
}

//布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat space = 10;
    
    CGFloat labelW = self.contentView.frame.size.width;
    CGFloat labelH = 20;
    CGFloat labelX = 20;
    CGFloat labelY = space * 2;
    
//    self.label.text = @"视频";
    self.label.frame = CGRectMake(labelX, labelY, labelW, labelH);
    
    CGFloat viewW = self.contentView.frame.size.width;
    CGFloat viewH = 250;
    CGFloat viewX = 0;
    CGFloat viewY = space;
    
    self.view.frame = CGRectMake(viewX, viewY, viewW, viewH);
    self.view.backgroundColor = [UIColor blackColor];
    
    CGFloat btnW = 80;
    CGFloat btnH = 80;
    CGFloat btnX = self.view.center.x - btnW/2;
    CGFloat btnY = self.view.center.y - btnH/2;
    
    [self.button setImage:[UIImage imageNamed:@"VI-PlayIcon_80x80_"] forState:UIControlStateNormal];
    self.button.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    CGFloat imageW = self.view.frame.size.width;
    CGFloat imageH = self.view.frame.size.height;
    CGFloat imageX = self.view.frame.origin.x;
    CGFloat imageY = self.view.frame.origin.y;

    self.loadImageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    CGFloat labelBottomW = 80;
    CGFloat labelBottomH = 20;
    CGFloat labelBottomX = 10;
    CGFloat labelBottomY = imageY + imageH + 5;
    
    self.labelBottom.font = [UIFont systemFontOfSize:13];
    self.labelBottom.frame = CGRectMake(labelBottomX, labelBottomY, labelBottomW, labelBottomH);
    
    CGFloat labelTimeW = 50;
    CGFloat labelTimeH = 20;
    CGFloat labelTimeX = self.view.frame.size.width - labelTimeW;
    CGFloat labelTimeY = imageY + imageH - space - labelTimeH;
    
    self.labelTime.font = [UIFont systemFontOfSize:13];
    self.labelTime.frame = CGRectMake(labelTimeX, labelTimeY, labelTimeW, labelTimeH);
//    设置显示的frame
//    self.playerVC.view.frame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height, self.view.frame.origin.x, self.view.frame.origin.y);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)drawRect:(CGRect)rect{
//    
//}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
////    [self.playerVC.player pause];
//    self.button.alpha = 0;
//}


@end
