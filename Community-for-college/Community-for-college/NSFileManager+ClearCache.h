//
//  NSFileManager+ClearCache.h
//  DouBan-01
//
//  Created by 夏夕空 on 16/7/27.
//  Copyright © 2016年 郭佳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (ClearCache)
- (long long)fileSizeAtPath:(NSString*)filePath;
- (void)clearCache:(NSString *)path;
- (float) floderSizeAtPath:(NSString*)floderPath;
@end
