//
//  ARMusicTool.h
//  ARQQMusic
//
//  Created by andyron on 2017/9/7.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARMusicModel;
@interface ARMusicTool : NSObject

// 获取所有音乐
+(NSArray *)Musics;

// 当前正在播放的音乐
+(ARMusicModel *)playingMusic;

// 设置默认播放的音乐
+(void)setUpPlayingMusic:(ARMusicModel *)playingMusic;

// 返回上一首音乐
+ (ARMusicModel *)previousMusic;

// 返回下一首音乐
+ (ARMusicModel *)nextMusic;

@end
