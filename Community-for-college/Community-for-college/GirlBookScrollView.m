//
//  GirlBookScrollView.m
//  Community-for-college
//
//  Created by lanou3g on 16/8/16.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "GirlBookScrollView.h"
#import "GirlBooksModel.h"
#import <UIImageView+WebCache.h>

@interface GirlBookScrollView ()

//书名
@property (strong , nonatomic) UILabel *name;
//分类
@property (strong , nonatomic) UILabel *classes;
//详情
@property (strong , nonatomic) UITextView *desc;
//完本感言文字
@property (strong , nonatomic) UILabel *lastChapterName;
//图片
@property (strong , nonatomic) UIImageView *imgUrl;
//作者
@property (strong , nonatomic) UILabel *author;


@end

@implementation GirlBookScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.scrollEnabled = YES;
        self.contentSize = CGSizeMake(0, 800);
        
        //        图片
        self.imgUrl = [[UIImageView alloc]initWithFrame:CGRectMake(20, 30, 120, 150)];
        self.imgUrl.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imgUrl];
        
        //        书名
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imgUrl.frame) + 30, 40, 200, 30)];
        self.name.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.name];
        
        //        作者
        self.author = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imgUrl.frame) + 30, CGRectGetMaxY(self.name.frame) + 20, 100, 30)];
        self.author.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.author];
        
        //        分类
        self.classes = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imgUrl.frame) + 30, CGRectGetMaxY(self.author.frame) + 20, 100, 30)];
        self.classes.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.classes];
        
        //        完本感言文字
        self.lastChapterName = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.imgUrl.frame) + 30, 200, 50)];
        self.lastChapterName.font = [UIFont systemFontOfSize:20];
        [self addSubview:self.lastChapterName];
        
        //        详情
        self.desc = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.lastChapterName.frame), CGRectGetMaxY(self.lastChapterName.frame) + 30, self.frame.size.width - 60, 200)];
        self.desc.font = [UIFont systemFontOfSize:17];
        self.desc.editable = NO;
        [self addSubview:self.desc];
        
        
        
    }
    return self;
}

- (void)setModel:(GirlBooksModel *)model{
    
    _model = model;
    self.name.text = [NSString stringWithFormat:@"图书名称:%@",model.name];
    self.classes.text = model.classes;
    self.desc.text = model.desc;
    self.lastChapterName.text = model.lastChapterName;
    self.author.text = [NSString stringWithFormat:@"作者:%@",model.author];
    [self.imgUrl sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:nil];
    
}

@end
