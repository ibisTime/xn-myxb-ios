//
//  WithdrawalDetailsVC.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/5.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "WithdrawalDetailsVC.h"
#import "TLTextField.h"
#import "NSString+Date.h"
#import "NSString+Check.h"
#import "TLPickerTextField.h"
#import "UIControl+Block.h"
@interface WithdrawalDetailsVC ()<UITextFieldDelegate>
//预约时间
@property (nonatomic, strong) TLTextField *peopleNmaeTF;
@property (nonatomic, strong) TLTextField *bankCardTF;
@property (nonatomic, strong) TLTextField *numberTF;
@property (nonatomic, strong) TLTextField *moneyTF;
@property (nonatomic, strong) UILabel *poundageLabel;
@end

@implementation WithdrawalDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat leftMargin = 0;
    CGFloat leftW = 120;
    CGFloat tfH = 50;
    CGFloat tfW = kScreenWidth;
    
    self.peopleNmaeTF = [[TLTextField alloc] initWithFrame:CGRectMake(leftMargin, 0, tfW, tfH) leftTitle:@"持卡人" titleWidth:leftW placeholder:@"请输入姓名"];
    
    [self.view addSubview:self.peopleNmaeTF];
    
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.peopleNmaeTF.frame), kScreenWidth, .5)];
    lineview.backgroundColor = kSilverGreyColor;
    [self.view addSubview:lineview];
    
    self.bankCardTF = [[TLTextField alloc] initWithFrame:CGRectMake(leftMargin, CGRectGetMaxY(lineview.frame), tfW, tfH) leftTitle:@"开户行" titleWidth:leftW placeholder:@"请输入开户行"];
    
    [self.view addSubview:self.bankCardTF];
    
    UIView *lineview2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bankCardTF.frame), kScreenWidth, .5)];
    lineview2.backgroundColor = kSilverGreyColor;
    [self.view addSubview:lineview2];
    
    self.numberTF = [[TLTextField alloc] initWithFrame:CGRectMake(leftMargin, CGRectGetMaxY(lineview2.frame), tfW, tfH) leftTitle:@"卡号" titleWidth:leftW placeholder:@"银行卡号"];
    self.numberTF.keyboardType = UIKeyboardTypeNumberPad;
    self.numberTF.delegate = self;
    [self.view addSubview:self.numberTF];
    
    UIView *lineview3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.numberTF.frame), kScreenWidth, .5)];
    lineview2.backgroundColor = kSilverGreyColor;
    [self.view addSubview:lineview3];
    
    UILabel *titleLabel = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:18.0];
    titleLabel.text = @"提现金额";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(lineview3.mas_bottom).with.offset(30);
        make.height.equalTo(@18);
    }];
    
    self.moneyTF = [[TLTextField alloc]initWithFrame:CGRectMake(leftMargin, CGRectGetMaxY(lineview3.frame) + 15 + 18 + 20, tfW, 50) leftTitle:@"¥" titleWidth:40 placeholder:@""];
    self.moneyTF.keyboardType = UIKeyboardTypeNumberPad;
    self.moneyTF.leftLbl.font = [UIFont systemFontOfSize:20];
    self.moneyTF.delegate = self;
    [self.view addSubview:self.moneyTF];
    
    
    UILabel *subtitleLabel = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:18.0];
    subtitleLabel.text = [NSString stringWithFormat:@"可提现金额¥%@",[TLUser user].rmbamount];
    subtitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:subtitleLabel];
    
    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(self.moneyTF.mas_bottom).with.offset(10);
        make.height.equalTo(@18);
    }];
    
    
    self.poundageLabel = [UILabel labelWithBackgroundColor:kClearColor textColor:kThemeColor font:15.0];
    self.poundageLabel.text = [NSString stringWithFormat:@"*本次手续费:0"];
    self.poundageLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:self.poundageLabel];
    
    [self.poundageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(subtitleLabel.mas_bottom).with.offset(10);
        make.height.equalTo(@15);
    }];
    
    UIButton *addbtn = [UIButton buttonWithTitle:@"确定" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:18.0];
    [addbtn bk_addEventHandler:^(id sender) {
        
        [self poundageNow];
        
    } forControlEvents:UIControlEventTouchUpInside];
    addbtn.layer.cornerRadius = 5;
    [self.view addSubview:addbtn];
    [addbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.top.equalTo(self.poundageLabel.mas_bottom).with.offset(20);
        make.height.mas_equalTo(50);
        
    }];
    
    
    UILabel *textLabel = [UILabel labelWithBackgroundColor:kClearColor textColor:kThemeColor    font:15.0];
    textLabel.numberOfLines = 0;
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.text = @"取现规则:\n1.每月最大取现次数为5次\n2.提现金额是5的倍数,单笔最高50000\n3.取现手续费:1.0%";
    [self.view addSubview:textLabel];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@15);
        make.top.equalTo(addbtn.mas_bottom).with.offset(15);
    }];
    
    
}

- (void)poundageNow
{
    
    if ([[TLUser user].rmbamount isEqualToString:@0]) {
        
        [TLAlert alertWithMsg:@"余额不足"];
        return;
    }
    
    if(![self.moneyTF.text valid]) {
        
         [TLAlert alertWithMsg:@"请输入提现金额"];
        return;
        
    }
    
    //
    if ([self.moneyTF.text floatValue] > [[TLUser user].rmbamount floatValue]) {
        
         [TLAlert alertWithMsg:@"余额不足"];
        return;
    }
    
    if (![self.bankCardTF.text valid]) {
        
         [TLAlert alertWithMsg:@"请选择银行卡"];
        return;
    }
    
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802751";
    
    
    http.parameters[@"accountNumber"] = [TLUser user].rmbAccountNumber;
    //
    http.parameters[@"amount"] = @([self.moneyTF.text integerValue] * 1000);   //@"-100";
    //银行卡号
    http.parameters[@"payCardInfo"] = self.bankCardTF.text; //开户行信息
    http.parameters[@"payCardNo"] = self.numberTF.text; //银行卡号

    
    
    http.parameters[@"applyUser"] = [TLUser user].userId;
    http.parameters[@"applyNote"] = @"iOS用户端取现";
    [http postWithSuccess:^(id responseObject) {
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.moneyTF && [self validateNumber:string]) {
        NSString *moneyset = [textField.text stringByAppendingString:string];
        NSInteger moneyInter = [moneyset intValue];
        float asd = moneyInter *0.01;
        
        NSString *poundage = [NSString stringWithFormat:@"*本次手续费:%.2f",asd];
        self.poundageLabel.text = poundage;
    }
    
    return [self validateNumber:string];
}

#pragma mark = UITextFiledDelegte
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
