//
// Created by Nick on 15/5/8.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import "LyricsTableViewCell.h"
#import "WHLyricsLabel.h"
#import "WHStatement.h"

@interface LyricsTableViewCell()

@end

@implementation LyricsTableViewCell

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _lyricsLabel = [[WHLyricsLabel alloc] init];
        _lyricsLabel.font = [UIFont systemFontOfSize:18.0];
        [self.contentView addSubview:_lyricsLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGSize textSize = [self.lyricsLabel sizeWithFont:self.lyricsLabel.font];
    CGRect lyricsFrame = CGRectMake((self.contentView.bounds.size.width - textSize.width) / 2, (self.contentView.bounds.size.height - textSize.height) / 2, textSize.width, textSize.height);
    self.lyricsLabel.frame = lyricsFrame;
}

- (void)setStatement:(WHStatement *)statement {
    _lyricsLabel.statement = statement;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_lyricsLabel resetMask];
}

@end