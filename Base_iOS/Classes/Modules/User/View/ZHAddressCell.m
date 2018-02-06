//
//  ZHAddressCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/29.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHAddressCell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#define ADDRESS_CHANGE_NOTIFICATION @"ADDRESS_CHANGE_NOTIFICATION"

@interface ZHAddressCell()

@property (nonatomic,strong) UILabel *infoLbl;
@property (nonatomic,strong) UILabel *addressLbl;
@property (nonatomic,strong) UILabel *detailAddressLbl;

@property (nonatomic,strong) UIButton *selectedBtn;


@end


@implementation ZHAddressCell

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressChangeAction:) name:ADDRESS_CHANGE_NOTIFICATION object:nil];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //1.
        self.infoLbl = [UILabel labelWithFrame:CGRectMake(15, 15, kScreenWidth - 15 - 35, 0)
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:Font(15.0)
                                     textColor:kTextColor];
        [self addSubview:self.infoLbl];
        self.infoLbl.height = [Font(15.0) lineHeight];
        
        //2.
        self.addressLbl = [UILabel labelWithFrame:CGRectMake(15, self.infoLbl.yy + 10 , self.infoLbl.width, 0)
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(13)
                                     textColor:kTextColor];
        [self addSubview:self.addressLbl];
        self.addressLbl.height = [FONT(13) lineHeight];
        
        //
        self.detailAddressLbl = [UILabel labelWithFrame:CGRectMake(15, self.addressLbl.yy + 10 , self.infoLbl.width, self.addressLbl.height)
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor clearColor]
                                             font:FONT(13)
                                        textColor:kTextColor];
        [self addSubview:self.detailAddressLbl];
        
        //
        self.selectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 35, 0, 20, 20)];
        [self addSubview:self.selectedBtn];
        [self.selectedBtn setImage:[UIImage imageNamed:@"address_unselected"] forState:UIControlStateNormal];
        [self.selectedBtn addTarget:self action:@selector(selectedAddress) forControlEvents:UIControlEventTouchUpInside];
        [self.selectedBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.width.mas_equalTo(@20);
        }];
        
        
        //编ewe辑 和 删除
        CGFloat w = 70;
        UIButton *deleteBtn = [self btnWithFrame:CGRectMake(kScreenWidth - w, 110, w, 30) imageName:@"delete" title:@"删除"];
        [deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        deleteBtn.xx = kScreenWidth - 10;
//        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_right).offset(10);
//            make.top.mas_equalTo(@100);
//            make.width.equalTo();
//        }];
//        
        //编辑按钮
        UIButton *editBtn = [self btnWithFrame:CGRectMake(0, 110, w, deleteBtn.height) imageName:@"edit" title:@"编辑"];
        [editBtn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
        editBtn.xx = deleteBtn.x - 15;
        [self addSubview:editBtn];
        
     
    
        
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kLineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(@(kLineHeight));
            make.bottom.equalTo(self.mas_bottom).offset(-30);
        }];
        
    }
    

    
    return self;

}

- (UIButton *)btnWithFrame:(CGRect )frame imageName:(NSString *)imageName title:(NSString *)title {

    UIButton *editBtn = [[UIButton alloc] initWithFrame:frame];
    [self addSubview:editBtn];
    editBtn.titleLabel.font = FONT(12);
    [editBtn setTitleColor:kTextColor forState:UIControlStateNormal];
    [editBtn setTitle:title forState:UIControlStateNormal];
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [editBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return editBtn;

}

#pragma mark- 删除收货地址
- (void)delete {

    if (self.deleteAddr) {
        
        __weak typeof(self) weakSelf = self;
        self.deleteAddr(weakSelf);
        
    }

}

#pragma mark- 便捷收货地址
- (void)edit {

    if (self.editAddr) {
        
        __weak typeof(self) weakSelf = self;
        self.editAddr(weakSelf);
        
    }

}


- (void)addressChangeAction:(NSNotification *)noti {

    id obj = noti.userInfo[@"sender"];
    
    if (self.address.isSelected) {
        
        self.address.isSelected = NO;
        [self.selectedBtn setImage:[UIImage imageNamed:@"address_unselected"] forState:UIControlStateNormal];
        return;
    }
    
    if ([obj isEqual:self]) {
        
        self.address.isSelected = YES;
        [self.selectedBtn setImage:[UIImage imageNamed:@"address_selected"] forState:UIControlStateNormal];
        
    }
    
}

- (void)setIsDisplay:(BOOL)isDisplay {

    _isDisplay = isDisplay;
    
    self.selectedBtn.hidden = isDisplay;

}


- (void)selectedAddress {
    
    //已经是选中状态 return
    if (self.address.isSelected) {
        return;
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:ADDRESS_CHANGE_NOTIFICATION object:self userInfo:@{
//                                                                                                                  @"sender" : self
//                                                                                                                  }];

    
}


- (void)setAddress:(ZHReceivingAddress *)address {

    _address = address;

    self.infoLbl.text = [NSString stringWithFormat:@"%@  %@",_address.addressee,_address.mobile];
    self.addressLbl.text = [NSString stringWithFormat:@"%@ %@ %@",_address.province,_address.city,_address.district];
    self.detailAddressLbl.text = _address.detailAddress;
    if (address.isSelected) {
        
        [self.selectedBtn setImage:[UIImage imageNamed:@"address_selected"] forState:UIControlStateNormal];
        
    }
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
