//
//  GameVideoViewController.m
//  Community-for-college
//
//  Created by 卖女孩的小火柴 on 16/8/30.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "GameVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface GameVideoViewController ()

@end

@implementation GameVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        self.view.backgroundColor = [UIColor blackColor];
        NSURL *url = [NSURL URLWithString:_videoURL];
        NSLog(@"=========%@",_videoURL);
        AVPlayerViewController * play = [[AVPlayerViewController alloc]init];
        play.player = [[AVPlayer alloc]initWithURL:url];
        [self presentViewController:play animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
