

#import "CellForThreeImage.h"
#import "HeaderOfNews.h"
@implementation CellForThreeImage

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 100)];
        backImage.image = [UIImage imageNamed:KCellImage];
        backImage.alpha = 0.2;
        [self addSubview:backImage];
        self.myTitleForThree = [[UILabel alloc] initWithFrame:CGRectMake(4, 2, SCREEN.size.width-20, 20)];
        self.myImageForThree1 = [[UIImageView alloc] initWithFrame:CGRectMake(4, 23, SCREEN.size.width/3-7, 75)];
        self.myImageForThree2 = [[UIImageView alloc] initWithFrame:CGRectMake(4+SCREEN.size.width/3, 23, SCREEN.size.width/3-7, 75)];
        self.myImageForThree3 = [[UIImageView alloc] initWithFrame:CGRectMake(4+SCREEN.size.width/3*2, 23, SCREEN.size.width/3-7, 75)];
        [self addSubview:_myTitleForThree];
        [self addSubview:_myImageForThree1];
        [self addSubview:_myImageForThree2];
        [self addSubview:_myImageForThree3];

    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
