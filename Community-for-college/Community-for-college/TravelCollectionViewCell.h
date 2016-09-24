//
//  TravelCollectionViewCell.h
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/15.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TravelModel;
@interface TravelCollectionViewCell : UICollectionViewCell
@property (strong,nonatomic) UIImageView*headerImgView;

@property (strong,nonatomic) TravelModel*model;

@end
