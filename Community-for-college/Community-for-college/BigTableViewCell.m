

#import "BigTableViewCell.h"
#import "AttributedLabel.h"
#import "HeaderOfNews.h"
#define kSize self.bounds.size
@implementation BigTableViewCell

-(id)init
{
    if ([super init]) {
        [self layoutView];
    }
    return self;
}

-(void)layoutView
{
    self.bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 200)];
    [self addSubview:_bigImageView];
    
    
    self.myTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 200 * 6 / 7, SCREEN.size.width, 200 * 1 / 7)];
    self.myTitle.font = [UIFont systemFontOfSize:16];
    self.myTitle.backgroundColor = [UIColor colorWithHue:219 / 255.0 saturation:156 / 255.0 brightness:200 / 255.0 alpha:0.3];
    self.myTitle.textColor = [UIColor whiteColor];
    [_bigImageView addSubview:_myTitle];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
