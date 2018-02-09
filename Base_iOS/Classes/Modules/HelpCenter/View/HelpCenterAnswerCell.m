//
//  HelpCenterAnswerCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HelpCenterAnswerCell.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Category
#import "NSString+CGSize.h"
#import "UILabel+Extension.h"

@interface HelpCenterAnswerCell()
//title
@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation HelpCenterAnswerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.backgroundColor = kWhiteColor;
    
    //title
    self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kTextColor2
                                                 font:14.0];
    
    self.titleLbl.numberOfLines = 0;
    self.titleLbl.adjustsFontSizeToFitWidth = YES;
    
    [self.contentView addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(45);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(@0);
        
    }];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@45);
        make.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
}

- (void)setQuestion:(QuestionModel *)question {
    
    _question = question;
    
    self.titleLbl.text = question.content;
    
    CGFloat w = kScreenWidth - 45 - 15;
    question.cellHeight = [question.content calculateStringSize:CGSizeMake(w, MAXFLOAT) font:Font(14.0)].height + 20;
}
@end
