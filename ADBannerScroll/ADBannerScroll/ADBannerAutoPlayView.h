//
//  ADBannerAutoPlayView.h
//  ADBannerScroll
//
//  Created by jsonmess on 16/1/24.
//  Copyright © 2016年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADBannerAutoPlayView;

@protocol ADBannerAutoPlayViewDelegate <NSObject>


- (NSArray*)ADGetBannerSourceBannerAutoPlayView:(ADBannerAutoPlayView*)bannerView;


@end



@interface ADBannerAutoPlayView : UIView

@property (nonatomic,weak) id<ADBannerAutoPlayViewDelegate>bannerDelegate;

@end
