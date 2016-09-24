

#import <UIKit/UIKit.h>
@class HeadlineTableViewController;
@class InformationTableViewController;
@class PhoneTableViewController;
@class GameTableViewController;
@class LearningViewController;
@interface NewsViewController : UIViewController

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIView *redView;
@property (nonatomic, strong)HeadlineTableViewController *headlineTC;
@property (nonatomic, strong)InformationTableViewController *informationTC;
@property (nonatomic, strong)PhoneTableViewController *phoneTC;
@property (nonatomic, strong)GameTableViewController *gameTC;
@property (nonatomic, strong)LearningViewController *learnVC;

//判断夜间模式
@property (nonatomic,strong)NSString *strNight;
@property (nonatomic,strong)NSUserDefaults *userDefault;

@end
