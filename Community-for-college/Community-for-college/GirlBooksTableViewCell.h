//
//  GirlBooksTableViewCell.h
//  Community-for-college
//
//  Created by lanou3g on 16/8/16.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GirlBooksModel;
@interface GirlBooksTableViewCell : UITableViewCell

@property (strong , nonatomic) UILabel *name;
@property (strong , nonatomic) UILabel *author;
@property (strong , nonatomic) UIImageView *imgUrl;

@property (strong , nonatomic) GirlBooksModel *model;


@end
