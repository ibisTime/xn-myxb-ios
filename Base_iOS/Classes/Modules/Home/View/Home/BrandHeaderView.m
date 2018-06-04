//
//  BrandHeaderView.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandHeaderView.h"
@interface BrandHeaderView ()

@end;

@implementation BrandHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, 100, kScreenWidth);
        
        self.descLabel = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor2
                                                    font:12.0];
        self.descLabel.numberOfLines = 0;
        [self addSubview:self.descLabel];
        
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(15);
            make.right.equalTo(self.mas_right).with.offset(-15);
            make.top.equalTo(self.mas_top).with.offset(10);
        }];
    }
    return self;
}
- (void)setDescriptionStr:(NSString *)descriptionStr
{
    _descriptionStr = descriptionStr;
    
    NSAttributedString *attriStr = [self attributedStringWithHTMLString:descriptionStr];
    
    NSMutableAttributedString * attriM = [[NSMutableAttributedString alloc]initWithAttributedString:attriStr];
    
    [attriM addAttribute:NSForegroundColorAttributeName value:kTextColor2 range:NSMakeRange(0,  attriM.length)];
    
    self.descLabel.attributedText = attriM;
    
    CGFloat height = [self.descLabel.attributedText boundingRectWithSize:CGSizeMake(kScreenWidth - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    
    self.frame = CGRectMake(0, 0, kScreenWidth, height + 20);
    
//    [self.descLabel sizeToFit];

}

- (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString

{
    
    
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding),
                               
                               };
    
    
    
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    
}

@end
