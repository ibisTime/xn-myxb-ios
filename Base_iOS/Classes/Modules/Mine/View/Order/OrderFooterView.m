//
//  OrderFooterView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "OrderFooterView.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface OrderFooterView()

//确认收货
@property (nonatomic, strong) UIButton *receiptBtn;
//评价
@property (nonatomic, strong) UIButton *commentBtn;
//上门
@property (nonatomic, strong) UIButton *visitBtn;
//培训结束
@property (nonatomic, strong) UIButton *overClassBtn;

@property (nonatomic,strong) UIButton *statusBtn;

@end

@implementation OrderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

#pragma mark - 懒加载
- (UIButton *)receiptBtn {
    
    if (!_receiptBtn) {
        
        _receiptBtn = [UIButton buttonWithTitle:@"确认收货"
                                     titleColor:kAppCustomMainColor
                                backgroundColor:kClearColor
                                      titleFont:14.0
                                   cornerRadius:3];
        
        _receiptBtn.layer.borderWidth = 1;
        _receiptBtn.layer.borderColor = kAppCustomMainColor.CGColor;
        
        [_receiptBtn addTarget:self action:@selector(confirmReceive) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_receiptBtn];
        
        [_receiptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@30);
            make.width.equalTo(@70);
            
        }];
        
    }
    return _receiptBtn;
}

- (UIButton *)commentBtn {
    
    if (!_commentBtn) {
        
        _commentBtn = [UIButton buttonWithTitle:@"评价"
                                     titleColor:kWhiteColor
                                backgroundColor:kThemeColor
                                      titleFont:14.0
                                   cornerRadius:3];
        
//        _commentBtn.layer.borderWidth = 1;
//        _commentBtn.layer.borderColor = kAppCustomMainColor.CGColor;
        
        [_commentBtn addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_commentBtn];
        
        [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@30);
            make.width.equalTo(@70);
            
        }];
        
    }
    return _commentBtn;
}

- (UIButton *)visitBtn {
    
    if (!_visitBtn) {
        
        _visitBtn = [UIButton buttonWithTitle:@"确认上门"
                                     titleColor:kAppCustomMainColor
                                backgroundColor:kClearColor
                                      titleFont:14.0
                                   cornerRadius:3];
        
        _visitBtn.layer.borderWidth = 1;
        _visitBtn.layer.borderColor = kAppCustomMainColor.CGColor;
        
        [_visitBtn addTarget:self action:@selector(visit) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_visitBtn];
        
        [_visitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@30);
            make.width.equalTo(@70);
            
        }];
        
    }
    return _visitBtn;
}

- (UIButton *)overClassBtn {
    
    if (!_overClassBtn) {
        
        _overClassBtn = [UIButton buttonWithTitle:@"培训结束"
                                   titleColor:kAppCustomMainColor
                              backgroundColor:kClearColor
                                    titleFont:14.0
                                 cornerRadius:3];
        
        _overClassBtn.layer.borderWidth = 1;
        _overClassBtn.layer.borderColor = kAppCustomMainColor.CGColor;
        
        [_overClassBtn addTarget:self action:@selector(overClass) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_overClassBtn];
        
        [_overClassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@30);
            make.width.equalTo(@70);
            
        }];
        
    }
    return _overClassBtn;
}

/**
 品牌
 */
- (void)setBrandOrder:(BrandOrderModel *)brandOrder {
    
    _brandOrder = brandOrder;
    
    //根据状态添加按钮
    NSInteger status = [brandOrder.status integerValue];
    
    switch (status) {
            
        case 3:
        {
            self.commentBtn.hidden = NO;
        }break;
            
        default:
            break;
    }
}

/**
 积分
 */
- (void)setIntegralOrder:(IntegralOrderModel *)integralOrder {
    
    _integralOrder = integralOrder;
    
    //根据状态添加按钮
    NSInteger status = [integralOrder.status integerValue];
    
    switch (status) {
            
        case 1:
        {
            self.receiptBtn.hidden = NO;
        }break;
            
        case 2:
        {
            self.commentBtn.hidden = NO;
        }break;
            
        default:
            break;
    }
}

/**
 预约
 */
- (void)setAppointmentOrder:(AppointmentOrderModel *)appointmentOrder {
    
    _appointmentOrder = appointmentOrder;

    //根据状态添加按钮
    NSInteger status = [appointmentOrder.status integerValue];
    
    if (status >= [kAppointmentOrderStatus_6 integerValue] && [appointmentOrder.isComment isEqualToString:@"0"]) {

        self.commentBtn.hidden = NO;

    }else {

        self.commentBtn.hidden = YES;
    }
}

/**
 成果
 */
- (void)setAchievementOrder:(AchievementOrderModel *)achievementOrder {
    
    _achievementOrder = achievementOrder;
    
    //根据状态添加按钮
    NSInteger status = [achievementOrder.status integerValue];
    
    switch (status) {
            
        case 2:
        {
            self.visitBtn.hidden = NO;
        }break;
        case 4:
        {
            self.overClassBtn.hidden = NO;
        }break;
            
        default:
            break;
    }
    
}

#pragma mark - Events
//收货
- (void)confirmReceive {
    
    if (_orderBlock) {
        
        _orderBlock(OrderEventsTypeReceiptGood);
    }
    
}

//评价
- (void)comment {
    
    if (_orderBlock) {
        
        _orderBlock(OrderEventsTypeComment);
    }
}
//上门
- (void)visit {
    
    if (_orderBlock) {
        
        _orderBlock(OrderEventsTypeVisit);
    }
}
//培训结束
- (void)overClass {
    
    if (_orderBlock) {
        
        _orderBlock(OrderEventsTypeOverClass);
    }
}

@end
