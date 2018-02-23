//
//  AddressPickerView.m
//  testUTF8
//
//  Created by 蔡卓越 on 16/7/14.
//  Copyright © 2016年 caizhuoyue. All rights reserved.
//

#import "AddressPickerView.h"
#import "Province.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "UIView+XMGExtension.h"

#import "AddressModel.h"
#import <MJExtension.h>

@interface AddressPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic ,strong) UIView   * titleBackgroundView;/**< 标题栏背景*/
@property (nonatomic ,strong) UIButton * cancelBtn;/**< 取消按钮*/
@property (nonatomic, strong) UIButton * sureBtn;/**< 完成按钮*/

@property (nonatomic ,strong) UIPickerView   * addressPickerView;/**< 选择器*/

@property (nonatomic ,strong) NSMutableArray * pArr;/**< 地址选择器数据源,装省份模型,每个省份模型内包含城市模型*/

@property (nonatomic ,strong) NSDictionary   * dataDict;/**< 省市区数据源字典*/
@property (nonatomic ,strong) NSMutableArray <AddressProvince *>* provincesArr;/**< 省份名称数组*/
@property (nonatomic ,strong) NSMutableArray <AddressCity *>* citysArr;/**< 所有城市的数组*/
@property (nonatomic ,strong) NSMutableArray <AddressDistrict *>* areasArr;/**< 所有地区的数组*/
//
@property (nonatomic, strong) AddressModel *addressModel;


@end
@implementation AddressPickerView

- (void)tap {

    [self removeFromSuperview];

}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
        self.backgroundColor   = [UIColor colorWithWhite:0.1 alpha:0.3];
        
        
        //加载地址数据源
        [self loadAddressData];
        //加载标题栏
        [self loadTitle];
        //加载选择器
        [self loadPickerView];
    }
    return self;
}

#define SELFSIZE self.bounds.size
static CGFloat const TITLEHEIGHT = 45.0;
static CGFloat const TITLEBUTTONWIDTH = 75.0;

- (UIView *)titleBackgroundView {
    
    if (!_titleBackgroundView) {
        _titleBackgroundView = [[UIView alloc]initWithFrame:
                                CGRectMake(0, 0, SELFSIZE.width, TITLEHEIGHT)];
        _titleBackgroundView.backgroundColor = [UIColor whiteColor];
        
    }
    return _titleBackgroundView;
}

- (UIButton *)cancelBtn {
    
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]initWithFrame:
                      CGRectMake(0, 0, TITLEBUTTONWIDTH, TITLEHEIGHT)];
        [_cancelBtn setTitle:@"取消"
                    forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:kAppCustomMainColor
                         forState:UIControlStateNormal];
        [_cancelBtn addTarget:self
                       action:@selector(cancelBtnClicked)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn {
    
    if (!_sureBtn) {
        
        _sureBtn = [[UIButton alloc]initWithFrame:
                    CGRectMake(SELFSIZE.width - TITLEBUTTONWIDTH, 0, TITLEBUTTONWIDTH, TITLEHEIGHT)];
        [_sureBtn setTitle:@"完成"
                  forState:UIControlStateNormal];
        [_sureBtn setTitleColor:kAppCustomMainColor
                       forState:UIControlStateNormal];
        [_sureBtn addTarget:self
                     action:@selector(sureBtnClicked)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    self.addressPickerView.yy_size = self.height;
    
    self.titleBackgroundView.yy_size = self.addressPickerView.y;

}

- (UIPickerView *)addressPickerView {
    
    if (!_addressPickerView) {
        
        _addressPickerView = [[UIPickerView alloc]initWithFrame:
                              CGRectMake(0, TITLEHEIGHT, SELFSIZE.width, 210)];
        _addressPickerView.backgroundColor = [UIColor colorWithRed:239/255.f
                                                             green:239/255.f
                                                              blue:244.0/255.f
                                                             alpha:1.0];
        _addressPickerView.delegate = self;
        _addressPickerView.dataSource = self;
    }
    return _addressPickerView;
}

#pragma mark - 加载标题栏
- (void)loadTitle {
    
    [self addSubview:self.titleBackgroundView];
    
    [self.titleBackgroundView addSubview:self.cancelBtn];
    
    [self.titleBackgroundView addSubview:self.sureBtn];
}

#pragma mark  加载PickerView
- (void)loadPickerView {
    
    [self addSubview:self.addressPickerView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.addressPickerView selectRow:29 inComponent:0 animated:YES];
        [self.addressPickerView reloadComponent:1];
        [self.addressPickerView reloadComponent:2];


    });
  
}

#pragma mark - 加载地址数据
- (void)loadAddressData{
    
    self.provincesArr = [NSMutableArray array];
    
    self.citysArr = [NSMutableArray array];
    
    self.areasArr = [NSMutableArray array];
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"addressJSON"
                                                          ofType:@"txt"];

    NSError  * error;
    NSString * str22 = [NSString stringWithContentsOfFile:filePath
                                                 encoding:NSUTF8StringEncoding
                                                    error:&error];
    
    if (error) {
        return;
    }
    
    _dataDict = [self dictionaryWithJsonString:str22];
    
    if (!_dataDict) {
        return;
    }
    
    self.addressModel = [AddressModel new];
    
    self.addressModel.province = [AddressProvince mj_objectArrayWithKeyValuesArray:_dataDict[@"province"]];
    
    [self.provincesArr addObjectsFromArray:self.addressModel.province];

}

#pragma mark - UIPickerDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    
    if (0 == component) {
        
        return self.provincesArr.count;
    }
    else if (1 == component){
        
        NSInteger selectProvince = [pickerView selectedRowInComponent:0];
        
        self.citysArr = self.provincesArr[selectProvince].city.mutableCopy;
        
        return self.citysArr.count;
    }
    else if (2 == component){
        
        NSInteger selectProvince = [pickerView selectedRowInComponent:0];
        NSInteger selectCity     = [pickerView selectedRowInComponent:1];
        
        self.citysArr = self.provincesArr[selectProvince].city.mutableCopy;

        self.areasArr = self.citysArr[selectCity].district.mutableCopy;

        return self.areasArr.count;
    }
    
    return 0;
}

#pragma mark - UIPickerViewDelegate
#pragma mark 填充文字
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    
    if (0 == component) {
        
        AddressProvince *province = self.provincesArr[row];

        return province.name;
    }
    else if (1 == component) {
        
        NSInteger selectProvince = [pickerView selectedRowInComponent:0];
        
        AddressProvince *province = self.provincesArr[selectProvince];

        AddressCity *city = province.city[row];

        return city.name;
    }
    else if (2 == component) {
        
        NSInteger selectProvince = [pickerView selectedRowInComponent:0];

        NSInteger selectCity     = [pickerView selectedRowInComponent:1];
        
        AddressProvince *province = self.provincesArr[selectProvince];

        AddressCity *city = province.city[selectCity];

        AddressDistrict *area = city.district[row];

        return area.name;
    }
    return nil;
}

#pragma mark pickerView被选中
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    
    if (0 == component) {
        NSInteger selectCity = [pickerView selectedRowInComponent:1];
        NSInteger selectArea = [pickerView selectedRowInComponent:2];
        [pickerView reloadComponent:1];
        [pickerView selectRow:selectCity inComponent:1 animated:YES];
        [pickerView reloadComponent:2];
        [pickerView selectRow:selectArea inComponent:2 animated:YES];
        
    }
    else if (1 == component) {
        
        NSInteger selectArea = [pickerView selectedRowInComponent:2];
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:selectArea inComponent:2 animated:YES];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel) {
        
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textColor = [UIColor colorWithRed:51.0/255
                                                green:51.0/255
                                                 blue:51.0/255
                                                alpha:1.0];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:Font(15.0)];
    }
    
    pickerLabel.text = [self pickerView:pickerView
                            titleForRow:row
                           forComponent:component];
    return pickerLabel;
}

#pragma mark - 解析json

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData  * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * err;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClicked{
    if ([_delegate respondsToSelector:@selector(cancelBtnClick)]) {
        [_delegate cancelBtnClick];
    }
    [self removeFromSuperview];
    if(self.cancle) {
    
      self.cancle();
        
    }
    
}

- (void)sureBtnClicked {
    
    NSInteger selectProvince = [self.addressPickerView selectedRowInComponent:0];
    NSInteger selectCity     = [self.addressPickerView selectedRowInComponent:1];
    NSInteger selectArea     = [self.addressPickerView selectedRowInComponent:2];
    
    AddressProvince * province = self.provincesArr[selectProvince];
    
    //解决省市同时滑动未结束时点击完成按钮的数组越界问题
    if (selectCity > province.city.count - 1) {
        
        selectCity = province.city.count - 1;
    }
    
    AddressCity * city = province.city[selectCity];
    //解决省市区同时滑动未结束时点击完成按钮的数组越界问题
    if (selectArea > city.district.count - 1) {
        
        selectArea = city.district.count - 1;
    }

    [self removeFromSuperview];

    AddressDistrict *area = city.district[selectArea];
    
    if(self.confirm) {
    
        self.confirm(province.name,city.name,area.name);
    }
    
    if ([_delegate respondsToSelector:@selector(sureBtnClickReturnProvince:City:Area:)]) {
               [_delegate sureBtnClickReturnProvince:province.name
                                         City:city.name
                                         Area:area.name];
    }
    
    
}





@end
