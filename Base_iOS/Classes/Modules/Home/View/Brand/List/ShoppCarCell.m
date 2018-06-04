//
//  ShoppCarCell.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ShoppCarCell.h"
//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Framework
//Category
#import "NSString+Extension.h"
#import "NSNumber+Extension.h"
//Extension
#import <UIImageView+WebCache.h>

@interface ShoppCarCell()
//产品图片
@property (nonatomic, strong) UIImageView *goodIV;
//产品名称
@property (nonatomic, strong) UILabel *nameLbl;
//产品说明
@property (nonatomic, strong) UILabel *descLbl;
//产品价格
@property (nonatomic, strong) UILabel *priceLbl;
//产品销量
@property (nonatomic, strong) UILabel *numLbl;

@property (nonatomic, strong) UIButton *chouseBtn;

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UIButton *Reduction;

@property (nonatomic, strong) UIButton *deleteBtn;


@end

@implementation ShoppCarCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.chouseBtn = [UIButton buttonWithTitle:@""
                                 titleColor:[UIColor blackColor]
                            backgroundColor:kClearColor
                                  titleFont:16.0];
    [self.chouseBtn addTarget:self action:@selector(chouseThis) forControlEvents:UIControlEventTouchUpInside];
    [self.chouseBtn setImage:kImage(@"选中YES") forState:UIControlStateNormal];
    
    [self addSubview:self.chouseBtn];
    
    //产品图片
    self.goodIV = [[UIImageView alloc] init];
    
    self.goodIV.contentMode = UIViewContentModeScaleAspectFill;
    self.goodIV.clipsToBounds = YES;
    
    [self addSubview:self.goodIV];
    
    //产品名称
    self.nameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor clearColor]
                                      font:Font(15.0)
                                 textColor:kTextColor];
    
    self.nameLbl.numberOfLines = 0;
    
    [self addSubview:self.nameLbl];
    
    
    self.deleteBtn = [UIButton buttonWithTitle:@""
                                 titleColor:[UIColor blackColor]
                            backgroundColor:kClearColor
                                  titleFont:16.0];
    [self.deleteBtn addTarget:self action:@selector(DeleteBtnchouseThis) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn setImage:kImage(@"删除 红") forState:UIControlStateNormal];
    
    [self addSubview:self.deleteBtn];
    
    
    //产品说明
    self.descLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor2
                                                font:14.0];
    self.descLbl.numberOfLines = 0;
    
    [self addSubview:self.descLbl];
    //产品价格
    self.priceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kThemeColor
                                                 font:15.0];
    
    [self addSubview:self.priceLbl];
    
    
    
    self.addBtn = [UIButton buttonWithTitle:@""
                                    titleColor:[UIColor blackColor]
                               backgroundColor:kClearColor
                                     titleFont:16.0];
    [self.addBtn addTarget:self action:@selector(addBtnchouseThis) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn setImage:kImage(@"添加(2)") forState:UIControlStateNormal];
    
    [self addSubview:self.addBtn];
    
    
    self.Reduction = [UIButton buttonWithTitle:@""
                                 titleColor:[UIColor blackColor]
                            backgroundColor:kClearColor
                                  titleFont:16.0];
    [self.Reduction addTarget:self action:@selector(ReductionchouseThis) forControlEvents:UIControlEventTouchUpInside];
    [self.Reduction setImage:kImage(@"添加(2)") forState:UIControlStateNormal];
    
    [self addSubview:self.Reduction];
    
    //产品销量
    self.numLbl = [UILabel labelWithBackgroundColor:kClearColor
                                          textColor:kTextColor2
                                               font:14.0];
    
    self.numLbl.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.numLbl];
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    //布局
    [self setSubviewLayout];
    
}

- (void)setSubviewLayout {
    
    CGFloat leftMargin = 15;
    
    [self.chouseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);//.with.offset(leftMargin);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    //产品图片
    [self.goodIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.chouseBtn.mas_right);//.with.offset(leftMargin);
        make.top.equalTo(self.mas_top).with.offset(leftMargin);
        make.width.height.equalTo(@(110));
    }];
    //产品名称
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.goodIV.mas_right).offset(leftMargin);
        make.top.equalTo(self.goodIV.mas_top).offset(8);
        make.right.equalTo(@(-leftMargin));
        make.height.lessThanOrEqualTo(@40);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-(leftMargin));
        make.centerY.equalTo(self.nameLbl.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    
    //产品说明
    [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(self.nameLbl.mas_bottom).offset(6);
        make.right.equalTo(@(-leftMargin));
        make.height.lessThanOrEqualTo(@20);
    }];
    //产品价格
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.bottom.equalTo(self.goodIV.mas_bottom).offset(-5);
//        make.width.lessThanOrEqualTo(@(kWidth(130)));
    }];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-(leftMargin));
        make.centerY.equalTo(self.priceLbl.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    //产品销量
    [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.addBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.priceLbl.mas_centerY);
    }];
    
    [self.Reduction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numLbl.mas_left).offset(-10);
        make.centerY.equalTo(self.priceLbl.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(25, 25));    }];
}
#pragma mark - Setting
-(void)setBrandModel:(ShopCarModel *)brandModel
{
    _brandModel = brandModel;
    
    if (brandModel.isChouse) {
        [self.chouseBtn setImage:kImage(@"选中YES") forState:UIControlStateNormal];

    }
    else
    {
        [self.chouseBtn setImage:kImage(@"未选中NO") forState:UIControlStateNormal];

    }
    
    [_goodIV sd_setImageWithURL:[NSURL URLWithString:[brandModel.product[@"pic"] convertImageUrl]] placeholderImage:GOOD_PLACEHOLDER_SMALL];
    
    _nameLbl.text = brandModel.product[@"name"];
    _descLbl.text = brandModel.product[@"slogan"];
    
    _priceLbl.text = [NSString stringWithFormat:@"￥%@", [brandModel.product[@"price"] convertToRealMoney]];
    _numLbl.text = [NSString stringWithFormat:@"%ld", [brandModel.quantity integerValue]];
    
}
- (void)chouseThis
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chouseThisCellWith:)]) {
        [self.delegate chouseThisCellWith:self.indexpath];
    }
    
//    if (self.brandModel.isChouse) {
//        [self.chouseBtn setImage:kImage(@"未选中NO") forState:UIControlStateNormal];
//
//    }
//    else
//    {
//        [self.chouseBtn setImage:kImage(@"选中YES") forState:UIControlStateNormal];
//
//    }
}
- (void)addBtnchouseThis
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(isAddWithThisGoods:withIndexpath:)]) {
        [self.delegate isAddWithThisGoods:YES withIndexpath:self.indexpath];
    }
}
- (void)ReductionchouseThis
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(isAddWithThisGoods:withIndexpath:)]) {
        [self.delegate isAddWithThisGoods:NO withIndexpath:self.indexpath];
    }
}
- (void)DeleteBtnchouseThis
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteThisGoods:)]) {
        [self.delegate deleteThisGoods:self.indexpath];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
