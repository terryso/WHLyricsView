//
// Created by Nick on 15/5/7.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import "WHStatement.h"


@implementation WHStatement

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.text=%@", self.text];
    [description appendFormat:@", self.start=%i", self.start];
    [description appendFormat:@", self.duration=%i", self.duration];
    [description appendFormat:@", self.words=%@", self.words];
    [description appendString:@">"];
    return description;
}

@end