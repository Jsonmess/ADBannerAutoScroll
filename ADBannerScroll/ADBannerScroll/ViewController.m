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
@property (nonatomic) ADBannerAutoPlayView *banner;
@property (nonatomic) NSArray * dataSource;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"];
    self.banner = [[ADBannerAutoPlayView alloc]
                                     initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 140)];
    [self.view addSubview:self.banner];
    self.banner.bannerDelegate = self;
    self.banner.clickBlock = ^(NSIndexPath * indexPath)
    {
        NSLog(@"User clicked theBanner,Index is %ld",indexPath.row);
    };
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSArray *)ADGetBannerSourceBannerAutoPlayView:(ADBannerAutoPlayView *)bannerView
{
    return self.dataSource;
}

-(BannerSourceType)bannerSourceOrigin
{
    return sourceLocalType;
}

-(NSTimeInterval)getTheTimeToAutoBannerShow
{
    return 2.0f;
}

-(BannerScrollDirection)getBannerScrollDirction
{
    return bannerScrollRight;
}

/**
 *  刷新banner数据
 *
 *  @param sender
 */
- (IBAction)refreshBannerSourceAction:(id)sender
{
    NSInteger value = arc4random()%4;
    [self randomDataSource:value];
    [self.banner reloadBannerSource];
}

-(void)randomDataSource:(NSInteger)value
{
    switch (value) {
        case 1:
            self.dataSource = @[@"1.jpg"];
            break;
        case 2:
            self.dataSource = @[@"1.jpg",@"2.jpg"];
            break;
        case 3:
            self.dataSource = @[@"1.jpg",@"2.jpg",@"3.jpg"];
            break;
        default:
            self.dataSource = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"];
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
