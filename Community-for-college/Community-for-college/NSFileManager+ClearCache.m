//
//  NSFileManager+ClearCache.m
//  DouBan-01
//
//  Created by 夏夕空 on 16/7/27.
//  Copyright © 2016年 郭佳. All rights reserved.
//

#import "NSFileManager+ClearCache.h"
#import <SDImageCache.h>
@implementation NSFileManager (ClearCache)

- (long long)fileSizeAtPath:(NSString*)filePath{
    NSFileManager*fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        return [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (float) floderSizeAtPath:(NSString*)floderPath{
    NSFileManager*manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:floderPath]) {
        return 0;
    }
    NSEnumerator*childFilesEnumerator = [[manager subpathsAtPath:floderPath] objectEnumerator];
    NSString*fileName;
    long long floderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString*fileAbsolutePath = [floderPath stringByAppendingPathComponent:fileName];
        floderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return (float)floderSize/(1024*1024);
}



- (void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}




@end
