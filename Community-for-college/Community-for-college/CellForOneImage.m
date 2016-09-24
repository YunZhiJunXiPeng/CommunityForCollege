

#import "CellForOneImage.h"
#import "HeaderOfNews.h"
@implementation CellForOneImage

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 100)];
        backImage.image = [UIImage imageNamed:KCellImage];
        backImage.alpha = 0.2;
        [self addSubview:backImage];
        
        self.myImageForOne = [[UIImageView alloc] initWithFrame:CGRectMake(8, 4, 110, 93)];
        
        [self addSubview:_myImageForOne];
        
        self.myTitleForOne = [[UILabel alloc] initWithFrame:CGRectMake(125, 4, SCREEN.size.width-125, 45)];
        self.myTitleForOne.font = [UIFont systemFontOfSize:18];
        _myTitleForOne.numberOfLines = 0;
        [self addSubview:_myTitleForOne];
        
        self.SourceForOne = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN.size.width-160, 60, 150, 25)];
        self.SourceForOne.font = [UIFont systemFontOfSize:12];
        _SourceForOne.textAlignment = NSTextAlignmentRight;
        [self addSubview:_SourceForOne];
   
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
