//
//  ThreeLevelModel.h
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/18.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreeLevelModel : NSObject
@property (strong,nonatomic) NSArray*city_pic;
@property (strong,nonatomic) NSString*city_id;
@property (strong,nonatomic) NSString*cnname;
@property (strong,nonatomic) NSString*enname;
@property (strong,nonatomic) NSString*country;
@property (strong,nonatomic) NSString*lat;
@property (strong,nonatomic) NSString*lon;
@property (strong,nonatomic) NSDictionary*weather;
@property (strong,nonatomic) NSArray*icon_list;
@property (strong,nonatomic) NSString*city_map;
@property (strong,nonatomic) NSArray*not_miss;
@property (strong,nonatomic) NSArray*mostpopular;
@property (strong,nonatomic) NSArray*local_basic;
@end
