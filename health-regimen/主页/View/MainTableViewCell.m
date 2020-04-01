//
//  MainTableViewCell.m
//  health-regimen
//
//  Created by home on 2019/10/26.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "MainTableViewCell.h"
#import "UIColor+LPLColor.h"

@interface MainTableViewCell()

@end

@implementation MainTableViewCell

static NSString *ID = @"one";

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        //创建子控件
        //创建imageView
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        self.imageV = imageView;
        
        //创建标题
        UILabel *title = [[UILabel alloc] init];
        [self.contentView addSubview:title];
        self.title = title;
        
        //创建正文
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        self.label = label;
        
    }
    
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat space = 10;
    
    //imageView
    CGFloat imageH = self.contentView.frame.size.height - space * 3;
    CGFloat imageW = imageH * 7/6;
    CGFloat imageX = space;
    CGFloat imageY = space + 5;
    
//    self.imageV.backgroundColor = [UIColor orangeColor];
    self.imageV.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    //title
    CGFloat titleW = self.contentView.frame.size.width - space * 3 - imageW;
    CGFloat titleH = imageH * 3/10;
    CGFloat titleX = imageW + space * 2;
    CGFloat titleY = space + 5;
    
//    self.title.backgroundColor = [UIColor yellowColor];
    self.title.frame = CGRectMake(titleX, titleY, titleW, titleH);
    self.title.font = [UIFont systemFontOfSize:19 weight:3];
    self.title.textColor = [UIColor labelColor];
    
    //label
    CGFloat labelW = self.contentView.frame.size.width - space * 3 - imageW;
    CGFloat labelH = imageH * 6/10;
    CGFloat labelX = imageW + space * 2;
    CGFloat labelY = space + imageH * 4/10;
    
//    self.label.backgroundColor = [UIColor greenColor];
    self.label.frame = CGRectMake(labelX, labelY, labelW, labelH);
    self.label.textColor = [UIColor labelColor];
    self.label.numberOfLines = 3;
    self.label.font = [UIFont systemFontOfSize:14];
    self.label.textColor = [UIColor bottomLabelColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
