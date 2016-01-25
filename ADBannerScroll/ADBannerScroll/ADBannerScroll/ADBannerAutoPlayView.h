//
//  ADBannerAutoPlayView.h
//  ADBannerScroll
//
//  Created by jsonmess on 16/1/24.
//  Copyright © 2016年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  数据来源
 */
typedef NS_ENUM(NSInteger)
{
    //网络
    sourceNetType = 0,
    //本地
    sourceLocalType
    
}BannerSourceType;

/**
 *  banner轮播方向
 */
typedef NS_ENUM(NSInteger) {

    //左边
    bannerScrollLeft = 0,

    //右边
    bannerScrollRight
    
}BannerScrollDirection;


/// Banner轮播展示
@class ADBannerAutoPlayView;

@protocol ADBannerAutoPlayViewDelegate <NSObject>

@required
/**
 * 获取数据
 */
- (NSArray*)ADGetBannerSourceBannerAutoPlayView:(ADBannerAutoPlayView*)bannerView;

/**
 *  定时时间
 */
- (NSTimeInterval)getTheTimeToAutoBannerShow;

@optional
/**
 *  数据来源 默认来源为网络
 */
- (BannerSourceType)bannerSourceOrigin;
/**
 *  设置滚动方向
 */
- (BannerScrollDirection)getBannerScrollDirction;


@end


@interface ADBannerAutoPlayView : UIView


@property (nonatomic,weak) id<ADBannerAutoPlayViewDelegate>bannerDelegate;

@property (nonatomic) BannerScrollDirection scrollDirection;

@end
