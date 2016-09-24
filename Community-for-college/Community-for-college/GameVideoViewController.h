//
//  GameVideoViewController.h
//  Community-for-college
//
//  Created by 卖女孩的小火柴 on 16/8/30.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LearingModel.h"
@interface GameVideoViewController : UIViewController

@property (nonatomic,copy)NSString *videoURL;
@property (nonatomic,copy)NSString *videoTitle;

@property (nonatomic,strong)LearingModel *videoModel;

@end
