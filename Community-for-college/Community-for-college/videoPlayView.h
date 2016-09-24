//
//  videoPlayView.h
//  音频&视频
//
//  Created by 卖女孩的小火柴 on 16/8/8.
//  Copyright © 2016年 梁海洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface videoPlayView : UIView
+ (instancetype)sharedPlayerView:(CGRect)fram
                         withUrl:(NSString *)urlStr;


//- (void)layoutViewsWithUrl:(NSString *)urlStr;



//停止播放方法
- (void)endPlay;
//暂停方法
- (void)pauseAction;
//停止
- (void)backVideo;

@end
