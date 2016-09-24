//
//  GameCollectionViewCell.m
//  Community-for-college
//
//  Created by 卖女孩的小火柴 on 16/8/26.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "GameCollectionViewCell.h"
#import "GameModel.h"
#import "UIImageView+WebCache.h"

@implementation GameCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        [self redrawCollectionCell];
    }
    return self;
}

- (void)redrawCollectionCell
{
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    
    _gameImageView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
    _gameImageView.backgroundColor = [UIColor cyanColor];
    
//    _gameImageView.contentMode = UIViewContentModeScaleToFill;
    _gameImageView.frame = CGRectMake(0, 0,self.frame.size.width , self.frame.size.height * 0.75);
    [self.contentView addSubview:_gameImageView];
    
    UIView *view = [[UIView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(_gameImageView.frame), self.frame.size.width, self.frame.size.height * 0.25))];
    view.backgroundColor = [UIColor colorWithRed:243 / 255.0 green:187 / 255.0 blue:236 / 255.0 alpha:1.0];
    [self.contentView addSubview:view];
    
    _titleLabel = [[UILabel alloc]initWithFrame:(CGRectMake(5, 5, view.frame.size.width - 10, view.frame.size.height - 10))];
    [view addSubview:_titleLabel];
    
}


@end
