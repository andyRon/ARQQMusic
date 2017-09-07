//
//  ARMusicTool.m
//  ARQQMusic
//
//  Created by andyron on 2017/9/7.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARMusicTool.h"
#import "ARMusicModel.h"

@implementation ARMusicTool

static NSArray *_musics;
static ARMusicModel *_playingMusic;

// 类加载的时候初始化音乐列表和播放音乐
+(void)initialize
{
    if (_musics == nil) {
//        NSString *str = [[NSBundle mainBundle] pathForResource:@"Musics.plist" ofType:nil];
//        _musics = [ARMusicModel objectWithFile:str];

//        _musics = [ARMusicModel objectArrayWithFilename:@"Musics.plist"];
        

        
//        ARMusicModel *model1 = [[ARMusicModel alloc] init];
//        model1.name = @"小苹果";
//        model1.filename = @"120125029.mp3";
//        model1.lrcname = @"120125029.lrc";
//        model1.singer = @"筷子兄弟";
//        model1.singerIcon = @"kzxd_icon.jpg";
//        model1.icon = @"kzxd.jpg";
//
//        ARMusicModel *model2 = [[ARMusicModel alloc] init];
//        model2.name = @"泡沫";
//        model2.filename = @"14945107.mp3";
//        model2.lrcname = @"14945107.lrc";
//        model2.singer = @"G.E.M.邓紫棋";
//        model2.singerIcon = @"dzq_icon.jpg";
//        model2.icon = @"dzq.jpg";
//
//        _musics =[NSArray arrayWithObjects:model1,model2, nil];
        _musics = ARMusicModel.getAll;
        
    }
    if (_playingMusic == nil) {
        _playingMusic = _musics[0];
    }
}

// 获取所有音乐
+(NSArray *)Musics
{
    return _musics;
}
// 当前正在播放的音乐
+(ARMusicModel *)playingMusic
{
    return _playingMusic;
}
// 设置默认播放的音乐
+(void)setUpPlayingMusic:(ARMusicModel *)playingMusic
{
    _playingMusic = playingMusic;
}

// 返回上一首音乐
+ (ARMusicModel *)previousMusic
{
    NSInteger index = [_musics indexOfObject:_playingMusic];
    
    //    index -= 1;
    //    if (index < 0) {
    //        index = _musics.count - 1;
    //    }
    //    ARMusicModel *previousMusic = _musics[index];
    
    if (index == 0) {
        index = _musics.count -1;
    }else{
        index = index -1;
    }
    ARMusicModel *previousMusic = _musics[index];
    return previousMusic;
}

// 返回下一首音乐
+ (ARMusicModel *)nextMusic
{
    NSInteger index = [_musics indexOfObject:_playingMusic];
    if (index == _musics.count - 1) {
        index = 0;
    }else{
        index = index +1;
    }
    ARMusicModel *previousMusic = _musics[index];
    return previousMusic;
}

@end
