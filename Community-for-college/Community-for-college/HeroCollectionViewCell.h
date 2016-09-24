//
//  HeroCollectionViewCell.h
//  Community-for-college
//
//  Created by 卖女孩的小火柴 on 16/8/28.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeroCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UILabel *anotherNameLabel;//英雄别称
@property (nonatomic,strong)UILabel *nameLabel;//英雄名称】
@property (nonatomic,strong)UILabel *propertyLabel;//英雄属性
@property (nonatomic,strong)UIImageView *heroImageView;

@end
