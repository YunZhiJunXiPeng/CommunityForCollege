//
//  LearningVideoViewController.h
//  EnglishiLearing
//
//  Created by 卖女孩的小火柴 on 16/8/21.
//  Copyright © 2016年 梁海洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LearingModel.h"
@interface LearningVideoViewController : UIViewController
@property (nonatomic,copy)NSString *videoURL;
@property (nonatomic,copy)NSString *videoTitle;
@property (nonatomic,strong)LearingModel *videoModel;
@end
