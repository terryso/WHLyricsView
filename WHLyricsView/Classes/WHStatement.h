//
// Created by Nick on 15/5/7.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WHStatement : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, copy) NSArray * words;

@end