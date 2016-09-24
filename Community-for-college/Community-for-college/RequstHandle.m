

#import "RequstHandle.h"

@interface RequstHandle ()<NSURLConnectionDataDelegate>
@property (nonatomic,retain)NSMutableData *data;//进行数据的存贮
@end
@implementation RequstHandle
-(id)initWithURLString:(NSString *)urlString paraString:(NSString *)paraString metod:(NSString *)method delegate:(id<RequestHandleDelegat>)delegate
{
    if([super init])
    {
        
        self.delegate = delegate;
        
        //根据method 进行GET 和 POST 请求的选择
        if([method isEqualToString:@"GET"])
        {
            //GET请求
            [self requestByGETWithUrString:urlString];
            
        }else if([method isEqualToString:@"POST"])
        {
            //POST请求
        }
    }
    return self;
}
//GET请求
-(void)requestByGETWithUrString:(NSString *)urlstring
{
    //获取NSURL
    NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //建立连接请求数据
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

//取消  push过去又pop回来  请求的数据没地儿放 会crush

-(void)cancle
{
    //取消请求
    [self.connection cancel];
}


#pragma - DataDelegate
//建立连接
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data = [NSMutableData data];
}

//获取数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //拼接data
    [self.data appendData:data];
}

//完成请求
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //通知代理调用方法
    if([self.delegate respondsToSelector:@selector(requestHandle:didSucceedWithData:)])
    {
        //当数据请求完成之后 告知代理调用协议中的方法 将数据拿走
        [self.delegate requestHandle:self didSucceedWithData:_data];
    }
}
//请求失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
   if([self.delegate respondsToSelector:@selector(requestHandle:faiWithError:)])
   {
       [self.delegate requestHandle:self faiWithError:error];
   }
}





















@end
