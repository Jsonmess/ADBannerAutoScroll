//
//  bannerTimerTool.m
//  ADBannerScroll
//
//  Created by Temporary on 16/1/25.
//  Copyright © 2016年 jsonmess. All rights reserved.
//

#import "bannerTimerTool.h"

#define defaultTimeInterval 3.0f  //默认定时

@interface bannerTimerTool()

@property (nonatomic)NSTimeInterval timeInterval;

@property (nonatomic) NSTimer * mTimer;

@end

@implementation bannerTimerTool

#pragma mark --- 初始化
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initTimerWithTimeInterval:defaultTimeInterval];
    }
    return self;
}

- (void)initTimerWithTimeInterval:(NSTimeInterval)time
{
    if (!self.mTimer)
    {
        self.mTimer = [NSTimer timerWithTimeInterval:time
                                              target:self
                                            selector:@selector(autoPlayAction)
                                            userInfo:nil
                                            repeats:YES];
    }
}

/**
 *  轮播事件
 */
-(void)autoPlayAction
{
    if (self.block)
    {
        self.block();
    }
}

-(void)bannerAutoPlayTime:(NSTimeInterval)timeInterval
{
    self.timeInterval = timeInterval;
    self.mTimer = nil;
    if (timeInterval > 0)
    {
        [self initTimerWithTimeInterval:timeInterval];
    }
}
#pragma mark --- 轮播控制

-(void)bannerAutoPlayBegin
{
    if (!self.mTimer)
    {
        [self initTimerWithTimeInterval:self.timeInterval > 0 ? self.timeInterval : defaultTimeInterval];
    }
    [[NSRunLoop currentRunLoop] addTimer:self.mTimer forMode:NSDefaultRunLoopMode];
}

-(void)bannerAutoPlayStop
{
    if(self.mTimer)
    {
        [self.mTimer invalidate];
        self.mTimer = nil;
    }
}

-(void)bannerAutoPlayPause
{
    [self bannerAutoPlayStop];
}

-(void)bannerAutoPlayResume
{
    [self bannerAutoPlayBegin];
}

@end
