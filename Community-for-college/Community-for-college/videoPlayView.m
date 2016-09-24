//
//  videoPlayView.m
//  音频&视频
//
//  Created by 卖女孩的小火柴 on 16/8/8.
//  Copyright © 2016年 梁海洋. All rights reserved.
//


#import "videoPlayView.h"
#import <AVFoundation/AVFoundation.h>
#import "LearningVideoViewController.h"
#import "LearingModel.h"
#import "UIView_extra.h"

@interface videoPlayView ()
//资源文件
@property (nonatomic,strong)AVPlayerItem *item;
//播放对象
@property (nonatomic,strong)AVPlayer *player;
//layer
@property (nonatomic,strong)AVPlayerLayer *playerLayer;
//播放还是暂停按钮
@property (nonatomic,strong)UIButton *playerOrPauseButton;
//是否正在播放
@property (nonatomic,assign)BOOL playing;
//定时器
@property (nonatomic,strong)NSTimer *timer;
//slider
@property (nonatomic,strong)UISlider *timeSlider;
//timeLabel
@property (nonatomic,strong)UILabel *timerLable;
//bufferProgressVire（缓存进度）
@property (nonatomic,strong)UIProgressView *bufferProgressVire;
//进度条上的滑条
@property (nonatomic,strong)UIButton *processThumbButton;


//model
@property (nonatomic,strong)LearingModel *model;
@end

static videoPlayView *playerView = nil;

@implementation videoPlayView

+ (instancetype)sharedPlayerView:(CGRect)fram
                         withUrl:(NSString *)urlStr
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //初始化
        playerView = [[videoPlayView alloc]initWithFrame:fram];
    });
    
    //
    [playerView layoutViewsWithUrl:urlStr];
    return playerView;
}

- (void)layoutViewsWithUrl:(NSString *)urlStr
{
    //实例化子视图
    
    self.item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:urlStr]];
    //player
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.item];
    //[self.player replaceCurrentItemWithPlayerItem:self.item];
    
    
    
    //playerLayer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    //视频填充模式
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//还有其他的设置屏幕显示方法
    self.playerLayer.frame = self.bounds;
    //将layer放到父视layer层
    [self.layer addSublayer:self.playerLayer];
    
    
    //播放或者暂停按钮
    self.playerOrPauseButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.playerOrPauseButton addTarget:self action:@selector(playerOrPauseButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.playerOrPauseButton.frame = CGRectMake(self.frame.size.width / 2 - 20, self.frame.size.height / 2 - 20, 40, 40);
    [self.playerOrPauseButton setImage:[UIImage imageNamed:@"2暂停"] forState:(UIControlStateNormal)];
    [self addSubview:self.playerOrPauseButton];
    
    //progressView
    self.bufferProgressVire = [[UIProgressView alloc]initWithProgressViewStyle:(UIProgressViewStyleDefault)];
    self.bufferProgressVire.tintColor = [UIColor redColor];
    self.bufferProgressVire.frame = CGRectMake(30, CGRectGetHeight(self.bounds) - 200 + 15 , CGRectGetWidth(self.bounds) - 60, 30);
    [self addSubview:self.bufferProgressVire];
    
    
    //slider
    self.timeSlider = [[UISlider alloc]initWithFrame:CGRectMake(28, CGRectGetHeight(self.bounds) - 201 , CGRectGetWidth(self.bounds) - 58, 33)];
    //划过的颜色
    self.timeSlider.minimumTrackTintColor = [UIColor cyanColor];
    //slider的颜色
    self.timeSlider.maximumTrackTintColor = [UIColor clearColor];
    self.timeSlider.minimumValue = 0;//先不设置最大值
    //初始值为0
    self.timeSlider.value = 0;
    [self.timeSlider addTarget:self action:@selector(timeSliderAction) forControlEvents:(UIControlEventValueChanged)];
    [self addSubview:self.timeSlider];
    //        self.timeSlider.maximumValue = 1.0;
    
    //timerLable
    self.timerLable = [[UILabel alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(self.timeSlider.frame) + 20, self.frame.size.height - 50, 150, 30))];
    [self addSubview:self.timerLable];
    
    //kvo 监听播放状态
    [self.item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
    //kvo监听缓存进度值
    [self.item addObserver:self forKeyPath:@"loadedTimeRanges" options:(NSKeyValueObservingOptionNew) context:nil];
    
    //注册通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(endPlay) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

}

//自定义初始化方法
- (instancetype)initWithFrame:(CGRect)frame
                      withUrl:(NSString *)urlStr
{
    self = [super initWithFrame:(frame)];
    if (self) {
        //实例化子视图
        //item
        self.item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:urlStr]];
        //player
        self.player = [[AVPlayer alloc]initWithPlayerItem:self.item];
        //playerLayer
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        //视频填充模式
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//还有其他的设置屏幕显示方法
        self.playerLayer.frame = self.bounds;
        //将layer放到父视layer层
        [self.layer addSublayer:self.playerLayer];
        
        
        //播放或者暂停按钮
        self.playerOrPauseButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.playerOrPauseButton addTarget:self action:@selector(playerOrPauseButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
        self.playerOrPauseButton.frame = CGRectMake(self.frame.size.width / 2 - 20, self.frame.size.height / 2 - 20, 40, 40);
        [self.playerOrPauseButton setImage:[UIImage imageNamed:@"2暂停"] forState:(UIControlStateNormal)];
        [self addSubview:self.playerOrPauseButton];
        
        //progressView
        self.bufferProgressVire = [[UIProgressView alloc]initWithProgressViewStyle:(UIProgressViewStyleDefault)];
        self.bufferProgressVire.tintColor = [UIColor redColor];
        self.bufferProgressVire.frame = CGRectMake(30, CGRectGetHeight(self.bounds) - 50 +15, CGRectGetWidth(self.bounds) - 60, 30);
        [self addSubview:self.bufferProgressVire];
        
        
        //slider
        self.timeSlider = [[UISlider alloc]initWithFrame:CGRectMake(30, CGRectGetHeight(self.bounds) - 50 + 1, CGRectGetWidth(self.bounds) - 60, 30)];
        //划过的颜色
        self.timeSlider.minimumTrackTintColor = [UIColor cyanColor];
        //slider的颜色
        self.timeSlider.maximumTrackTintColor = [UIColor clearColor];
        self.timeSlider.minimumValue = 0;//先不设置最大值
        //初始值为0
        self.timeSlider.value = 0;
        [self.timeSlider addTarget:self action:@selector(timeSliderAction) forControlEvents:(UIControlEventValueChanged)];
        [self addSubview:self.timeSlider];
//        self.timeSlider.maximumValue = 1.0;
        
        //timerLable
        self.timerLable = [[UILabel alloc]initWithFrame:(CGRectMake(100, 600, 150, 30))];
        [self addSubview:self.timerLable];
        
        //kvo 监听播放状态
        [self.item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
        //kvo监听缓存进度值
        [self.item addObserver:self forKeyPath:@"loadedTimeRanges" options:(NSKeyValueObservingOptionNew) context:nil];
        
        //注册通知
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(endPlay) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    }
    return self;
}


//KVO监听触发方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //播放状态
    if ([keyPath isEqualToString:@"status"]) {
        NSInteger status = [change[@"new"] integerValue];
             //获取到状态值（枚举值）
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"可以开始播放！");
                
                //设置slider的最大值
                self.timeSlider.maximumValue = CMTimeGetSeconds(self.item.duration);
                NSLog(@"--------%.2f分钟",self.timeSlider.maximumValue / 60);
                //播放方法
                [self pauseAction];
                
                
                
                break;
                
                
                case AVPlayerItemStatusFailed:
                NSLog(@"失败了!");
                break;
            
                case AVPlayerItemStatusUnknown:
                NSLog(@"出现未知情况");
                break;
                
            default:
                break;
                
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
                    
      //进度条
        NSArray *arr = change[@"new"];
        CMTimeRange rang = [arr.lastObject CMTimeRangeValue];
        
        //progres
        float time = CMTimeGetSeconds(rang.start) + CMTimeGetSeconds(rang.duration);
        float progressValue = time / CMTimeGetSeconds(self.item.duration);
                    
        self.bufferProgressVire.progress = progressValue;
                    
    }
}


#pragma mark ------ 播放方法 ------
//播放方法
- (void)playAction
{
    
    self.playing = YES;
    [self.player play];
    //
    self.playerOrPauseButton.alpha = 0.1;
    
//    [self.playerOrPauseButton setHidden:YES];
    [self.playerOrPauseButton setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
    //关联slider timerLabel
    //设置定时器
    if (self.timer) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];

}

//暂停方法
- (void)pauseAction
{
    self.playing = NO;
    [self.player pause];
    //改变button的alpha值
    self.playerOrPauseButton.alpha = 1.0;
    UIImage *pauseImage = [UIImage imageNamed:@"2暂停"];
    [self.playerOrPauseButton setImage:pauseImage forState:(UIControlStateNormal)];
    //销毁定时器
    [self.timer invalidate];
    self.timer = nil;
    
}


//如果播放完毕，调用方法
- (void)endPlay
{
   
    self.timeSlider.value = 0;
    NSLog(@"播放完毕");
    [self pauseAction];
    
    [self.player seekToTime:CMTimeMake(0, 1)];

    
    
}
- (void)backVideo
{
    [self.player pause];
    self.player = nil;
    
    self.item = nil;
    [self.timeSlider removeFromSuperview];
    self.timeSlider = nil;
    
//    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    
    [self.playerOrPauseButton removeFromSuperview];
    self.playerOrPauseButton = nil;
    
    [self.timerLable removeFromSuperview];
    self.timerLable = nil;
    
    [self.bufferProgressVire removeFromSuperview];
    self.bufferProgressVire = nil;

    [self.player replaceCurrentItemWithPlayerItem:nil];
}

//button的点击方法
- (void)playerOrPauseButtonAction
{
    
    if (self.playing == NO) {
        
        
        [self playAction];
    }
    else
    {
 
        [self pauseAction];
    }
    
}



#pragma mark ------ timer 触发事件 ------
- (void)timerAction
{
    
    //设置slider进度
    self.timeSlider.value = self.timeSlider.value + 1;
    //设置timeLable的text
    [self setLableTimeWithTime:self.timeSlider.value];
    
}

//- (void)timerAction
//{
//    
//    //设置slider进度
//    self.timeSlider.value = self.timeSlider.value + 1;
//    //设置timeLable的text
//    [self setLableTimeWithTime:self.timeSlider.value];
//    
//    //计算进度
//    double progress = (self.player.currentTime.value / self.player.currentTime.timescale) / (self.model.endTime / 1000.0);
//    //设置滑动的最大位置
//    double thumbMacSlider = self.frame.size.width - self.processThumbButton.frame.size.width;
//    
//    //设置滑块的位置
//    self.processThumbButton.x = progress *thumbMacSlider;
//    
//    // 设置当前播放的时间
//    [self.processThumbButton setTitle:[self stringWithTimeSeconds:(self.player.currentTime.value / self.player.currentTime.timescale)] forState:UIControlStateNormal];
//
//}

#pragma mark 将事件秒转化为分钟:秒的字符串形式
-(NSString *)stringWithTimeSeconds:(NSTimeInterval)timeSeconds
{
    int m = timeSeconds / 60;
    int s = (int)timeSeconds % 60;
    return [NSString stringWithFormat:@"%02d:%02d",m,s];
    
}
#pragma mark ------ 设置label的显示时间 ------ 
- (void)setLableTimeWithTime:(float)time
{
    //获取到当前的分钟 和 秒
    int minuts = time / 60;//分钟
    int seconds = (int)time % 60;//秒
    
    int totalMinuts = CMTimeGetSeconds(self.item.duration);
    int totalSecondes = (int)CMTimeGetSeconds(self.item.duration) % 60;
    
    //设置label
    NSString *str = [NSString stringWithFormat:@"%.2d:%.2d/%.2d:%.2d",minuts,seconds,totalMinuts,totalSecondes];
    self.timerLable.text = str;
    
}


- (void)timeSliderAction
{
    //先暂停
    [self pauseAction];
    //设置到当前要播放的时间在进行播放
    [self.player seekToTime:CMTimeMakeWithSeconds(self.timeSlider.value, self.item.currentTime.timescale) completionHandler:^(BOOL finished) {
        //播放
        [self playAction];
    }];
    
    
}
@end
