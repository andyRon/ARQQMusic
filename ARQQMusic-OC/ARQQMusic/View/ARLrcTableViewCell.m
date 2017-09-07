//
//  ARLrcTableViewCell.m
//  ARQQMusic
//
//  Created by andyron on 2017/9/7.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARLrcTableViewCell.h"
#import "ARLrcLabel.h"

@implementation ARLrcTableViewCell

+ (ARLrcTableViewCell *)lrcCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    ARLrcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ARLrcTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ARLrcLabel *lrcLabel = [[ARLrcLabel alloc] init];
        lrcLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.contentView.frame.size.height);
        lrcLabel.textColor = [UIColor whiteColor];
        lrcLabel.textAlignment = NSTextAlignmentCenter;
        lrcLabel.font = [UIFont systemFontOfSize:14];
        self.lrcLabel = lrcLabel;
        [self.contentView addSubview:lrcLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
@end
