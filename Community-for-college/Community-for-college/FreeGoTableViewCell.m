//
//  FreeGoTableViewCell.m
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/20.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "FreeGoTableViewCell.h"

@implementation FreeGoTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutSubviews];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    _Image = [[UIImageView alloc]init];
    _Image.frame = CGRectMake(5, 10, self.frame.size.width*0.3,70);
    _title = [[UILabel alloc]init];
    _title.frame  = CGRectMake(CGRectGetMaxX(_Image.frame) + 5, 5, self.frame.size.width*0.7, 63);
    _title.numberOfLines = 0;
    _title.font = [UIFont systemFontOfSize:13];
    _priceoff = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_Image.frame) + 5, 60, self.frame.size.width*0.2, 20)];
    _priceoff.textColor = [UIColor redColor];
    _priceoff.font = [UIFont systemFontOfSize:12];
    
    _price1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_priceoff.frame) + 10, 60, self.frame.size.width*0.2, 20)];
    _price1.textColor = [UIColor redColor];
    
    _price2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_price1.frame), 60, self.frame.size.width*0.2, 20)];
    _price2.font = [UIFont systemFontOfSize:12];
    _price2.textColor = [UIColor redColor];
    [self addSubview:_price2];
    [self addSubview:_price1];
    [self addSubview:_Image];
    [self addSubview:_title];
    [self addSubview:_priceoff];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
