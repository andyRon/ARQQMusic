//
//  ARMusicModel.m
//  ARQQMusic
//
//  Created by andyron on 2017/9/7.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARMusicModel.h"

@implementation ARMusicModel

+ (NSArray *)getAll
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Musics" ofType:@"plist"];
    
    NSMutableArray *musics = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    
    NSMutableArray *res = [NSMutableArray new];
    
    for (NSInteger i = 0; i < musics.count; i++) {
        NSDictionary *dic = musics[i];
        
        ARMusicModel *musicModel = [[ARMusicModel alloc] init];
        musicModel.name = dic[@"name"];
        musicModel.name = dic[@"filename"];
        musicModel.name = dic[@"lrcname"];
        musicModel.name = dic[@"singer"];
        musicModel.name = dic[@"singerIcon"];
        musicModel.name = dic[@"icon"];
                           
        [musicModel setValuesForKeysWithDictionary:dic];
        
        [res addObject:musicModel];
    }
    
    return [NSArray arrayWithArray:res];
}

@end
