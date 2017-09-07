//
//  ARLrcLine.m
//  ARQQMusic
//
//  Created by andyron on 2017/9/7.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARLrcLine.h"

@implementation ARLrcLine

- (instancetype)initWithLrcLineString:(NSString *)lrcLineString
{
    if (self = [super init]) {
        // [00:25.64]说不上为什麽 我变得很主动
        NSArray *lrcArray = [lrcLineString componentsSeparatedByString:@"]"];
        self.text = lrcArray[1];
        self.time = [self timeWithString:[lrcArray[0] substringFromIndex:1]];
    }
    return self;
}

+ (instancetype)LrcLineString:(NSString *)lrcLineString
{
    return [[self alloc] initWithLrcLineString:lrcLineString];
}

- (NSTimeInterval)timeWithString:(NSString *)timeString
{
    // 把 00:25.64 转换成秒
    NSInteger min = [[timeString componentsSeparatedByString:@":"][0] integerValue];
    NSInteger sec = [[timeString substringWithRange:NSMakeRange(3, 2)] integerValue];
    NSInteger hs = [[timeString componentsSeparatedByString:@"."][1] integerValue];
    
    return min * 60 + sec + hs * 0.01;
}
@end
