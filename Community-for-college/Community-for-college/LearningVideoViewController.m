//
//  LearningVideoViewController.m
//  EnglishiLearing
//
//  Created by 卖女孩的小火柴 on 16/8/21.
//  Copyright © 2016年 梁海洋. All rights reserved.
//

#import "LearningVideoViewController.h"
#import "videoPlayView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#import "GameModel.h"

@interface LearningVideoViewController ()
@property (nonatomic, strong) CAEmitterLayer *caELayer;
@property (nonatomic,strong) videoPlayView *video_playView;

@end

@implementation LearningVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor       = [UIColor blackColor];
    self.caELayer                   = [CAEmitterLayer layer];
    // 发射源
    self.caELayer.emitterPosition   = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 50);
    // 发射源尺寸大小
    self.caELayer.emitterSize       = CGSizeMake(50, 0);
    // 发射源模式
    self.caELayer.emitterMode       = kCAEmitterLayerOutline;
    // 发射源的形状
    self.caELayer.emitterShape      = kCAEmitterLayerLine;
    // 渲染模式
    self.caELayer.renderMode        = kCAEmitterLayerAdditive;
    // 发射方向
    self.caELayer.velocity          = 1;
    // 随机产生粒子
    self.caELayer.seed              = (arc4random() % 100) + 1;
    
    // cell
    CAEmitterCell *cell             = [CAEmitterCell emitterCell];
    // 速率
    cell.birthRate                  = 3.0;
    // 发射的角度
    cell.emissionRange              = 0.11 * M_PI;
    // 速度
    cell.velocity                   = 300;
    // 范围
    cell.velocityRange              = 150;
    // Y轴 加速度分量
    cell.yAcceleration              = 75;
    // 声明周期
    cell.lifetime                   = 2.04;
    //是个CGImageRef的对象,既粒子要展现的图片
    cell.contents                   = (id)
    [[UIImage imageNamed:@"FFRing"] CGImage];
    // 缩放比例
    cell.scale                      = 0.2;
    // 粒子的颜色
    cell.color                      = [[UIColor colorWithRed:0.6
                                                       green:0.6
                                                        blue:0.6
                                                       alpha:1.0] CGColor];
    // 一个粒子的颜色green 能改变的范围
    cell.greenRange                 = 1.0;
    // 一个粒子的颜色red 能改变的范围
    cell.redRange                   = 1.0;
    // 一个粒子的颜色blue 能改变的范围
    cell.blueRange                  = 1.0;
    // 子旋转角度范围
    cell.spinRange                  = M_PI;
    
    // 爆炸
    CAEmitterCell *burst            = [CAEmitterCell emitterCell];
    // 粒子产生系数
    burst.birthRate                 = 1.0;
    // 速度
    burst.velocity                  = 0;
    // 缩放比例
    burst.scale                     = 2.5;
    // shifting粒子red在生命周期内的改变速度
    burst.redSpeed                  = -1.5;
    // shifting粒子blue在生命周期内的改变速度
    burst.blueSpeed                 = +1.5;
    // shifting粒子green在生命周期内的改变速度
    burst.greenSpeed                = +1.0;
    //生命周期
    burst.lifetime                  = 0.35;
    
    
    // 火花 and finally, the sparks
    CAEmitterCell *spark            = [CAEmitterCell emitterCell];
    //粒子产生系数，默认为1.0
    spark.birthRate                 = 400;
    //速度
    spark.velocity                  = 125;
    // 360 deg//周围发射角度
    spark.emissionRange             = 2 * M_PI;
    // gravity//y方向上的加速度分量
    spark.yAcceleration             = 75;
    //粒子生命周期
    spark.lifetime                  = 3;
    //是个CGImageRef的对象,既粒子要展现的图片
    spark.contents                  = (id)
    [[UIImage imageNamed:@"FFTspark"] CGImage];
    //缩放比例速度
    spark.scaleSpeed                = -0.2;
    //粒子green在生命周期内的改变速度
    spark.greenSpeed                = -0.1;
    //粒子red在生命周期内的改变速度
    spark.redSpeed                  = 0.4;
    //粒子blue在生命周期内的改变速度
    spark.blueSpeed                 = -0.1;
    //粒子透明度在生命周期内的改变速度
    spark.alphaSpeed                = -0.25;
    //子旋转角度
    spark.spin                      = 2* M_PI;
    //子旋转角度范围
    spark.spinRange                 = 2* M_PI;
    
    
    self.caELayer.emitterCells = [NSArray arrayWithObject:cell];
    cell.emitterCells = [NSArray arrayWithObjects:burst, nil];
    burst.emitterCells = [NSArray arrayWithObject:spark];
//    [self.view.layer addSublayer:self.caELayer];
    

    
    //返回按钮
    UIImage *backImage = [[UIImage imageNamed:@"返回.png"] imageWithRenderingMode:(UIImageRenderingModeAutomatic)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:backImage style:(UIBarButtonItemStylePlain) target:self action:@selector(backButton)];
    
    
    
    
    
//        self.title = _videoTitle;
//        NSURL *url = [NSURL URLWithString:_videoURL];
//        AVPlayerViewController * play = [[AVPlayerViewController alloc]init];
//        play.player = [[AVPlayer alloc]initWithURL:url];
//        [self presentViewController:play animated:YES completion:nil];
   
        
//        self.title = _videoModel.title;
//        NSURL *url = [NSURL URLWithString:_videoModel.videourl];
//        AVPlayerViewController * play = [[AVPlayerViewController alloc]init];
//        play.player = [[AVPlayer alloc]initWithURL:url];
//        [self presentViewController:play animated:YES completion:nil];
    
    
    
    
}

- (void)backButton
{
    
    
    
    [_video_playView backVideo];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#pragma mark ------ 视频 ------
   
    self.title = _videoModel.title;
    NSLog(@"%@",_videoModel.videourl);
    
    _video_playView = [videoPlayView sharedPlayerView:self.view.frame withUrl:_videoModel.videourl];
    
    [self.view addSubview:_video_playView];
    
}




//根据视频索引取得AVPlayerItem对象
- (AVPlayerItem *)getPlayerItem{
    
   
    NSURL *url = [NSURL URLWithString:_videoModel.videourl];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    
    return playerItem;
    
}





@end
