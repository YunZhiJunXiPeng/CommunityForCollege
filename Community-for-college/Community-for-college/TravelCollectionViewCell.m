//
//  TravelCollectionViewCell.m
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/15.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "TravelCollectionViewCell.h"
#import "TravelModel.h"
#import <UIImageView+WebCache.h>
#import "UIColor+RandomColor.h"
#import "CalculateTool.h"

@interface TravelCollectionViewCell ( )
@property (strong,nonatomic) UIView*LabelView;
@property (strong,nonatomic) UILabel*CityLabel1;
@property (strong,nonatomic) UILabel*CityLabel2;

@property (strong,nonatomic) UILabel*CName;
@property (strong,nonatomic) UILabel*EName;

//@property (strong,nonatomic) UIView*NameView;
@end

@implementation TravelCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setSubViews];
            }
    return self;
}

- (void)setSubViews{
    
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    self.headerImgView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_headerImgView];
    UIView*LabelView = [[UIView alloc]init];
    LabelView.backgroundColor= [UIColor blackColor];
    LabelView.alpha = 0.7;
    LabelView.layer.cornerRadius = 3;
    LabelView.layer.masksToBounds = YES;
    _LabelView = LabelView;
    [self addSubview:LabelView];
    
    UILabel*label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:19];
    label.textAlignment = NSTextAlignmentCenter;
    _CityLabel1 = label;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    [LabelView addSubview:label];

    UILabel*label2 = [[UILabel alloc]initWithFrame:CGRectZero];
    label2.font = [UIFont systemFontOfSize:14];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.backgroundColor = [UIColor colorWithRed:245.0/255 green:88.0/255 blue:135.0/255 alpha:1];
     _CityLabel2 = label2;
    _CityLabel2.textColor = [UIColor whiteColor];
    [LabelView addSubview:label2];
   
    
    UIView*NameView = [[UIView alloc]initWithFrame:CGRectMake(0, self.headerImgView.bounds.size.height - 60, self.headerImgView.bounds.size.width, 60)];
    NameView.backgroundColor = [UIColor colorWithRed:245.0/255 green:88.0/255 blue:135.0/255 alpha:1];
//    _NameView = NameView;
   
     [self.contentView addSubview:NameView];
    
    UILabel*CName = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 20)];
    CName.textColor = [UIColor whiteColor];
    [NameView addSubview:CName];
    _CName = CName;
    
    UILabel*EName = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 150, 20)];
    EName.textColor = [UIColor whiteColor];
    EName.font = [UIFont systemFontOfSize:15];
    [NameView addSubview:EName];
    _EName = EName;
    
    
}

- (void)layoutSubviews{
  
//        CGFloat width1 = [CalculateTool widthForLableText:[NSString stringWithFormat:@"%ld",_model.count]ForTextSize:20];
//        CGFloat width2 = [CalculateTool widthForLableText:_model.label ForTextSize:17];
//        CGFloat width  = width1 > width2 ? width1 : width2;
        _LabelView.frame = CGRectMake(self.headerImgView.bounds.size.width - 55,self.headerImgView.bounds.origin.y + 10 , 50, 45);
//      NSLog(@"%@ %ld    %f %f %f",_model.label,_model.count,width1,width2,width);
        _CityLabel1.frame = CGRectMake(0,0,50, 25);
        _CityLabel2.frame = CGRectMake(0,25,50, 20);
}



- (void)setModel:(TravelModel *)model{
    if (_model != model) {
        _model = nil;
        _model = model;
    }
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:_model.photo]];
    NSString*count = [NSString stringWithFormat:@"%ld",_model.count];
     _CityLabel2.text = _model.label;
    _CityLabel1.text = count ;
    _CName.text = _model.cnname;
    _EName.text = _model.enname;
 
}




















@end
