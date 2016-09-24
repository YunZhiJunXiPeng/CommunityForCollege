//
//  NotMissTableViewCell.m
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/18.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "NotMissTableViewCell.h"

#define MainHight [UIScreen mainScreen].bounds.size.height
#define MainWidth [UIScreen mainScreen].bounds.size.width
@implementation NotMissTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSubviews];
    }
    return self;
}


- (void)awakeFromNib {
    
}

- (void)setSubviews{
    _ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, (MainHight + 100)/3*0.7)];
//    _ImageView.backgroundColor = [UIColor redColor];

    [self addSubview:_ImageView];
    _ImageView.contentMode = UIViewContentModeScaleAspectFill;
    _ImageView.layer.masksToBounds = YES;
    _descLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_ImageView.frame) + 8, MainWidth - 20, (MainHight+ 100)/3*0.2)];
    _descLabel.textColor = [UIColor grayColor];
    _descLabel.numberOfLines = 0;
    _descLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_descLabel];
    
    UILabel*nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainWidth - 20, 50)];
    nameLabel.center = _ImageView.center;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _Namelabel = nameLabel;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:nameLabel];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
