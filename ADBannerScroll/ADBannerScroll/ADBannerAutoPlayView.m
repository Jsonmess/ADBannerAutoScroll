//
//  ADBannerAutoPlayView.m
//  ADBannerScroll
//
//  Created by jsonmess on 16/1/24.
//  Copyright © 2016年 jsonmess. All rights reserved.
//

#import "ADBannerAutoPlayView.h"

#define pageControlHeight 30.0f //

@interface ADBannerAutoPlayView()

//主banner滚动View
@property (nonatomic) UIScrollView *mScrollView;
@property (nonatomic) UIPageControl *mPageControl;

@end

@implementation ADBannerAutoPlayView

#pragma mark ------初始化
/**
 * 初始化banner
 */
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

-(instancetype)init
{
   self =  [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)initViews
{
  
    self.mScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    [self.mScrollView setPagingEnabled:YES];
    [self addSubview:self.mScrollView];
    CGSize viewSize = self.frame.size;
    CGRect pageControlFrame = CGRectMake(0, viewSize.height - pageControlHeight - 5.0f,viewSize.width,viewSize.height);
    self.mPageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    [self.mPageControl setPageIndicatorTintColor:[UIColor whiteColor]];
    [self addSubview:self.mPageControl];
    //读取数据源
    NSArray * sourceArray = [self.bannerDelegate ADGetBannerSourceBannerAutoPlayView:self];
    
    if (sourceArray != nil && sourceArray.count > 0)
    {
        for (NSInteger index = 0; index < sourceArray.count; index ++)
        {
            UIImageView * tmpImageView = sourceArray[index];
            [tmpImageView setFrame:CGRectMake(0, index*viewSize.width, viewSize.width, viewSize.height)];
          // self.mScrollView addSubview:<#(nonnull UIView *)#>
        }
    }
   
  
}
#pragma mark ---- end
@end
