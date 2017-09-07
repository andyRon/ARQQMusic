//
//  ARPlayingViewController.m
//  ARQQMusic
//
//  Created by andyron on 2017/9/7.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARPlayingViewController.h"
#import "ARMusicModel.h"
#import "ARMusicTool.h"
#import "ARAVdioTool.h"
#import "ARLrcView.h"
#import "ARlrcLabel.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+Extension.h"
#import "CALayer+PauseAimate.h"

#define ARColor(r,g,b,a)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
@interface ARPlayingViewController ()<UIScrollViewDelegate>

/** 歌手背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *albumView;
/** 进度条 */
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
/** 歌手图片 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

/** 歌曲名 */
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
/** 歌手名 */
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
/** 当前播放时间 */
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
/** 歌曲的总时间 */
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

/** 进度条时间 */
@property (nonatomic, strong) NSTimer *progressTimer;

/** 播放器 */
@property (nonatomic, strong) AVAudioPlayer *currentPlayer;

@property (weak, nonatomic) IBOutlet UIButton *playWithPauseBtn;
@property (weak, nonatomic) IBOutlet ARLrcView *lrcScrollView;
@property (weak, nonatomic) IBOutlet ARLrcLabel *lrcLabel;

/** 歌词的定时器 */
@property (nonatomic,strong) CADisplayLink *lrcTiemr;

@end

@implementation ARPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // 改变滑块的图片
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];

    // 记录歌词label属性
    self.lrcScrollView.lrcLabel = self.lrcLabel;

    // 开始播放音乐
    [self startPlayingMusic];

    self.lrcScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
}

#pragma mark 播放音乐
-(void)startPlayingMusic
{
    // 获取当前正在播放的音乐
    ARMusicModel *playingMusic = [ARMusicTool playingMusic];
    
    // 设置界面信息
    self.albumView.image = [UIImage imageNamed:playingMusic.icon];
    self.iconView.image = [UIImage imageNamed:playingMusic.icon];
    self.songLabel.text = playingMusic.name;
    self.singerLabel.text = playingMusic.singer;
    
    
    // 播放音乐并且获取播放的音乐
    AVAudioPlayer *currentPlayer = [ARAVdioTool playingMusicWithMusicFileName:playingMusic.filename];
    self.currentTimeLabel.text = [NSString stringWithTime:currentPlayer.currentTime];
    self.totalTimeLabel.text = [NSString stringWithTime:currentPlayer.duration];
    self.currentPlayer = currentPlayer;
    
    
    self.playWithPauseBtn.selected = currentPlayer.isPlaying;
    if (self.playWithPauseBtn.selected) {
        [self.playWithPauseBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    } else {
        [self.playWithPauseBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    }
    
    // 获取歌词名字
    self.lrcScrollView.lrcName = playingMusic.lrcname;
    // 获取歌曲时间
    self.lrcScrollView.duration = currentPlayer.duration;
    
    // 旋转动画
    [self addIconViewAnimate];

    [self removeProgressTimer];
    [self addProgressTimer];
    // 添加歌词定时器
    [self removeLrcTimer];
    [self addLrcTimer];
}

#pragma mark - 播放时间进度条的处理

-(void)addProgressTimer
{
    [self upDateProgressInfo];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(upDateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

-(void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

-(void)upDateProgressInfo
{
    // 1.更新播放的时间
    self.currentTimeLabel.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    // 2.更新滑动条
    self.progressSlider.value = self.currentPlayer.currentTime / self.currentPlayer.duration;
}

#pragma mark - 歌词定时器
- (void)addLrcTimer
{
    self.lrcTiemr = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrcInfo)];
    [self.lrcTiemr addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeLrcTimer
{
    [self.lrcTiemr invalidate];
    self.lrcTiemr = nil;
}

#pragma mark  更新歌词
- (void)updateLrcInfo
{
    self.lrcScrollView.currentTime = self.currentPlayer.currentTime;
}

#pragma mark - 添加iconView的转动动画
- (void)addIconViewAnimate
{
    CABasicAnimation *rotateAnimate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimate.fromValue = @(0);
    rotateAnimate.toValue = @(M_PI * 2);
    rotateAnimate.repeatCount = NSIntegerMax;
    rotateAnimate.duration = 36;
    [self.iconView.layer addAnimation:rotateAnimate forKey:nil];
}

#pragma mark - 中间头像的布局
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    // .添加圆角
    self.iconView.layer.cornerRadius = self.iconView.bounds.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderColor = ARColor(36, 36, 36, 1.0).CGColor;
    self.iconView.layer.borderWidth = 5;
}

- (void)playMusicWithMusic:(ARMusicModel *)muisc
{
    // 获取当前播放的音乐并停止
    ARMusicModel *playingMusic = [ARMusicTool playingMusic];
    [ARAVdioTool stopMusicWithMusicFileName:playingMusic.filename];
    
    // 设置下一首或者上一首为默认播放音乐
    [ARMusicTool setUpPlayingMusic:muisc];
    // 更新界面
    [self startPlayingMusic];
}

#pragma mark - scrollView代理方法
// scrollView 滚动过程中不停的调用。利用此使歌手图片和lrcLabel渐渐消失
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offcetPoint = scrollView.contentOffset;
    
    CGFloat alpha = 1 - offcetPoint.x / self.view.frame.size.width;
    
    self.iconView.alpha = alpha;
    self.lrcLabel.alpha = alpha;
    
}

#pragma mark - 修改状态栏颜色
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - slider 事件处理
- (IBAction)startTouchSlider {
    [self removeProgressTimer];
}

- (IBAction)endTouchSlider {
    // 更新播放的时间
    self.currentPlayer.currentTime = self.progressSlider.value * self.currentPlayer.duration;
    [self addProgressTimer];
}

- (IBAction)progressValueChange:(id)sender {
    
    NSString *string = [NSString stringWithTime:self.progressSlider.value * self.currentPlayer.duration];
    self.currentTimeLabel.text = string;
}

- (IBAction)sliderClick:(UITapGestureRecognizer *)sender {
    
    // 获取点击到的点
    CGPoint point = [sender locationInView:sender.view];
    // 计算占全部长度的比例
    CGFloat num = point.x / self.progressSlider.frame.size.width;
    // 设置当前需要播放的时间
    self.currentPlayer.currentTime = num * self.currentPlayer.duration;
    // 更新slider
    [self upDateProgressInfo];
}

#pragma mark 底部开始上下首按钮的点击事件

- (IBAction)playWithPause:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.currentPlayer.playing) {
        // 1.暂停播放器
        [self.currentPlayer pause];
        // 2.移除定时器
        [self removeProgressTimer];
        // 3.暂停旋转动画
        [self.iconView.layer pauseAnimate];
    } else {
        // 1.开始播放
        [self.currentPlayer play];
        // 2.添加定时器
        [self addProgressTimer];
        // 3.恢复动画
        [self.iconView.layer resumeAnimate];
    }
}

- (IBAction)nextMusic {
    ARMusicModel *nextMusic = [ARMusicTool nextMusic];
    [self playMusicWithMusic:nextMusic];
}
- (IBAction)previousMusic {
    ARMusicModel *previousMusic = [ARMusicTool previousMusic];
    [self playMusicWithMusic:previousMusic];
}

@end
