//
// Created by Nick on 15/5/7.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import "WHLyricsLabel.h"
#import "WHStatement.h"
#import "WHWord.h"

#define WH_TEXT_SIZE(text, font) [text length] > 0 ? [text \
        sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;

@interface WHLyricsLabel()

@property (nonatomic, strong) UILabel *backgroundLabel;
@property (nonatomic, strong) UILabel *animationLabel;
@property (nonatomic, strong) CALayer *maskLayer;

@end

@implementation WHLyricsLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        _backgroundLabel = [[UILabel alloc] init];
        _backgroundLabel.textColor = [UIColor whiteColor];
        _backgroundLabel.textAlignment = NSTextAlignmentCenter;
        _backgroundLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_backgroundLabel];

        _animationLabel = [[UILabel alloc] init];
        _animationLabel.textColor = [UIColor greenColor];
        _animationLabel.textAlignment = NSTextAlignmentCenter;
        _animationLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_animationLabel];

        _maskLayer = [CALayer layer];
        _maskLayer.backgroundColor = [[UIColor whiteColor] CGColor];    // Any color, only alpha channel matters
        _maskLayer.anchorPoint = CGPointZero;
        self.animationLabel.layer.mask = _maskLayer;
    }
    return self;
}

- (instancetype)initWithStatement:(WHStatement *)statement {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        //NSLog(@"statement: %@", statement);
        [self setStatement:statement];
    }
    return self;
}

+ (instancetype)labelWithStatement:(WHStatement *)statement {
    return [[self alloc] initWithStatement:statement];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundLabel = [[UILabel alloc] init];
        _backgroundLabel.textColor = [UIColor whiteColor];
        _backgroundLabel.textAlignment = NSTextAlignmentCenter;
        _backgroundLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_backgroundLabel];

        _animationLabel = [[UILabel alloc] init];
        _animationLabel.textColor = [UIColor greenColor];
        _animationLabel.textAlignment = NSTextAlignmentCenter;
        _animationLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_animationLabel];

        _maskLayer = [CALayer layer];
        _maskLayer.backgroundColor = [[UIColor whiteColor] CGColor];    // Any color, only alpha channel matters
        _maskLayer.anchorPoint = CGPointZero;
        self.animationLabel.layer.mask = _maskLayer;
    }
    return self;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.backgroundLabel.font = font;
    self.animationLabel.font = font;
}

- (void)setStatement:(WHStatement *)statement {
    _statement = statement;
    _backgroundLabel.text = _statement.text;
    _animationLabel.text = _statement.text;

    CGSize textSize = [self sizeWithFont:self.font];
    self.backgroundLabel.frame = CGRectMake(0, 0, textSize.width, textSize.height);
    self.animationLabel.frame = CGRectMake(0, 0, textSize.width, textSize.height);
    self.maskLayer.frame = CGRectOffset(self.animationLabel.frame, -CGRectGetWidth(self.animationLabel.frame), 0);
}

- (CGSize)sizeWithFont:(UIFont *)font {
    if (self.statement.text.length > 0 && font) {
        CGSize textSize = WH_TEXT_SIZE(self.statement.text, font);
        return textSize;
    }
    return CGSizeZero;
}

- (void)startAnimation {
    // Assume we calculated keyTimes and values

    NSMutableArray *keyTimes = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];

    CGSize textSize = [self sizeWithFont:self.font];
    CGFloat v = (CGFloat) (textSize.width / (self.statement.words.count));
    for (int i = 0; i < self.statement.words.count; ++i) {
        WHWord *word = self.statement.words[i];
        CGFloat keyTime = (CGFloat) (word.offset / 1.0 / self.statement.duration);
        [keyTimes addObject:@(keyTime)];

        NSValue *value = [NSValue valueWithCGPoint:CGPointMake(_maskLayer.position.x + v * i, 0)];
        [values addObject:value];

        if (i == self.statement.words.count - 1) {
            [keyTimes addObject:@(1.0)];

            NSValue *lastValue = [NSValue valueWithCGPoint:CGPointMake(_maskLayer.position.x + v * (i + 1), 0)];
            [values addObject:lastValue];
        }
    }

    //NSLog(@"keyTimes: %@", keyTimes);
    //NSLog(@"values: %@", values);

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.keyTimes = keyTimes;
    animation.values = values;
    animation.duration = self.statement.duration / 1000.0;
    animation.calculationMode = kCAAnimationLinear;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    [_maskLayer addAnimation:animation forKey:@"WHLyricsMaskAnimation"];
}

- (void)resetMask {
    CGSize textSize = [self sizeWithFont:self.font];
    self.backgroundLabel.frame = CGRectMake(0, 0, textSize.width, textSize.height);
    self.animationLabel.frame = CGRectMake(0, 0, textSize.width, textSize.height);
    self.maskLayer.frame = CGRectOffset(self.animationLabel.frame, -CGRectGetWidth(self.animationLabel.frame), 0);

    self.maskLayer.position = CGPointMake(-CGRectGetWidth(self.animationLabel.frame), 0);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"animationDidStop" object:nil];
    }
}

@end