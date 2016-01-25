//
//  bannerTimerTool.h
//  ADBannerScroll
//
//  Created by Temporary on 16/1/25.
//  Copyright © 2016年 jsonmess. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^autoPlayBlock)();

@interface bannerTimerTool : NSObject

@property (nonatomic,copy) autoPlayBlock block;

/**
 *  设置定时时间
 *
 *  @param timeInterval 时间  不调用 则默认为3s
 */
-(void)bannerAutoPlayTime:(NSTimeInterval)timeInterval;

/**
 *  开始自动轮播
 */
-(void)bannerAutoPlayBegin;

/**
 *  停止自动轮播
 */
-(void)bannerAutoPlayStop;

/**
 *  暂停自动轮播
 */
-(void)bannerAutoPlayPause;

/**
 *  继续自动轮播
 */
-(void)bannerAutoPlayResume;
@end
