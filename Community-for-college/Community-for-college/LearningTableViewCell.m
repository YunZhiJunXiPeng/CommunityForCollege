//
//  LearningTableViewCell.m
//  EnglishiLearing
//
//  Created by 卖女孩的小火柴 on 16/8/19.
//  Copyright © 2016年 梁海洋. All rights reserved.
//
#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height
#import "LearningTableViewCell.h"
#import "CalculateTool.h"
#import "LearingModel.h"
#import "UIImageView+WebCache.h"

@interface LearningTableViewCell ()



@end
@implementation LearningTableViewCell
//初始化cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //cell布局
        [self redrawCell];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
//cell布局
- (void)redrawCell
{
    _sendModel = [LearingModel new];
    
    _titleLabel = [[UILabel alloc]initWithFrame:(CGRectMake(10, 8, 250, 50))];
    _titleLabel.font = [UIFont systemFontOfSize:16];
//    _titleLabel.backgroundColor = [UIColor colorWithRed:232 / 255.0 green:175 / 255.0  blue:220 / 255.0 alpha:0.2];
    _titleLabel.text = _sendModel.title;//赋值
    _titleLabel.numberOfLines = 2;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_titleLabel];
    
    //type布局
    _typeLabel = [[UILabel alloc]init];
    _typeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_typeLabel];

    _image_View = [[UIImageView alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(_titleLabel.frame) + 20, 5, ([UIScreen mainScreen].bounds.size.width - CGRectGetMaxX(_titleLabel.frame)) - 30, 80))];
    _image_View.layer.masksToBounds = YES;
    _image_View.layer.cornerRadius = 10;
    [self addSubview:_image_View];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
