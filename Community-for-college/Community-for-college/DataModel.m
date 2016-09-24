//
//  DataModel.m
//  Community-for-college
//
//  Created by 卖女孩的小火柴 on 16/8/15.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

//编码
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ([super init]) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
//        self.body = [aDecoder decodeObjectForKey:@"collect"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
//    [aCoder encodeObject:self.body forKey:@"collect"];
}
@end
