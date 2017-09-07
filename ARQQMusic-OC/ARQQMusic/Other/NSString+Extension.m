//
//  NSString+Extension.m
//  ARQQMusic
//
//  Created by andyron on 2017/9/7.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

#pragma mark - 播放时间的处理
+(NSString *)stringWithTime:(NSTimeInterval)time
{
    NSInteger min = time / 60;
    NSInteger sec = (int)round(time) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
}

@end

