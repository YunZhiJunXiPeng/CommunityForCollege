//
//  CityDetailViewController.h
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/17.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreeLevelModel.h"
@interface CityDetailViewController : UIViewController
@property (strong,nonatomic) NSString*ID;
@property (strong,nonatomic) ThreeLevelModel*model;
@end
