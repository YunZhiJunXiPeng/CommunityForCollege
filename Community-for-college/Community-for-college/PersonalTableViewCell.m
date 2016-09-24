//
//  PersonalTableViewCell.m
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/24.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "PersonalTableViewCell.h"

@implementation PersonalTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setSubView];
    }
    return self;
}

- (void)setSubView{
    UILabel*label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 85, 45)];
    label1.textColor = [UIColor grayColor];
    [self addSubview:label1];
    _label1 = label1;
    UILabel*label2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 200, 45)];
    label2.textColor = [UIColor blackColor];
    [self addSubview:label2];
    _label2 = label2;
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    }

@end
