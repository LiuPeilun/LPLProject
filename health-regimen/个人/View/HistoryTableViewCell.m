//
//  HistoryTableViewCell.m
//  health-regimen
//
//  Created by home on 2019/11/29.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        UIImageView *imageV = [[UIImageView alloc] init];
        self.icon = imageV;
        [self.contentView addSubview:imageV];
        
        UILabel *label = [[UILabel alloc] init];
        self.title = label;
        [self.contentView addSubview:label];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat space = 10;
    
    CGFloat Iheight = self.contentView.frame.size.height - space * 2;
    CGFloat Iwidth = Iheight * 4/3;
    CGFloat Ix = space;
    CGFloat Iy = space;
    
    self.icon.frame = CGRectMake(Ix, Iy, Iwidth, Iheight);
    
    CGFloat Twidth = self.contentView.frame.size.width - Iwidth - space * 3;
    CGFloat Theight = 20;
    CGFloat Tx = Iwidth + 2*space;
    CGFloat Ty = self.contentView.frame.size.height/2 - Theight/2;
    
    self.title.frame = CGRectMake(Tx, Ty, Twidth, Theight);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
