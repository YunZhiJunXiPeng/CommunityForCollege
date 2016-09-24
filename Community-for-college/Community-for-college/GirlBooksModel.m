//
//  GirlBooksModel.m
//  Community-for-college
//
//  Created by lanou3g on 16/8/16.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "GirlBooksModel.h"

@implementation GirlBooksModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (NSString *)description
{
    return  [NSString stringWithFormat:@"%@%@",_author,_nid];
}

@end
