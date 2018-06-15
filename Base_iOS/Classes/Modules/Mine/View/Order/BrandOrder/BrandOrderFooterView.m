//
//  BrandOrderFooterView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandOrderFooterView.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface BrandOrderFooterView()

//确认收货
@property (nonatomic, strong) UIButton *receiptBtn;
//评价
@property (nonatomic, strong) UIButton *commentBtn;

@property (nonatomic,strong) UIButton *statusBtn;

@end

@implementation BrandOrderFooterView

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

- (void)setOrder:(BrandOrderModel *)order {
    
    _order = order;
    if ([order.status isEqualToString:kBrandOrderStatusWillType5]) {
        self.commentBtn.hidden = NO;
        self.receiptBtn.hidden = YES;
    }
    else
    {
        self.commentBtn.hidden = YES;
        self.receiptBtn.hidden = YES;
    }
    //根据状态添加按钮
//    NSInteger status = [_order.status integerValue];
//    
//    switch (status) {
//            
//        case 3:
//        {
//            self.commentBtn.hidden = NO;
//        }break;
//            
//        default:
//            break;
//    }
    
}

//收货
- (void)confirmReceive {
    
    if (_orderBlock) {
        
        _orderBlock(BrandOrderEventsTypeReceiptGood);
    }
    
}

//评价
- (void)comment {
    
    if (_orderBlock) {
        
        _orderBlock(BrandOrderEventsTypeComment);
    }
}

@end
