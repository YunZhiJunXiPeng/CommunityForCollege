//
//  TwoLevelViewController.h
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/16.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TwoLevelModel;
@interface TwoLevelViewController : UIViewController

@property (assign,nonatomic) NSInteger ID;
@property (strong,nonatomic) TwoLevelModel*model;
@end
