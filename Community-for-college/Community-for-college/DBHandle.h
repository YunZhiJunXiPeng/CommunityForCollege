//
//  DBHandle.h
//  Community-for-college
//
//  Created by lanou3g on 16/8/15.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BooksModel;
@interface DBHandle : NSObject

+ (DBHandle *)sharedDBHandle;

- (void)openDB;

- (void)closeDB;

#pragma mark --- BoyBooks

- (void)createBoyBooks;

- (void)insertWithBoyBooksnid:(NSString *)nid Name:(NSString *)name classes:(NSString *)classes desc:(NSString *)desc lastChapterName:(NSString *)lastChapterName imgUrl:(NSString *)imgUrl author:(NSString *)author;

- (BOOL)searchWithBoynid:(NSString *)nid;

- (NSMutableArray *)searBoyBooks;

- (void)deleteWitBoynid:(NSString *)nid;

#pragma mark --- GirlBooks

- (void)createGirlBooks;

- (void)insertWithGirlBooksnid:(NSString *)nid Name:(NSString *)name classes:(NSString *)classes desc:(NSString *)desc lastChapterName:(NSString *)lastChapterName imgUrl:(NSString *)imgUrl author:(NSString *)author;

- (BOOL)searchWithGirlnid:(NSString *)nid;

- (NSMutableArray *)searGirlBooks;

- (void)deleteWitGirlnid:(NSString *)nid;



@end
