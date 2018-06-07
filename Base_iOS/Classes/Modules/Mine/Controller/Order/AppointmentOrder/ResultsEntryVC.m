//
//  ResultsEntryVC.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/6.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ResultsEntryVC.h"
#import "ResultsView.h"
#import "TLTextField.h"
#import "TLDatePicker.h"
#import "NSString+Date.h"
#import "UILabel+Extension.h"
#import "UIButton+Custom.h"
#import "UIControl+Block.h"
#import "ChouseBrand.h"
@interface ResultsEntryVC ()
@property (nonatomic , strong) UIScrollView *bgScroView;
@property (nonatomic , strong)TLTextField *timeTF;
@property (nonatomic, strong) TLDatePicker *datePicker;
@property (nonatomic , strong)NSMutableArray *chouseBandArry;
@property (nonatomic , strong)UIButton *addbtn;
@property (nonatomic , strong)NSMutableArray *chouseTLFiledArry;

@property (nonatomic , strong)TLTextField *datTF;

@property (nonatomic , strong)TLTextField *peopleTF;

@property (nonatomic , strong)TLTextField *OKpeopleTF;



@end

@implementation ResultsEntryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BaseWeakSelf;
    self.chouseBandArry = [NSMutableArray arrayWithCapacity:0];
    self.chouseTLFiledArry = [NSMutableArray arrayWithCapacity:0];

    self.title = @"成果录入";
    ResultsView *headerview = [[ResultsView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 130) withOrder:self.chouseOrder];
    [self.bgScroView addSubview:headerview];
    
    //预约时间
    CGFloat leftMargin = 0;
    CGFloat leftW = 120;
    CGFloat tfH = 50;
    CGFloat tfW = kScreenWidth;
    
    self.timeTF = [[TLTextField alloc] initWithFrame:CGRectMake(leftMargin, headerview.height, tfW, tfH) leftTitle:@"预约开始时间" titleWidth:leftW placeholder:@"请选择开始时间"];
    
    [self.bgScroView addSubview:self.timeTF];
    //点击手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTime)];
    
    [self.timeTF addGestureRecognizer:tapGR];
    //右箭头
    CGFloat arrowW = 6;
    CGFloat arrowH = 10;
    CGFloat rightMargin = 10;
    
    UIImageView *arrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
    arrowIV.frame = CGRectMake(tfW - rightMargin - arrowW, 0, arrowW, arrowH);
    arrowIV.centerY = tfH/2.0;
    
    [self.timeTF addSubview:arrowIV];
    
    
    self.datTF = [[TLTextField alloc]initWithFrame:CGRectMake(0, self.timeTF.yy, tfW, tfH) leftTitle:@"工作天数" rightTitle:@"天" titleWidth:leftW placeholder:@"请输入工作天数"];
    self.datTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.bgScroView addSubview:self.datTF];
    
    self.peopleTF = [[TLTextField alloc]initWithFrame:CGRectMake(0, self.datTF.yy, tfW, tfH) leftTitle:@"见客户数" rightTitle:@"人" titleWidth:leftW placeholder:@"请输入见客户数"];
    self.peopleTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.bgScroView addSubview:self.peopleTF];
    
    self.OKpeopleTF = [[TLTextField alloc]initWithFrame:CGRectMake(0, self.peopleTF.yy, tfW, tfH) leftTitle:@"成交客户数" rightTitle:@"人" titleWidth:leftW placeholder:@"请输入成交客户数"];
    self.OKpeopleTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.bgScroView addSubview:self.OKpeopleTF];
    
    
    UILabel *yeji = [UILabel labelWithBackgroundColor:[UIColor whiteColor] textColor:[UIColor colorWithHexString:@"#484848"] font:15];
    yeji.textAlignment = NSTextAlignmentLeft;
    yeji.text = @"    销售业绩";
    yeji.frame = CGRectMake(0, self.OKpeopleTF.yy, kScreenWidth, 50);
    [self.bgScroView addSubview:yeji];
    
    float linviewY = self.timeTF.yy;
    for (NSInteger index = 0; index < 5; index ++) {
        UIView *lineview = [[UIView alloc]init];
        lineview.backgroundColor = kSilverGreyColor;
        lineview.frame = CGRectMake(0, linviewY, kScreenWidth, .5);
        [self.bgScroView addSubview:lineview];
        linviewY += 50.0;
    }
    
    
    self.addbtn = [UIButton buttonWithTitle:@"添加" titleColor:[UIColor colorWithHexString:@"#484848"] backgroundColor:kWhiteColor titleFont:18.0];
    self.addbtn.frame = CGRectMake(0, yeji.yy, kScreenWidth, 50);
    [self.addbtn bk_addEventHandler:^(id sender) {
        
        ChouseBrand *chouseView = [[ChouseBrand alloc]init];
        chouseView.brand = ^(BrandModel *model) {
            [weakSelf.chouseBandArry addObject:model];
            [weakSelf changeUI];
        };
        [self.navigationController pushViewController:chouseView animated:YES];

        
    } forControlEvents:UIControlEventTouchUpInside];
    [self.bgScroView addSubview:self.addbtn];
    
    
    
    UIButton *entrybtn = [UIButton buttonWithTitle:@"录入" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:18.0];
    entrybtn.frame = CGRectMake(15, kScreenHeight - kBottomInsetHeight - 50 - kNavigationBarHeight,kScreenWidth - 30, 50);
    entrybtn.layer.cornerRadius = 5;
    [entrybtn bk_addEventHandler:^(id sender) {
        
        [self sendEntry];
        
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:entrybtn];
    
}
#pragma mark - Events
- (void)selectTime {
    
    [self.datePicker show];
    
}
#pragma mark - LazyLoad
- (TLDatePicker *)datePicker {
    
    if (!_datePicker) {
        
        BaseWeakSelf;
        
        _datePicker = [TLDatePicker new];
        _datePicker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        
        [_datePicker setConfirmAction:^(NSDate *date) {
            
            weakSelf.timeTF.text = [NSString stringFromDate:date formatter:@"yyyy-MM-dd HH:mm:ss"];
//            weakSelf.currentDate = date;
        }];
    }
    return _datePicker;
}
- (void)changeUI
{

    BrandModel *mode = [self.chouseBandArry lastObject];
    
    TLTextField *OKpeopleTF = [[TLTextField alloc]initWithFrame:CGRectMake(0, self.addbtn.y, kScreenWidth, 50) leftTitle:mode.name rightTitle:@"¥" titleWidth:120 placeholder:@"请输入该品牌的销售业绩"];
    OKpeopleTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.bgScroView addSubview:OKpeopleTF];
    
    self.addbtn.y = OKpeopleTF.yy;
    [self.chouseTLFiledArry addObject:OKpeopleTF];
    self.bgScroView.contentSize = CGSizeMake(kScreenWidth, 130 + ( 7 * 50) + (self.chouseTLFiledArry.count *50));
    
}
-(UIScrollView *)bgScroView
{
    if (!_bgScroView) {
        _bgScroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kBottomInsetHeight - 50)];
        _bgScroView.backgroundColor =self.view.backgroundColor;
        [self.view addSubview:_bgScroView];
    }
    return _bgScroView;
}

- (void)sendEntry
{
    TLNetworking *http = [TLNetworking new];
    
    
    
    NSInteger moneyAll = 0;
    
    for (TLTextField *textFiled in self.chouseTLFiledArry) {
        moneyAll += [textFiled.text integerValue] * 1000 ;
    }
    
    NSMutableArray *detailList = [NSMutableArray arrayWithCapacity:0];
    
    
    for (NSInteger index = 0; index < self.chouseBandArry.count; index ++) {
        BrandModel *model = [self.chouseBandArry objectAtIndex:index];
        TLTextField *textF = [self.chouseTLFiledArry objectAtIndex:index];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @([textF.text intValue] * 1000), @"amount",
                              model.code, @"brandCode",
                              nil];
    
        [detailList addObject:dic];
    }
    
    
    http.showView =self.view;
    http.code = @"805514";
    //见客户数
    http.parameters[@"clientNumber"] = self.peopleTF.text;
    http.parameters[@"code"] = self.chouseOrder.code;
    http.parameters[@"updater"] = [TLUser user].userId;
    //实际上门时间
    http.parameters[@"realDatetime"] = self.timeTF.text;
    //实际上门天数
    http.parameters[@"realDays"] = self.datTF.text;
    //销售额
    http.parameters[@"saleAmount"] = @(moneyAll);
    //成交客户数
    http.parameters[@"sucNumber"] = self.OKpeopleTF.text;
    
    http.parameters[@"detailList"] = detailList;

    
    [http postWithSuccess:^(id responseObject) {
        [TLAlert alertWithSucces:@"成果录入成功"];
        
        NSMutableArray *arry = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [arry removeObjectAtIndex:arry.count - 2];
        self.navigationController.viewControllers = arry;
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];

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
