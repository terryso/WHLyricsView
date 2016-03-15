//
// Created by Nick on 15/5/7.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import "WHWord.h"


@implementation WHWord

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.offset=%i", self.offset];
    [description appendFormat:@", self.duration=%i", self.duration];
    [description appendString:@">"];
    return description;
}

@end