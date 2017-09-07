//
//  ARLrcTableViewCell.h
//  ARQQMusic
//
//  Created by andyron on 2017/9/7.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARLrcLabel;
@interface ARLrcTableViewCell : UITableViewCell

@property (nonatomic, weak) ARLrcLabel *lrcLabel;

+ (ARLrcTableViewCell *)lrcCellWithTableView:(UITableView *)tableView;

@end
