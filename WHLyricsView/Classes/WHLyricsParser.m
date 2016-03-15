//
// Created by Nick on 15/5/7.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import "WHLyricsParser.h"
#import "WHStatement.h"
#import "WHWord.h"

@implementation WHLyricsParser

+ (NSArray *)parse:(NSString *)lrcString {
    //DLog(@"lrcString: %@", lrcString);
    NSArray *lines = [lrcString componentsSeparatedByString:@"\n"];
    NSError *error = nil;
    NSString *statementPattern = @"\\[[0-9]*,[0-9]*]";
    NSString *wordPattern = @"<[0-9]*,[0-9]*,[0-9]*>";
    NSRegularExpression *statementExpression = [NSRegularExpression regularExpressionWithPattern:statementPattern options:0 error:&error];
    NSRegularExpression *wordExpression = [NSRegularExpression regularExpressionWithPattern:wordPattern options:0 error:&error];
    NSString *currentLine;
    NSMutableArray *statements = [NSMutableArray array];
    for (NSString *line in lines) {
        NSTextCheckingResult *statementMatch = [statementExpression firstMatchInString:line options:NSMatchingReportCompletion range:NSMakeRange(0, [line length])];
        if (!statementMatch) {
            continue;
        }
        WHStatement *statement = [[WHStatement alloc] init];
        NSMutableArray *words = [NSMutableArray array];
        NSString *statementTime = [line substringWithRange:[statementMatch range]];
        currentLine = [line stringByReplacingOccurrencesOfString:statementTime withString:@""];
        NSArray *wordMatches = [wordExpression matchesInString:line options:NSMatchingReportCompletion range:NSMakeRange(0, [line length])];
        if (wordMatches.count > 0) {
            for (NSTextCheckingResult *math in wordMatches) {
                WHWord *word = [[WHWord alloc] init];
                NSRange wordRange = [math range];
                NSString *wordTime = [line substringWithRange:wordRange];
                NSArray *wordTimeArray = [[wordTime substringWithRange:NSMakeRange(1, wordTime.length - 2)] componentsSeparatedByString:@","];
                word.offset = [[wordTimeArray firstObject] integerValue];
                word.duration = [wordTimeArray[1] integerValue];
                [words addObject:word];
                currentLine = [currentLine stringByReplacingOccurrencesOfString:wordTime withString:@""];
            }
        }
        NSArray *statementArray = [[statementTime substringWithRange:NSMakeRange(1, statementTime.length - 2)] componentsSeparatedByString:@","];
        statement.start = [[statementArray firstObject] integerValue];
        statement.duration = [statementArray[1] integerValue];
        statement.text = [currentLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        statement.words = words;
        [statements addObject:statement];
    }
    [self updateDurations:statements];
    return statements;
}

+ (void)updateDurations:(NSArray *)statements {
    for (int i = 0; i < statements.count; i++) {
        WHStatement *st = statements[i];
        if (st.duration > 0)
            continue;

        WHWord *lastWord = [st.words lastObject];
        if (lastWord) {
            st.duration = lastWord.offset + lastWord.duration;
        }
    }

    for (WHStatement *statement in statements) {
        for (int i = 0; i < statement.words.count; i++) {
            WHWord *word = statement.words[i];
            if (word.duration > 0)
                continue;

            if (i == statement.words.count - 1)
                continue;

            WHWord *nextWord = statement.words[i + 1];
            word.duration = nextWord.offset - word.offset;
        }
    }
}

@end