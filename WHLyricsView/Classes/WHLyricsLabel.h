//
// Created by Nick on 15/5/7.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@class WHStatement;

@interface WHLyricsLabel : UIView

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) WHStatement *statement;

+ (instancetype)labelWithStatement:(WHStatement *)statement;
- (instancetype)initWithStatement:(WHStatement *)statement;

- (CGSize)sizeWithFont:(UIFont *)font;
- (void)startAnimation;
- (void)resetMask;

@end