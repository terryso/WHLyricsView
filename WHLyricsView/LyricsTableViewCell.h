//
// Created by Nick on 15/5/8.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@class WHStatement;
@class WHLyricsLabel;

@interface LyricsTableViewCell : UITableViewCell

@property (nonatomic, strong) WHLyricsLabel *lyricsLabel;

- (void)setStatement:(WHStatement *)statement;

@end