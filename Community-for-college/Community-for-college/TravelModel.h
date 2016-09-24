//
//  TravelModel.h
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/15.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelModel : NSObject

@property (assign,nonatomic) NSInteger id;
@property (strong,nonatomic) NSString*cnname;
@property (strong,nonatomic) NSString*enname;
@property (strong,nonatomic) NSString*photo;
@property (assign,nonatomic) NSInteger count;
@property (strong,nonatomic) NSString*label;

@end
