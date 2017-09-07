//
//  ARAVdioTool.h
//  ARQQMusic
//
//  Created by andyron on 2017/9/7.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ARAVdioTool : NSObject

+(AVAudioPlayer *)playingMusicWithMusicFileName:(NSString *)filename;

+(void)pauseMusicWithMusicFileName:(NSString *)filename;

+(void)stopMusicWithMusicFileName:(NSString *)filename;

@end
