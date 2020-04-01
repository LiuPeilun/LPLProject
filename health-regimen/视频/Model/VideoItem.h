//
//  VideoItem.h
//  health-regimen
//
//  Created by home on 2019/11/14.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoItem : NSObject

@property(nonatomic, copy) NSString *videoName;

//标题
@property(nonatomic, copy) NSString *video_title;
//url
@property(nonatomic, copy) NSString *video_url;
//时长
@property(nonatomic, copy) NSString *video_duration;
//播放量
@property(nonatomic, copy) NSString *intro;
//视频图片
@property(nonatomic, copy) NSString *video_image;

+(instancetype)videoDataWithDict:(NSDictionary *)dict;
+(instancetype)videoNameWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
