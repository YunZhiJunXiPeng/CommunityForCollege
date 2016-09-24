//
//  BoyBooksTableViewCell.m
//  Community-for-college
//
//  Created by lanou3g on 16/8/16.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "BoyBooksTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "BoyBooksModel.h"
@implementation BoyBooksTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.imgUrl = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 60, 75)];
        self.imgUrl.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imgUrl];
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imgUrl.frame) + 10, 0, 300, 40)];
        self.name.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.name];
        
        self.author = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imgUrl.frame) + 10, CGRectGetMaxY(self.name.frame), 200, 40)];
        self.author.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.author];
        
        
    }
    return self;
}

- (void)setModel:(BoyBooksModel *)model{
    
    _model = model;
    self.name.text = [NSString stringWithFormat:@"书名:%@",model.name];
    self.author.text = [NSString stringWithFormat:@"作者:%@",model.author];
    [self.imgUrl sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:nil];
    
}
@end
