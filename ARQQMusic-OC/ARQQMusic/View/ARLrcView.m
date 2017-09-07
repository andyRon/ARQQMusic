//
//  ARLrcView.m
//  ARQQMusic
//
//  Created by andyron on 2017/9/7.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARLrcView.h"
#import "ARLrcTableViewCell.h"
#import "ARLrcLabel.h"
#import "ARLrcLine.h"
#import "ARLrcTool.h"

@interface ARLrcView ()<UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

// 歌词数组
@property (nonatomic, strong) NSArray *lrcList;

// 当前歌词下标
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation ARLrcView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupTableView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupTableView];
    }
    return self;
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    [self addSubview:tableView];
    self.tableView = tableView;
    tableView.dataSource = self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.tableView.frame = CGRectMake(bounds.size.width,  0, bounds.size.width, bounds.size.height - 100 - 150);
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.rowHeight = 40;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.bounds.size.height * 0.5, 0, self.tableView.bounds.size.height * 0.5, 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ARLrcTableViewCell *cell = [ARLrcTableViewCell lrcCellWithTableView:tableView];
    
    if (self.currentIndex == indexPath.row) {
        cell.lrcLabel.font = [UIFont systemFontOfSize:20];
    } else {
        cell.lrcLabel.font = [UIFont systemFontOfSize:14];
        cell.lrcLabel.progress = 0;
    }
    
    // 获取当前歌词
    ARLrcLine *lrcLine = self.lrcList[indexPath.row];
    cell.lrcLabel.text = lrcLine.text;
    
    return cell;
}

- (void)setLrcName:(NSString *)lrcName
{
    self.currentIndex = 0;
    
    _lrcName = lrcName;
    
    self.lrcList = [ARLrcTool lrcToolWithLrcName:lrcName];
    
    ARLrcLine *lrcLine = self.lrcList[0];
    self.lrcLabel.text = lrcLine.text;
    
    [self.tableView reloadData];
}

#pragma mark - 当前播放时间
- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    // 记录当前时间
    _currentTime = currentTime;
    // 获取歌词行数
    NSInteger count = self.lrcList.count;
    for (int i = 0; i < count; i ++) {
        // 获取i位置的歌词
        ARLrcLine *currentLrcLine = self.lrcList[i];
        // 获取下一句歌词
        NSInteger nextIndex = i + 1;
        // 先创建空的歌词模型
        ARLrcLine *nextLrcLine = nil;
        // 判断歌词是否存在
        if (nextIndex < self.lrcList.count) {
            // 说明存在
            nextLrcLine = self.lrcList[nextIndex];
        }
        // 用播放器的当前的时间和i位置歌词、i+1位置歌词的时间进行比较，如果大于等于i位置的时间并且小于等于i+1歌词的时间，说明应该显示i位置的歌词。
        // 并且如果正在显示的就是这行歌词则不用重复判断
        if (self.currentIndex != i && currentTime >= currentLrcLine.time && currentTime < nextLrcLine.time) {
            
            // 2.8设置主页上的歌词
            self.lrcLabel.text = currentLrcLine.text;
            
            // 将当前播放的歌词移动到中间
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            // 记录上一句位置，当移动到下一句时，上一句和当前这一句都需要进行更新行
            NSIndexPath *previousPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            // 记录当前播放的下标。下次来到这里，currentIndex指的就是上一句
            self.currentIndex = i;
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath,previousPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        if (self.currentIndex == i) {
            // 获取播放速度 已经播放的时间 / 播放整句需要的时间
            CGFloat progress = (currentTime - currentLrcLine.time) / (nextLrcLine.time - currentLrcLine.time);
            // 获取当前行数的cell
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            ARLrcTableViewCell *lrccell = [self.tableView cellForRowAtIndexPath:indexPath];
            lrccell.lrcLabel.progress = progress;
            self.lrcLabel.progress = progress;
        }
    }
}

@end
