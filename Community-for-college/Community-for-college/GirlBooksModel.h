//
//  GirlBooksModel.h
//  Community-for-college
//
//  Created by lanou3g on 16/8/16.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GirlBooksModel : NSObject
//书名
@property (copy , nonatomic) NSString *name;
//分类
@property (copy , nonatomic) NSString *classes;
//详情
@property (copy , nonatomic) NSString *desc;
//作者
@property (copy , nonatomic) NSString *author;
//ID
@property (copy , nonatomic) NSString *nid;
//图片
@property (copy , nonatomic) NSString *imgUrl;
//完本感言文字
@property (copy , nonatomic) NSString *lastChapterName;


@end
