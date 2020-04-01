//
//  VideoItem.m
//  health-regimen
//
//  Created by home on 2019/11/14.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "VideoItem.h"

@implementation VideoItem

+(instancetype)videoNameWithString:(NSString *)string{
    VideoItem *item = [[VideoItem alloc] init];
    
    item.videoName = string;
    
    return item;
}

+(instancetype)videoDataWithDict:(NSDictionary *)dict{
    VideoItem *item = [[VideoItem alloc] init];
    
    item.video_url = dict[@"video_url"];
    item.video_image = dict[@"video_image"];
    item.video_title = dict[@"video_title"];
    item.video_duration = dict[@"video_duration"];
    item.intro = dict[@"intro"];
    
    return item;
}

@end
