//
//  AboutController.m
//  IITCalculator
//
//  Created by Kevin Nick on 2012-10-12.
//  Copyright (c) 2012年 com.zen. All rights reserved.
//

#import "AboutController.h"

@interface AboutController ()

@end

@implementation AboutController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initUI];
    [self initValue];
}

- (void)initUI {    
    self.title = @"关于我们";

    UIImage * backgroundImage = [UIImage imageNamed:@"BackgroundTexture"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];
}

- (void)initValue {
    [_imgIcon setImage:[UIImage imageNamed:@"IconAbout"]];
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDict objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [infoDict objectForKey:@"CFBundleVersion"];
    _lbVersion.text = [NSString stringWithFormat:@"版本: V%@(%@)", version, build];
}

- (void)viewDidUnload {
    [self setImgIcon:nil];
    [self setLbVersion:nil];
    [super viewDidUnload];
}
@end
