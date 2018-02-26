//
//  IntegralExchangeView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
#import "TLTextField.h"

typedef NS_ENUM(NSInteger, ExchangeTyep) {
    
    ExchangeTyepSelectAddress = 0,  //选择地址
    ExchangeTyepExchange,           //兑换
};
typedef void(^ExchangeBlock)(ExchangeTyep type);

@interface IntegralExchangeView : BaseView

@property (nonatomic, copy) ExchangeBlock exchangeBlock;
//地址
@property (nonatomic, strong) TLTextField *addressTF;
//姓名
@property (nonatomic, strong) TLTextField *nameTF;
//手机号
@property (nonatomic, strong) TLTextField *mobileTF;

//显示
- (void)show;
//隐藏
- (void)hide;

@end
