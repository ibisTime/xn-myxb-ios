//
//  TopUpVC.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/5.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TopUpVC.h"

#import "TLTextField.h"
#import "UIControl+Block.h"
#import "ChousePayView.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "TLWXManager.h"


@interface TopUpVC ()<ChousePayViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) TLTextField *moneyTF;
@property (nonatomic , assign) BOOL isWeixin;

@end

@implementation TopUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self getPayMoney];
    
    // Do any additional setup after loading the view.
    self.title = @"充值";
    self.isWeixin = YES;
    
    if (!self.isPayExperts) {
        self.moneyTF = [[TLTextField alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 50) leftTitle:@"充值金额" rightTitle:@"¥" titleWidth:100 placeholder:@"请输入充值金额"];
        self.moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
        self.moneyTF.textAlignment = NSTextAlignmentRight;
        self.moneyTF.delegate = self;
        self.moneyTF.textColor = kThemeColor;
        
        [self.view addSubview:self.moneyTF];
    }
    
    
    
    
    
    
    ChousePayView *chousepay = [[ChousePayView alloc]init];
    [chousepay setBackgroundColor:[UIColor whiteColor]];
    chousepay.delegate = self;
    [self.view addSubview:chousepay];
    
    if (self.isPayExperts) {
        [chousepay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(@0);
            make.height.mas_equalTo(143);
        }];
    }
    else
    {
        [chousepay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(self.moneyTF.mas_bottom).with.offset(10);
            make.height.mas_equalTo(143);
        }];
        
    }
    
   
    
    
    if (self.isPayExperts) {
        NSString *pirceStr = [NSString stringWithFormat:@"    支付金额:¥%@",self.deductAmount];
        UILabel *label = [UILabel labelWithTitle:@"" frame:CGRectZero];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:15];
        label.backgroundColor = kWhiteColor;
        [self.view addSubview:label];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:pirceStr];
        [str addAttribute:NSForegroundColorAttributeName value:kTextColor2 range:NSMakeRange(0,pirceStr.length - self.deductAmount.length)];
        [str addAttribute:NSForegroundColorAttributeName value:kThemeColor range:NSMakeRange(pirceStr.length - self.deductAmount.length,self.deductAmount.length)];
        label.attributedText = str;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-kBottomInsetHeight);
            make.height.mas_equalTo(50);
            make.right.equalTo(self.view.mas_right).with.offset(-kScreenWidth/3);
        }];
        
        
        
        UIButton *addbtn = [UIButton buttonWithTitle:@"确认支付" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:18.0];
        [addbtn bk_addEventHandler:^(id sender) {
            
            
             [self getisPayExperts];
            
        } forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addbtn];
        [addbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-kBottomInsetHeight);
            make.height.mas_equalTo(50);
            make.left.equalTo(label.mas_right);
            
        }];
    }
    else
    {
        UIButton *addbtn = [UIButton buttonWithTitle:@"确认支付" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:18.0];
        [addbtn bk_addEventHandler:^(id sender) {
            
            [self requeOrder];
            
        } forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addbtn];
        [addbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-kBottomInsetHeight);
            make.height.mas_equalTo(50);
            
        }];
    }
    
    
    
    
    [TLWXManager manager].wxPay = ^(BOOL isSuccess, int errorCode) {
        switch (errorCode) {
            case WXSuccess:{
                // 发通知带出支付成功结果
                [TLAlert alertWithSucces:@"支付成功"];
                
            }
                break;
            default:{
                // 发通知带出支付失败结果
                [TLAlert alertWithSucces:@"支付失败"];
            }
                break;
        }
    };
    
}
-(void)commitMoneyButtonClickWithMoney:(BOOL)isWeixin
{
    self.isWeixin = isWeixin;
    
    
   
}

- (void)getPayMoney
{
    TLNetworking *http = [TLNetworking new];
    http.code = @"805917";
    
    if ([self.kind isEqualToString:kUserTypeSalon]) {
        http.parameters[@"ckey"] = @"SG_MRY_PAY_AMOUNT";
    }
    else if ([self.kind isEqualToString:kUserTypeBeautyGuide])
    {
        http.parameters[@"ckey"] = @"SG_MD_PAY_AMOUNT";
    }
    else
    {
        http.parameters[@"ckey"] = @"deductAmount";

    }
    
    
    [http postWithSuccess:^(id responseObject) {
        NSLog(@"------>%@",responseObject);
    } failure:^(NSError *error) {
        
    }];

}
//专家提成支付
- (void)getisPayExperts
{
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805518";
    http.parameters[@"payType"] = self.isWeixin ? @"2" : @"33";
    if (self.code.length == 0) {
        http.parameters[@"userId"] = [TLUser user].userId;
        http.code = @"805190";

    }
    else
    {
        http.parameters[@"code"] = self.code;

    }

    [http postWithSuccess:^(id responseObject) {
        NSLog(@"----->%@",responseObject);

        self.isWeixin ? [self wxPayWithInfo:responseObject] :[self AliPayWithInfo:responseObject];
    } failure:^(NSError *error) {
        
    }];

}
- (void)requeOrder
{
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802710";
    http.parameters[@"amount"] = @([self.moneyTF.text intValue] *1000);
    http.parameters[@"applyUser"] = [TLUser user].userId;
    http.parameters[@"channelType"] = self.isWeixin ? @"36" : @"30";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.isWeixin ? [self wxPayWithInfo:responseObject] :[self AliPayWithInfo:responseObject];
        NSLog(@"----->%@",responseObject);
    } failure:^(NSError *error) {
        
    }];
}
- (void)wxPayWithInfo:(NSDictionary *)info {
    
    
    NSDictionary *dict = info[@"data"];
    [WXApi registerApp:@"wx5ffb402a56672a03" enableMTA:YES];

    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = /*@"1503857421";*/[dict objectForKey:@"partnerid"];
    req.prepayId            = /*@"wx060028079524728336ac46672900456613";*/[dict objectForKey:@"prepayId"];
    req.nonceStr            = /*@"9871863287f63c8ab8ae6bfe0f4d9240";*/[dict objectForKey:@"nonceStr"];
    req.timeStamp           = /*@"1528215830";*/[[dict objectForKey:@"timeStamp"] intValue];
    req.package             = /*@"Sign WXPay";*/[dict objectForKey:@"wechatPackage"];
    req.sign                = /*@"B0E0CD16D832C4FA02B97A0678990531";*/[dict objectForKey:@"sign"];
    
    if([WXApi sendReq:req]){
        
    } else {
        
        [TLAlert alertWithError:@"充值失败"];
        
    }
    
}
- (void)AliPayWithInfo:(NSDictionary *)info
{
    [[AlipaySDK defaultService] payOrder:info[@"data"][@"signOrder"] fromScheme:@"zhshios" callback:^(NSDictionary *resultDic) {
        NSLog(@"支付宝回调--%@",resultDic);
        
        [self handleResult:resultDic];
        
    }];
}
- (void)handleResult:(NSDictionary *)resultDic {
    
    
    if( [resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
        //支付宝支付成功
        [TLAlert alertWithSucces:@"充值成功"];
    } else {
        [TLAlert alertWithSucces:@"充值失败"];

        
    }
    
    
}
#pragma mark = UITextFiledDelegte
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    return [self validateNumber:string];
    //    限制只能输入数字
    BOOL isHaveDian = YES;
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            if([textField.text length] == 0){
                if(single == '.') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        
        
        
        
        i++;
    }
    return res;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
