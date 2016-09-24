
//
//  HeroDetailsTableViewCell.m
//  Community-for-college
//
//  Created by 卖女孩的小火柴 on 16/8/31.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "HeroDetailsTableViewCell.h"

@implementation HeroDetailsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self redarwHeroDetailsCell];
    }
    return self;
}

- (void)redarwHeroDetailsCell
{
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:(CGRectMake(15, 22, 20, 20))];
    imageView.image = [UIImage imageNamed:@"6边形"];
    [self.contentView addSubview:imageView];
    
    UILabel *Alable1 = [[UILabel alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 18, 200, 30))];
    Alable1.numberOfLines = 1;
    Alable1.font = [UIFont systemFontOfSize:17];
    Alable1.text = @"英雄背景故事";
    [self.contentView addSubview:Alable1];
    
    _Alabel3 = [[UILabel alloc]initWithFrame:(CGRectMake(CGRectGetMinX(Alable1.frame), CGRectGetMaxY(Alable1.frame) + 30, 100, 100))];
    
    [self.contentView addSubview:_Alabel3];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
