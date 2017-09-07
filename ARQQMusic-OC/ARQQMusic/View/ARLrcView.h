//
//  ARLrcView.h
//  ARQQMusic
//
//  Created by andyron on 2017/9/7.
//  Copyright © 2017年 andyron. All rights reserved.
//
// 歌词使用tableView显示

#import <UIKit/UIKit.h>

@class ARLrcLabel;

@interface ARLrcView : UIScrollView

/** 歌词文件名字 */
@property(nonatomic,strong)NSString *lrcName;

/** 歌词的Label */
@property (nonatomic, weak) ARLrcLabel *lrcLabel;

/** 当前播放的时间 */
@property (nonatomic,assign) NSTimeInterval currentTime;

/** 当前音乐的总时间 */
@property (nonatomic,assign) NSTimeInterval duration;

@end
