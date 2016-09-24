

#import <Foundation/Foundation.h>

@class RequstHandle;
@protocol RequestHandleDelegat <NSObject>

//请求成功
-(void)requestHandle:(RequstHandle *)requesthandle didSucceedWithData:(NSMutableData *)data;
//请求失败
-(void)requestHandle:(RequstHandle *)requesthandle faiWithError:(NSError *)error;

@end
@interface RequstHandle : NSObject
@property (nonatomic,assign)id<RequestHandleDelegat>delegate;

@property (nonatomic,retain)NSURLConnection *connection;
//初始化方法   需要一个urlString 字符串 一个paraString 字符串 (method 方式)   代理
-(id)initWithURLString:(NSString *)urlString paraString:(NSString *)paraString metod:(NSString *)method delegate:(id<RequestHandleDelegat>)delegate;

//取消请求
-(void)cancle;
@end
