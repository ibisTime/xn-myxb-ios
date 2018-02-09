//
//  ProposalHeaderView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/9.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ProposalHeaderView.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Framework
//Category
#import "UIControl+Block.h"
//Extension
//M
//V
#import "MovieAddComment.h"

@interface ProposalHeaderView()

//平均分
@property (nonatomic, strong) UILabel *averageLbl;
//比例
//评分数量
@property (nonatomic, strong) UILabel *commentNumLbl;
//星星
@property (nonatomic, strong) MovieAddComment *starView;

@end

@implementation ProposalHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.backgroundColor = kWhiteColor;
    
    CGFloat leftMargin = 15;
    //text
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:16.0];
    textLbl.text = @"评分及评论";
    [self addSubview:textLbl];
    
    //平均分
    self.averageLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kAppCustomMainColor
                                                   font:45.0];
    
    [self addSubview:self.averageLbl];
    //满分
    UILabel *totalScoreLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                     textColor:kTextColor2
                                                          font:11.0];
    totalScoreLbl.text = @"满分5分";
    [self addSubview:totalScoreLbl];
    //比例
    CGFloat y = 47;
    CGFloat lineW = kWidth(150);
    
    for (int i = 5; i > 0; i--) {
        
        //所占比例
        UIView *proportionBgView = [[UIView alloc] init];
        
        proportionBgView.backgroundColor = [UIColor colorWithHexString:@"#f2f3f1"];
        
        [self addSubview:proportionBgView];
        [proportionBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(@(-leftMargin));
            make.width.equalTo(@(lineW));
            make.height.equalTo(@1.5);
            make.top.equalTo(@(y+(5-i)*7.5));
        }];
        
        UIView *proportionView = [[UIView alloc] init];
        
        proportionView.tag = 1305-i;
        proportionView.backgroundColor = [UIColor colorWithHexString:@"#bdbdbd"];
        
        [proportionBgView addSubview:proportionView];
        [proportionView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.bottom.equalTo(@0);
            make.width.equalTo(@((i-1)*lineW/10.0));
        }];
        
        for (int j = 0; j < i; j++) {
            //小星星
            UIImageView *starIV = [[UIImageView alloc] initWithImage:kImage(@"big_star_select")];
            
            [self addSubview:starIV];
            [starIV mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.height.equalTo(@8);
                make.centerY.equalTo(proportionBgView.mas_centerY);
                make.right.equalTo(proportionBgView.mas_left).offset(-(10+j*11));
                
            }];
        }
    }
    //查看全部
    UIButton *lookAllBtn = [UIButton buttonWithTitle:@"查看全部" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:12.0];
    [lookAllBtn bk_addEventHandler:^(id sender) {
        
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:lookAllBtn];
    //评分数量
    self.commentNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                     textColor:kTextColor2
                                                          font:11.0];
    [self addSubview:self.commentNumLbl];
    //灰色
    UIView *greyView = [[UIView alloc] init];
    
    greyView.backgroundColor = kBackgroundColor;
    
    [self addSubview:greyView];
    //白色
    UIView *whiteView = [[UIView alloc] init];
    
    whiteView.backgroundColor = kWhiteColor;
    
    [self addSubview:whiteView];
    //轻点评分
    UILabel *promptLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:15.0];
    
    promptLbl.text = @"轻点评分";
    [whiteView addSubview:promptLbl];
    //星星
    self.starView = [[MovieAddComment alloc] init];
    
    [whiteView addSubview:self.starView];
    
    //布局
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(leftMargin));
        make.top.equalTo(@(leftMargin));
    }];
    //平均分
    [self.averageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(textLbl.mas_left);
        make.top.equalTo(@(y-10));
    }];
    //满分
    [totalScoreLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.averageLbl.mas_bottom).offset(0);
        make.centerX.equalTo(self.averageLbl.mas_centerX);
    }];
    //查看全部
    [lookAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-leftMargin));
        make.bottom.equalTo(textLbl.mas_bottom).offset(5);
    }];
    //评分数
    [self.commentNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-leftMargin));
        make.top.equalTo(totalScoreLbl.mas_top);
    }];
    //灰色
    [greyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.height.equalTo(@10);
        make.width.equalTo(@(kScreenWidth));
        make.top.equalTo(@(120));
    }];
    //白色
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.top.equalTo(greyView.mas_bottom);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@50);
    }];
    //轻点评分
    [promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(leftMargin));
        make.centerY.equalTo(@0);
    }];
    //星星
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(promptLbl.mas_right).offset(30);
        make.height.equalTo(@40);
        make.width.equalTo(@130);
        make.centerY.equalTo(@0);
    }];
    //数据
    self.averageLbl.text = @"4.7";
    self.commentNumLbl.text = [NSString stringWithFormat:@"%@个评分", @"666"];
}

- (void)setSubviewLayout {
    
    
}

@end
