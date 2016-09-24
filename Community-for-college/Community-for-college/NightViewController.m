//
//  NightViewController.m
//  Community-for-college
//
//  Created by 卖女孩的小火柴 on 16/8/26.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "NightViewController.h"
#import "XTLoveHeartView.h"
#import "AppDelegate.h"

@interface NightViewController ()
//烟花爆竹
@property (nonatomic, strong) CAEmitterLayer *caELayer;
//判断夜间模式
@property (nonatomic,strong)NSString *strNight;
@property (nonatomic,strong)UIButton *change_BT;
@property (nonatomic,strong)NSUserDefaults *userDefault;
@end

@implementation NightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255 green:88.0/255 blue:135.0/255 alpha:1];
    
    

    //点赞
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"darong"];
    [self.view addSubview:imageView];
    
    [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(showLoveHeartView) userInfo:nil repeats:YES];
    
    
    
    self.change_BT = [UIButton buttonWithType:UIButtonTypeSystem];
    _change_BT.frame = CGRectMake(80, 170, 100, 100);
    [_change_BT addTarget:self action:@selector(changColor:) forControlEvents:UIControlEventTouchDown];
//    [_change_BT setBackgroundImage:[UIImage imageNamed:@"night"] forState:UIControlStateNormal];


    [_change_BT setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

    [self.view insertSubview:_change_BT aboveSubview:imageView];
//    _change_BT.hidden = YES;
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:(CGRectMake(0, 30, 100, 40))];
    label.text = @"憋说话,怼我";
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [_change_BT addSubview:label];

    
}

- (void)showLoveHeartView
{
    XTLoveHeartView *heart = [[XTLoveHeartView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(self.view.frame.size.width - 80, self.view.bounds.size.height - 30 / 2.0 - 10);
    heart.center = fountainSource;
    [heart animateInView:self.view];
}
- (void)viewWillAppear:(BOOL)animated
{
    _userDefault = [NSUserDefaults standardUserDefaults];
    [self changeNight];
}
- (void)changeNight
{
    
    _strNight = [_userDefault objectForKey:@"style"];
    if (_strNight == nil) {
        //        [_change_BT setBackgroundImage:[UIImage imageNamed:@"night"] forState:UIControlStateNormal];
        [_change_BT setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        //        [[AppDelegate appDelegte] changeImageAlpha];
        [_userDefault removeObjectForKey:@"style"];
        [_userDefault synchronize];
        
        
        
    }else if([_strNight isEqualToString:@"LOVE"])
    {
        [_change_BT setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        //        [_change_BT setBackgroundImage:[UIImage imageNamed:@"sun"] forState:UIControlStateNormal];
        
        //        [[AppDelegate appDelegte] changeImageAlpha];
        [_userDefault setObject:@"LOVE"forKey:@"style"];
        [_userDefault synchronize];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_change_BT setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [_change_BT setBackgroundImage:[UIImage imageNamed:@"night"] forState:UIControlStateNormal];
}
//夜间模式
-(void)changColor:(UIButton *)button
{
    
    _strNight = [_userDefault objectForKey:@"style"];
    if (_strNight == nil) {
        [_change_BT setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [_change_BT setBackgroundImage:[UIImage imageNamed:@"sun"] forState:UIControlStateNormal];
        [[AppDelegate appDelegte] changeImageAlpha];
        
        [_userDefault setObject:@"LOVE"forKey:@"style"];
        [_userDefault synchronize];
        
        
    }else if([_strNight isEqualToString:@"LOVE"])
    {
        [_change_BT setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [_change_BT setBackgroundImage:[UIImage imageNamed:@"night"] forState:UIControlStateNormal];
        [[AppDelegate appDelegte] changeImageAlpha];
        [_userDefault removeObjectForKey:@"style"];
        [_userDefault synchronize];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
