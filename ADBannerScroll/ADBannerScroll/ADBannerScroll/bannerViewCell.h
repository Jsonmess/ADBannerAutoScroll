//
//  bannerViewCell.h
//  ADBannerScroll
//
//  Created by Temporary on 16/1/25.
//  Copyright © 2016年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bannerViewCell : UICollectionViewCell

@property (nonatomic)  UIImageView *showImageView;

/**
 *  设置banner Url;
 *
 *  @param bannerUrlStr url
 */
-(void)setDataOfBanner:(NSString*)bannerUrlStr isFromLocal:(BOOL)islocal;

@end
