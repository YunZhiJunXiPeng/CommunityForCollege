//
//  HeroCollectionViewCell.m
//  Community-for-college
//
//  Created by 卖女孩的小火柴 on 16/8/28.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "HeroCollectionViewCell.h"


@implementation HeroCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self redrawCollectionCell];
    }
    return self;
}

- (void)redrawCollectionCell
{
    //英雄图标
    _heroImageView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
//    _heroImageView.backgroundColor = [UIColor cyanColor];
    
    _heroImageView.frame = CGRectMake(0, 0,self.frame.size.width / 3 , self.frame.size.height);
    [self.contentView addSubview:_heroImageView];
    
    UIView *view = [[UIView alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(_heroImageView.frame), 0,  3 * self.frame.size.width / 4, self.frame.size.height))];
//    view.backgroundColor = [UIColor colorWithRed:243 / 255.0 green:187 / 255.0 blue:236 / 255.0 alpha:1.0];
    [self.contentView addSubview:view];
    
    //别称label
    _anotherNameLabel = [[UILabel alloc]initWithFrame:(CGRectMake(5, 0, view.frame.size.width - 10, view.frame.size.height / 3 - 5))];
    _anotherNameLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:_anotherNameLabel];
    
    //英雄名称
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, view.frame.size.height / 3, view.frame.size.width - 10, view.frame.size.height / 3 - 5)];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:_nameLabel];
    
    //英雄属性
    _propertyLabel = [[UILabel alloc]initWithFrame:(CGRectMake(5, 2 * view.frame.size.height /3 , view.frame.size.width - 10, view.frame.size.height / 3 - 5))];
    _propertyLabel.font = [UIFont systemFontOfSize:14];
    _propertyLabel.textColor = [UIColor colorWithRed:55 / 255.0 green:159 / 255.0 blue:236 / 255.0 alpha:1.0];
    [view addSubview:_propertyLabel];
}

@end
