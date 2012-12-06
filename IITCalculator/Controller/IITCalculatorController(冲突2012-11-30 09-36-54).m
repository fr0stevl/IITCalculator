//
//  IITCalculatorController.m
//  NZKeyboard
//
//  Created by Kevin Nick on 2012-11-9.
//  Copyright (c) 2012年 com.zen. All rights reserved.
//

#import "IITCalculatorController.h"

@interface IITCalculatorController ()

@end

@implementation IITCalculatorController {

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    [self initSettings];

    _calculator = [[IITCalculator alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissSemiModalView:)
                                                 name:kSemiModalDidHideNotification
                                               object:nil];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

}

- (void)initUI {    
    UIImage * backgroundImage = [UIImage imageNamed:@"BackgroundTexture"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    UIImage *shadow = [UIImage imageNamed:@"NavigationBarShadow"];
    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -3, 320, 6)];
    shadowView.image = shadow;
    
    UIImage *separator = [UIImage imageNamed:@"GenericSeparator"];
    UIImageView *separatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, 320, 2)];
    separatorLine.image = separator;
    
    UIImageView *separatorLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 140, 320, 2)];
    separatorLine2.image = separator;
    
    UILabel *preTaxIncomeTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 36, 80, 30)];
    preTaxIncomeTitle.font = [UIFont fontWithName:HEITI_SC_MEDIUM size:20.0f];
    preTaxIncomeTitle.text = @"税前收入";
    preTaxIncomeTitle.textColor = RGB(104, 114, 121);
    preTaxIncomeTitle.shadowColor = [UIColor whiteColor];
    preTaxIncomeTitle.shadowOffset = CGSizeMake(0, 1);
    preTaxIncomeTitle.backgroundColor = [UIColor clearColor];
    
    _tfPreTaxIncome = [[ZenTextField alloc] initWithFrame:CGRectMake(100, 5, 200, 60)];
    [_tfPreTaxIncome setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:55.0f]];
    _tfPreTaxIncome.textColor = RGB(104, 114, 121);
//    _tfPreTaxIncome.backgroundColor = [UIColor lightGrayColor];
    _tfPreTaxIncome.textAlignment = UITextAlignmentRight;
    _tfPreTaxIncome.adjustsFontSizeToFitWidth = YES;
//    _tfPreTaxIncome.clearButtonMode = UITpextFieldViewModeWhileEditing;
//    _tfPreTaxIncome.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TotalAmount"]];
//    _tfPreTaxIncome.leftViewMode = UITextFieldViewModeAlways;
    _tfPreTaxIncome.delegate = self;
//    _tfPreTaxIncome.keyboardType = UIKeyboardTypeDecimalPad;
    
    _keyboardView = [[ZenKeyboardView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    _keyboardView.textField = _tfPreTaxIncome;
        
    UILabel *cityTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 102, 80, 30)];
    cityTitle.font = [UIFont fontWithName:HEITI_SC_MEDIUM size:20.0f];
    cityTitle.text = @"所在城市";
    cityTitle.textColor = RGB(104, 114, 121);
    cityTitle.shadowColor = [UIColor whiteColor];
    cityTitle.shadowOffset = CGSizeMake(0, 1);
    cityTitle.backgroundColor = [UIColor clearColor];
    
    _lbCity = [UIFactory createLinkButtonWithFrame:CGRectMake(30, 87, 250, 40)];
    [_lbCity setTitle:@"" forState:UIControlStateNormal];
//    _lbCity.backgroundColor = [UIColor lightGrayColor];
    [_lbCity.titleLabel setFont:[UIFont fontWithName:HEITI_SC_MEDIUM size:38.0f]];
    _lbCity.titleLabel.shadowColor = [UIColor whiteColor];
    _lbCity.titleLabel.shadowOffset = CGSizeMake(0, 1);
//    _lbCity.textAlignment = UITextAlignmentRight;
//    _lbCity.textColor = RGB(104, 114, 121);
    [_lbCity setTitleColor:RGB(104, 114, 121) forState:UIControlStateNormal];
    _lbCity.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_lbCity addTarget:self action:@selector(presentMapController) forControlEvents:UIControlEventTouchUpInside];

    UIButton *btnChevron = [UIFactory createButtonWithFrame:CGRectMake(290, 98, 14, 21) normalBackground:[UIImage imageNamed:@"Chevron"] highlightedBackground:nil];
    [btnChevron addTarget:self action:@selector(presentMapController) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *calcButton = [self createCalcButton];
    
    [self.view addSubview:shadowView];
    [self.view addSubview:separatorLine];
    [self.view addSubview:separatorLine2];
    [self.view addSubview:preTaxIncomeTitle];
    [self.view addSubview:_tfPreTaxIncome];
    [self.view addSubview:cityTitle];
    [self.view addSubview:_lbCity];
    [self.view addSubview:btnChevron];
    [self.view addSubview:calcButton];
    
    self.navigationItem.leftBarButtonItem = [UIFactory createBarButtonItemWithImage:[UIImage imageNamed:@"NavigationMenu"] target:self action:@selector(presentSettingsController)];
    self.navigationItem.rightBarButtonItem = [UIFactory createBarButtonItemWithImage:[UIImage imageNamed:@"ClockIcon"]target:self action:@selector(presentHistoryController)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"计算器"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:nil
                                                                            action:nil];
}

- (UIButton *)createCalcButton {    
    UIButton *calcButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [[UIImage imageNamed:@"CalcButtonNormal"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    UIImage *buttonPressedImage = [[UIImage imageNamed:@"CalcButtonNormalPushed"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    
    [calcButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [calcButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [calcButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [calcButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [calcButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [calcButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    
    CGRect frame = CGRectMake(320 - 105, 148, 37, buttonImage.size.height);
    frame.size.width = [@"计算" sizeWithFont:[UIFont boldSystemFontOfSize:20.0]].width + 50.0;
    calcButton.frame = frame;
    [calcButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [calcButton setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    [calcButton setTitle:@"计算" forState:UIControlStateNormal];
    [calcButton addTarget:self action:@selector(calculate) forControlEvents:UIControlEventTouchUpInside];
    
    return  calcButton;
}

- (void)initSettings {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *plistPath = [path stringByAppendingPathComponent:@"user-settings.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSDictionary *map = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        _pmu = [[map valueForKey:@"pmu"] doubleValue];
        _housingFund = [[map valueForKey:@"housingFund"] doubleValue];
    } else {        
        NSMutableDictionary *map =[[NSMutableDictionary alloc]init];
        [map setValue:[NSNumber numberWithDouble:_pmu] forKey:@"pmu"];
        [map setValue:[NSNumber numberWithDouble:_housingFund] forKey:@"housingFund"];
        [map writeToFile:plistPath atomically:YES];
    }
    
    plistPath = [path stringByAppendingPathComponent:@"user-data.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSDictionary *map = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        _tfPreTaxIncome.text = [FormatUtils formatCurrency:[[map valueForKey:@"preTaxIncome"] doubleValue]];
        [_lbCity setTitle:[map valueForKey:@"city"] forState:UIControlStateNormal];
    } else {
        NSMutableDictionary *map =[[NSMutableDictionary alloc]init];
        [map setValue:[NSNumber numberWithDouble:0.00] forKey:@"preTaxIncome"];
        [map setValue:@"" forKey:@"city"];
        [map writeToFile:plistPath atomically:YES];
    }
}

- (BOOL)existsKey:(NSString *)key inMap:(NSDictionary *)map {
    return [map valueForKeyPath:key] != nil;
}

- (void)calculate {
    [self writeToPlist];
    
    IncomeDetailController *detailController = nil;
    
    if (_pmu == 0.00 && _housingFund == 0.00) {
        detailController = [[IncomeDetailController alloc] initWithIncomeDetail:[_calculator calc:[FormatUtils formatDoubleWithCurrency:_tfPreTaxIncome.text] city:_lbCity.titleLabel.text threshold:kThreshold pmu:-1 housingFund:-1]];
    } else {
        detailController = [[IncomeDetailController alloc] initWithIncomeDetail:[_calculator calc:[FormatUtils formatDoubleWithCurrency:_tfPreTaxIncome.text] city:_lbCity.titleLabel.text threshold:kThreshold pmu:_pmu housingFund:_housingFund]];
    }
    
    [self.navigationController pushViewController:detailController animated:YES];
}

- (void)dismissSemiModalView:(NSNotification *) notification {
    if (notification.object == self) {
        [_tfPreTaxIncome becomeFirstResponder];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_tfPreTaxIncome becomeFirstResponder];
}

- (void)presentMapController {
    [_tfPreTaxIncome resignFirstResponder];
    
    mapController = [[MapController alloc] initWithConfig:_calculator.config];
    mapController.currentCity = _lbCity.titleLabel.text;
    mapController.delegate = self;

    [self presentSemiViewController:mapController withOptions:@{
        KNSemiModalOptionKeys.pushParentBack    : @(YES),
        KNSemiModalOptionKeys.animationDuration : @(0.5),
        KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
     }];
}

- (void)presentHistoryController {
    HistoryController *controller = [[HistoryController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)presentSettingsController {
    SettingsController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsController"];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    double val = [FormatUtils formatDoubleWithCurrency:textField.text];
    int tmp = (int)val;
    
    if (val == 0) {
        textField.text = @"0.00";
    } else if (val == tmp) { // 无小数
        textField.text = [NSString stringWithFormat:@"%.0f", val];
    } else {
        textField.text = [NSString stringWithFormat:@"%.2f", val];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.textColor = [UIColor darkGrayColor];
    double val = [FormatUtils formatDoubleWithCurrency:textField.text];
    textField.text = [FormatUtils formatCurrency:val];
}

#pragma mark - MapControllerDelegate

- (void)annotationDidSelect:(City *)city {
    [_lbCity setTitle:city.name forState:UIControlStateNormal];
    [_lbCity setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}

#pragma mark - SettingsControllerDelegate

- (void)settingsDidChangeWithPMU:(double)pmu housingFund:(double)housingFund {
    _pmu = pmu;
    _housingFund = housingFund;
}

- (void)viewDidUnload {
    mapController = nil;
    _calculator = nil;
    _keyboardView = nil;
    _lbCity = nil;
    _tfPreTaxIncome = nil;
    
    [super viewDidUnload];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)writeToPlist {    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *plistPath = [path stringByAppendingPathComponent:@"user-data.plist"];
    NSMutableDictionary *map =[[NSMutableDictionary alloc]init];
    [map setValue:[NSNumber numberWithDouble:[FormatUtils formatDoubleWithCurrency:_tfPreTaxIncome.text]] forKey:@"preTaxIncome"];
    [map setValue:_lbCity.titleLabel.text forKey:@"city"];
    [map writeToFile:plistPath atomically:YES];
}

@end
