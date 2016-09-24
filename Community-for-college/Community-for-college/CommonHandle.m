

#import "CommonHandle.h"
#import "HeaderOfNews.h"
@implementation CommonHandle

static CommonHandle *isHandle = nil;
+(CommonHandle *)shareHandle
{
    @synchronized(self)
    {
        if (isHandle == nil) {
            isHandle = [[CommonHandle alloc] init];
            isHandle.tableViewTag = 100;
           
        }
    }
    
    return isHandle;
}


@end
