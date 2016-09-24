//
//  HotCityCollectionViewCell.m
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/17.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "HotCityCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "TwoLevelModel.h"

@interface HotCityCollectionViewCell ()
@property (strong,nonatomic) UIImageView*backImage;
@property (strong,nonatomic) UILabel*CName;
@property (strong,nonatomic) UILabel*EName;

@end

@implementation HotCityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews{
    UIImageView*backImage = [[UIImageView alloc]initWithFrame:self.bounds];
    _backImage = backImage;
    [self.contentView addSubview:backImage];
    
    UILabel*CName = [[UILabel alloc]initWithFrame:CGRectMake(10, self.bounds.size.height/2  , self.bounds.size.width - 20, 30)];
    CName.textColor = [UIColor whiteColor];
//    CName.backgroundColor = [UIColor redColor];
    _CName = CName;
    CName.font = [UIFont systemFontOfSize:16];
    [self.backImage addSubview:CName];
    
    UILabel*EName = [[UILabel alloc]initWithFrame:CGRectMake(10, self.CName.bounds.origin.y + 20, self.CName.bounds.size.width, 30)];
    EName.textColor = [UIColor whiteColor];
    _EName = EName;
    _EName.font = [UIFont systemFontOfSize:14];
    [self.backImage addSubview:EName];
}

- (void)setModel:(TwoLevelModel *)model{
    if (_model != model) {
        _model = nil;
        _model = model;
    }
    [_backImage sd_setImageWithURL:[NSURL URLWithString:_model.photo]];
    _CName.text = _model.cnname;
    _EName.text = _model.enname;
}














@end
