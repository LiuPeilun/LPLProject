//
//  LPLMainTableViewCell.m
//  health-regimen
//
//  Created by home on 2019/10/26.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "LPLMainTableViewCell.h"
#import "UIColor+LPLColor.h"

@interface LPLMainTableViewCell()

@end

@implementation LPLMainTableViewCell

static NSString *ID = @"two";

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        //标题
        UILabel *title = [[UILabel alloc] init];
        [self.contentView addSubview:title];
        self.title = title;
        
        //图
        UIImageView *imageV1 = [[UIImageView alloc] init];
        [self.contentView addSubview:imageV1];
        self.imageV1 = imageV1;
        
        UIImageView *imageV2 = [[UIImageView alloc] init];
        [self.contentView addSubview:imageV2];
        self.imageV2 = imageV2;
        
        UIImageView *imageV3 = [[UIImageView alloc] init];
        [self.contentView addSubview:imageV3];
        self.imageV3 = imageV3;
        
        //label
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
    
    CGFloat space = 10;
    
    //title
    CGFloat titleW = self.contentView.frame.size.width - space * 2;
    CGFloat titleH = self.contentView.frame.size.height * 3/10;
    CGFloat titleX = space;
    CGFloat titleY = space;
    
//    self.title.backgroundColor = [UIColor yellowColor];
    self.title.frame = CGRectMake(titleX, titleY, titleW, titleH);
    self.title.font = [UIFont systemFontOfSize:20 weight:3];
    self.title.numberOfLines = 2;
    
    //imageV1
    CGFloat imageV1W = (self.contentView.frame.size.width - space * 4)/3;
    CGFloat imageV1H = self.contentView.frame.size.height * 4/10;
    CGFloat imageV1X = space;
    CGFloat imageV1Y = (titleY + titleH) + space;
    
//    self.imageV1.backgroundColor = [UIColor orangeColor];
    self.imageV1.frame = CGRectMake(imageV1X, imageV1Y, imageV1W, imageV1H);
    
    //imageV2
    CGFloat imageV2W = (self.contentView.frame.size.width - space * 4)/3;
    CGFloat imageV2H = self.contentView.frame.size.height * 4/10;
    CGFloat imageV2X = imageV1W + space * 2;
    CGFloat imageV2Y = (titleY + titleH) + space;
    
//    self.imageV2.backgroundColor = [UIColor orangeColor];
    self.imageV2.frame = CGRectMake(imageV2X, imageV2Y, imageV2W, imageV2H);
    
    //imageV3
    CGFloat imageV3W = (self.contentView.frame.size.width - space * 4)/3;
    CGFloat imageV3H = self.contentView.frame.size.height * 4/10;
    CGFloat imageV3X = imageV1W + imageV2W +space * 3;
    CGFloat imageV3Y = (titleY + titleH) + space;
    
//    self.imageV3.backgroundColor = [UIColor orangeColor];
    self.imageV3.frame = CGRectMake(imageV3X, imageV3Y, imageV3W, imageV3H);
    
    //label
    CGFloat labelW = (self.contentView.frame.size.width - space * 2);
    CGFloat labelH = self.contentView.frame.size.height * 3/10 - space * 4;
    CGFloat labelX = space;
    CGFloat labelY = self.contentView.frame.size.height - space - labelH;
    
//    self.label.backgroundColor = [UIColor greenColor];
    self.label.frame = CGRectMake(labelX, labelY, labelW, labelH);
    self.label.font = [UIFont systemFontOfSize:14];
    self.label.textColor = [UIColor bottomLabelColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
