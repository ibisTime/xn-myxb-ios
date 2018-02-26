//
//  IntegralOrderFooterView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IntegralOrderFooterView.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface IntegralOrderFooterView()
//确认收货
@property (nonatomic, strong) UIButton *receiptBtn;
//评价
@property (nonatomic, strong) UIButton *commentBtn;

@property (nonatomic,strong) UIButton *statusBtn;

@end

@implementation IntegralOrderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
//        UIButton *btn = [UIButton buttonWithTitle:@""
//                                       titleColor:kThemeColor
//                                  backgroundColor:kClearColor
//                                        titleFont:14.0
//                                     cornerRadius:3];
//
//        [self addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).offset(15);
//            make.centerY.equalTo(self.mas_centerY);
//            make.height.equalTo(@30);
//            make.width.equalTo(@70);
//
//        }];
//
//        self.statusBtn = btn;
        
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
                                     titleColor:kAppCustomMainColor
                                backgroundColor:kClearColor
                                      titleFont:14.0
                                   cornerRadius:3];
        
        _commentBtn.layer.borderWidth = 1;
        _commentBtn.layer.borderColor = kAppCustomMainColor.CGColor;
        
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

- (void)setOrder:(IntegralOrderModel *)order {
    
    _order = order;
    
    //按钮状态
//    [self.statusBtn setTitle:[_order getStatusName] forState:UIControlStateNormal];
    //根据状态添加按钮
    NSInteger status = [_order.status integerValue];
    
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

//收货
- (void)confirmReceive {
    
    if (_orderBlock) {
        
        _orderBlock(IntegralOrderEventsTypeReceiptGood);
    }
    
}

//评价
- (void)comment {
    
    if (_orderBlock) {
        
        _orderBlock(IntegralOrderEventsTypeComment);
    }
}
@end
