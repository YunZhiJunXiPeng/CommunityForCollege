//
//  HeaderCollectionReusableView.m
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/19.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@implementation HeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _WordImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height*0.85)];
        [self addSubview:_WordImage];
        UIView*view = [[UIView alloc]initWithFrame:_WordImage.frame];
        view.backgroundColor =[UIColor colorWithRed:1.0 green:113 / 255.0 blue:180 / 255.0 alpha:0.2];
//        view.alpha = 0.4;
        [self addSubview:view];
    }
    return self;
}


@end
