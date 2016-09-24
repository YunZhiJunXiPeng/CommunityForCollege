

#import <Foundation/Foundation.h>

@interface CommonHandle : NSObject

+(CommonHandle *)shareHandle;

@property (nonatomic)NSInteger tableViewTag;
@property (nonatomic, retain)NSString *whichDetailURL;

@end
