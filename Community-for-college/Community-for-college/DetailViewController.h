

#import "MyDetailViewController.h"
@class DataModel;

@protocol DetailViewControllerDelegate <NSObject>

-(void)changeBackImage:(NSInteger)alph;

@end


@interface DetailViewController : MyDetailViewController
{
    UIWebView* _webView;
    UISlider* Slide;
}
@property (nonatomic, retain)UILabel *mySource;
@property (nonatomic, retain)UILabel *myTime;
@property (nonatomic, retain)UIWebView *myDetail;
@property (nonatomic, copy)NSString *str;
@property (nonatomic, retain)DataModel *allDetail;


@end
