//
//  ViewController.m
//  ADBannerScroll
//
//  Created by jsonmess on 16/1/24.
//  Copyright © 2016年 jsonmess. All rights reserved.
//

#import "ViewController.h"
#import "ADBannerAutoPlayView.h"
@interface ViewController ()<ADBannerAutoPlayViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ADBannerAutoPlayView * banner = [[ADBannerAutoPlayView alloc]
                                     initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 140)];
    [self.view addSubview:banner];
    banner.bannerDelegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSArray *)ADGetBannerSourceBannerAutoPlayView:(ADBannerAutoPlayView *)bannerView
{
    return @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"];
}

-(BannerSourceType)bannerSourceOrigin
{
    return sourceLocalType;
}

-(NSTimeInterval)getTheTimeToAutoBannerShow
{
    return 5.0f;
}
-(BannerScrollDirection)getBannerScrollDirction
{
    return bannerScrollLeft;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
