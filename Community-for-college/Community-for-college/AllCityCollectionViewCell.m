//
//  AllCityCollectionViewCell.m
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/17.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "AllCityCollectionViewCell.h"
#import "TwoLevelModel.h"
#import <UIImageView+WebCache.h>

@interface AllCityCollectionViewCell ( )
@property (strong,nonatomic) UIImageView*backImage;
@property (strong,nonatomic) UILabel*catename;
@property (strong,nonatomic) UILabel*catename_en;
@property (strong,nonatomic) UILabel*beenstr;
@property (strong,nonatomic) UILabel*representative;
@end
@implementation AllCityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews{
    UIImageView*backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height*0.6)];
    _backImage = backImage;
    [self.contentView addSubview:backImage];
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 4;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel*catename = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.backImage.frame) - 50, 100, 20)];
    catename.textColor = [UIColor whiteColor];
    catename.font = [UIFont systemFontOfSize:15];
    _catename = catename;
    [self.contentView addSubview:_catename];
    
    UILabel*catename_en = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.catename.frame), 150, 20)];
    catename_en.textColor = [UIColor whiteColor];
    catename_en.font = [UIFont systemFontOfSize:15];
    _catename_en = catename_en;
    [self.contentView addSubview:_catename_en];
    
    UILabel*beenstr = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.backImage.frame) + 5, 150, 20)];
    beenstr.font = [UIFont systemFontOfSize:15];
    beenstr.textColor = [UIColor grayColor];
    _beenstr = beenstr;
    [self.contentView addSubview:_beenstr];
    
    UILabel*representative = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.beenstr.frame) , self.frame.size.width - 20, self.frame.size.height - CGRectGetMaxY(self.beenstr.frame) - 5)];
    representative.textColor = [UIColor grayColor];
    representative.font = [UIFont systemFontOfSize:12];
    representative.numberOfLines = 0;
    _representative = representative;
    [self.contentView addSubview:_representative];
    
}

- (void)setModel:(TwoLevelModel *)model{
    if (_model != model) {
        _model = nil;
        _model = model;
    }
    [_backImage sd_setImageWithURL:[NSURL URLWithString:model.photo]];
    _catename.text = _model.catename;
    _catename_en.text = _model.catename_en;
    _beenstr.text = model.beenstr;
    _representative.text = model.representative;
}





@end
