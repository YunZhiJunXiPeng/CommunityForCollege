//
//  FunctionCollectionViewCell.m
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/18.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "FunctionCollectionViewCell.h"

@interface FunctionCollectionViewCell ( )

@end

@implementation FunctionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews{
    UIImageView*imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height*0.7)];
    _imageView = imageView;
    [self addSubview:imageView];
    
    UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height*0.7, self.bounds.size.width,  self.bounds.size.height*0.3)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    _label = label;
    [self addSubview:label];
}







@end
