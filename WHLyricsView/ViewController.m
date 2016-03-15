//
//  ViewController.m
//  WHLyricsView
//
//  Created by Nick on 15/5/7.
//  Copyright (c) 2015 WeHack Studio. All rights reserved.
//


#import "ViewController.h"
#import "WHLyricsLabel.h"
#import "WHStatement.h"
#import "WHLyricsParser.h"
#import "LyricsTableViewCell.h"
@import AVFoundation;

@interface ViewController ()

@property (strong, nonatomic) NSArray *statements;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation ViewController {
    NSInteger currentIndex;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"animationDidStop" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNextStatement) name:@"animationDidStop" object:nil];

    self.title = @"爱与痛的边缘";

    NSString *lrcPath = [[NSBundle mainBundle] pathForResource:@"爱与痛的边缘" ofType:@"lrc"];
    NSString *lrcString = [NSString stringWithContentsOfFile:lrcPath encoding:NSUTF8StringEncoding error:nil];

    //NSString *text = @"[19753,8773]<0,551,0>徘<551,249,0>徊<800,288,0>傍<1088,307,0>徨<1395,299,0>路<1694,1417,0>前 <3111,326,0>回<3437,390,0>望<3827,300,0>这<4127,398,0>一<4525,4241,0>段";
    self.statements = [WHLyricsParser parse:lrcString];
    [self.tableView reloadData];

    LyricsTableViewCell *cell = (LyricsTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.lyricsLabel startAnimation];

    NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"爱与痛的边缘" ofType:@"mp3"];
    NSURL *mp3URL = [NSURL fileURLWithPath:mp3Path];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:mp3URL error:nil];
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];

}

- (void)updateNextStatement {
    [self.tableView reloadData];
    currentIndex ++;
    LyricsTableViewCell *cell = (LyricsTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
    [cell.lyricsLabel startAnimation];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statements.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyricsTableViewCell *lrcCell = [tableView dequeueReusableCellWithIdentifier:@"lrcCell"];
    WHStatement *statement = self.statements[indexPath.row];
    [lrcCell setStatement:statement];
    return lrcCell;
}


@end