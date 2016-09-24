//
//  LearningTableViewCell.h
//  EnglishiLearing
//
//  Created by 卖女孩的小火柴 on 16/8/19.
//  Copyright © 2016年 梁海洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LearingModel.h"

@interface LearningTableViewCell : UITableViewCell

//图片
@property (nonatomic,strong)UIImageView *image_View;
//标题
@property (nonatomic,strong)UILabel *titleLabel;
//来源
@property (nonatomic,strong)UILabel *typeLabel;
//多少人赞美
@property (nonatomic,strong)UILabel *likeLabel;
#pragma MARK ------ 接受传来的model ------
@property (nonatomic,strong)LearingModel *sendModel;

@end
