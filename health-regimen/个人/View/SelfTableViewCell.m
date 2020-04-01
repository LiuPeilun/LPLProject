//
//  SelfTableViewCell.m
//  health-regimen
//
//  Created by home on 2019/10/28.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "SelfTableViewCell.h"
#import "SelfItem.h"
#import "CacheManager.h"

@interface SelfTableViewCell()

@property(nonatomic, strong) NSArray *array;
@property(nonatomic, weak) UILabel *label;
@property(nonatomic, weak) UISwitch *swt;
@property(nonatomic, weak) UISlider *slider;
@property(nonatomic, assign) NSInteger index;

@property (nonatomic, copy) NSString *fileSize;

@end

@implementation SelfTableViewCell
//懒加载
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
    }
                        
    return _array;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        if([reuseIdentifier isEqualToString:@"arrow"]){
            //小箭头
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else if ([reuseIdentifier isEqualToString:@"default"]){
            
        }else if ([reuseIdentifier isEqualToString:@"slider"]){
            
            CGFloat value = [UIScreen mainScreen].brightness;
            
            UISlider *slider = [[UISlider alloc] init];
            [self addSubview:slider];
            
            self.slider = slider;
            
            slider.value = value;
            slider.maximumValue = 1;
            slider.minimumValue = 0;
            
            [slider addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];
            
        }else if ([reuseIdentifier isEqualToString:@"switch"]){
            
            UISwitch *swt = [[UISwitch alloc] init];
            [self addSubview:swt];
            
            
            self.swt = swt;
            //监听点击事件
            [swt addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if ([reuseIdentifier isEqualToString:@"label"]){
            
            UILabel *label = [[UILabel alloc] init];
            [self addSubview:label];
            
            self.label = label;
        }
    }
    
    return self;
    
}

-(void)switchClick:(UISwitch *)swt{
    
//    if([self.delegate respondsToSelector:@selector(tableViewCell:isOn:)]){
//        [self.delegate tableViewCell:self isOn:swt.isOn];
//    }
    NSDictionary *dict;
    if(swt.isOn == YES){
        dict = @{@"isOn":@"YES"};
    }else{
        dict = @{@"isOn":@"NO"};
    }
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"switch" object:nil userInfo:dict]];
    
}

-(void)sliderClick:(UISlider *)slider{
    
    if([self.delegate respondsToSelector:@selector(tableViewCell:sliderValue:)]){
        
        [self.delegate tableViewCell:self sliderValue:slider.value];
    }
    
//    NSLog(@"%f", slider.value);
    
}

//布局子控件
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat space = 10;
    
    CGFloat labelW = (self.frame.size.width -space * 2)/2;
    CGFloat labelH = self.frame.size.height - space * 2;
    CGFloat labelX = self.frame.size.width/2;
    CGFloat labelY = space;
    
    //开启子线程，计算缓存文件大小，缓存文件过大时，如不开子线程会造成主线程阻塞
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *invocation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(size) object:nil];
    
    queue.maxConcurrentOperationCount = 2;
    
    [queue addOperation:invocation];

    self.label.textAlignment = NSTextAlignmentRight;
    self.label.frame = CGRectMake(labelX, labelY, labelW, labelH);
    
    CGFloat sliderW = (self.frame.size.width -space * 2)/3;
    CGFloat sliderH = self.frame.size.height - space * 2;
    CGFloat sliderX = self.frame.size.width*2/3;
    CGFloat sliderY = space;
    
    self.slider.frame = CGRectMake(sliderX, sliderY, sliderW, sliderH);
    
    CGFloat swtW = (self.frame.size.width - space * 2)/4;
    CGFloat swtH = self.frame.size.height - space * 2;
    CGFloat swtX = self.frame.size.width * 5/6;
    CGFloat swtY = space;
    
    UITraitCollection *tra = UITraitCollection.currentTraitCollection;
    
//    NSLog(@"%ld", tra.userInterfaceStyle);
    
    if(tra.userInterfaceStyle == UIUserInterfaceStyleLight){
        
        self.swt.on = NO;
    }else if(tra.userInterfaceStyle == UIUserInterfaceStyleDark){
        self.swt.on = YES;
    }
    self.swt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.swt.frame = CGRectMake(swtX, swtY, swtW, swtH);
}

//计算缓存
-(void)size{
    self.fileSize = [[CacheManager shareManager] getAllTheCacheFileSize];
    
    //转到主线程刷新UI
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.label.text = self.fileSize;
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    //监听 计算缓存文件的cell的点击
    if(selected == YES)
    if([self.reuseIdentifier isEqualToString:@"label"]){
        
        if ([self.delegate respondsToSelector:@selector(tableViewCell:reuseIdentifier:)]) {
            [self.delegate tableViewCell:self reuseIdentifier:self.reuseIdentifier];
        }
        
    }
    
}



@end
