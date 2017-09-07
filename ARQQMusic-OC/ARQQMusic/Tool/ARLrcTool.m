//
//  ARLrcTool.m
//  ARQQMusic
//
//  Created by andyron on 2017/9/7.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARLrcTool.h"
#import "ARLrcLine.h"

@implementation ARLrcTool

+(NSArray *)lrcToolWithLrcName:(NSString *)lrcName
{
    // 1. 获取路径
    NSString *lrcFilePath = [[NSBundle mainBundle]pathForResource:lrcName ofType:nil];
    
    // 2. 获取歌词
    NSString *lrcString = [NSString stringWithContentsOfFile:lrcFilePath encoding:NSUTF8StringEncoding error:nil];
    
    // 将歌词转化为数组 ，会以每个\n为分隔符 转化为数组中的每个元素
    NSArray *lrcArr = [lrcString componentsSeparatedByString:@"\n"];
    
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (NSString *lrcLineString in lrcArr) {
        
        // 过滤掉不要的字符串，如果是以这些开头 或者不是以[开头的直接退出循环
        if ([lrcLineString hasPrefix:@"[ti:"] ||
            [lrcLineString hasPrefix:@"[ar:"] ||
            [lrcLineString hasPrefix:@"[al:"] ||
            ![lrcLineString hasPrefix:@"["]) {
            continue;
        }
        // 将字符串转化为模型
        ARLrcLine *lrcLine = [ARLrcLine LrcLineString:lrcLineString];
        [tempArr addObject:lrcLine];
    }
    
    return tempArr;
}

@end
