//
//  ADBannerAutoPlayView.m
//  ADBannerScroll
//
//  Created by jsonmess on 16/1/24.
//  Copyright © 2016年 jsonmess. All rights reserved.
//

#import "ADBannerAutoPlayView.h"
#import "bannerViewCell.h"
#import "bannerTimerTool.h"

#define pageControlHeight 30.0f //

@interface ADBannerAutoPlayView()<UICollectionViewDelegate,
                                UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

//主banner滚动View
@property (nonatomic) UICollectionView *mCollectionView;
@property (nonatomic) UIPageControl *mPageControl;
@property (nonatomic) bannerTimerTool *mTimerTool;
@property (nonatomic,assign)NSTimeInterval mTimeInterval;
//用户手动拖拽
@property (nonatomic) BOOL mIsUserHanderDrag;

/**
 *  数据源
 */
@property (nonatomic) NSMutableArray* mBannerDataSource;
/**
 *  banner 数据是否来自本地  默认来自于网络
 */
@property (nonatomic,assign) BOOL isBannerFromLocal;
@end

@implementation ADBannerAutoPlayView

static NSString *reUseStr = @"bannerReUseStr";

#pragma mark ------初始化

- (void)setBannerDelegate:(id<ADBannerAutoPlayViewDelegate>)bannerDelegate
{
    _bannerDelegate = bannerDelegate;
    [self initViews];
}


- (void)initViews
{
  
    [self  setBackgroundColor:[UIColor redColor]];
    self.mBannerDataSource = [NSMutableArray array];
    self.isBannerFromLocal = NO;
    self.mIsUserHanderDrag = NO;
    //读取数据源
    NSArray * sourceArray = [NSArray array];
    if ([self.bannerDelegate respondsToSelector:@selector(ADGetBannerSourceBannerAutoPlayView:)])
    {
       sourceArray = [self.bannerDelegate ADGetBannerSourceBannerAutoPlayView:self];
    }
    BOOL tmpSourceExist = sourceArray != nil && sourceArray.count>0 ;
    if (tmpSourceExist)
    {
        [self packageTheDataSourceWithSource:sourceArray];
    }
    self.mTimerTool = [[bannerTimerTool alloc] init];
    if ([self.bannerDelegate respondsToSelector:@selector(bannerSourceOrigin)])
    {
        self.isBannerFromLocal = [self.bannerDelegate bannerSourceOrigin];
    }
    //flowLayout
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:self.frame.size];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.mCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    [self.mCollectionView setPagingEnabled:YES];
    [self.mCollectionView setDelegate:self];
    [self.mCollectionView setDataSource:self];
    [self.mCollectionView setBackgroundColor:[UIColor whiteColor]];
    [self.mCollectionView setShowsHorizontalScrollIndicator:NO];
    [self addSubview:self.mCollectionView];
    CGSize viewSize = self.frame.size;
    CGRect pageControlFrame = CGRectMake(0, viewSize.height - pageControlHeight - 5.0f,viewSize.width,pageControlHeight);
    self.mPageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    [self addSubview:self.mPageControl];
    [self.mPageControl setNumberOfPages:tmpSourceExist ? sourceArray.count : 1];
    //register Cell
    [self.mCollectionView registerClass:[bannerViewCell class] forCellWithReuseIdentifier:reUseStr];

    [self.mCollectionView reloadData];
    if (sourceArray.count > 1 )
    {
       [self.mCollectionView setContentOffset:CGPointMake(self.mCollectionView.frame.size.width, 0) animated:NO];
    }
    //滚动方向
    self.scrollDirection = bannerScrollRight;
    if ([self.bannerDelegate respondsToSelector:@selector(getBannerScrollDirction)])
    {
        self.scrollDirection = [self.bannerDelegate getBannerScrollDirction];
    }
    //定时
    if ([self.bannerDelegate respondsToSelector:@selector(getTheTimeToAutoBannerShow)])
    {
        self.mTimeInterval = [self.bannerDelegate getTheTimeToAutoBannerShow];
    }

    __weak typeof(self) weakSelf = self;
    self.mTimerTool.block = ^()
    {
        [weakSelf autoPlayBanner];
    };
    //启用轮播
    [self startAutoPlay];
    
}


#pragma mark ---- CollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return  self.mBannerDataSource.count;
}

-(bannerViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    bannerViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reUseStr
                                                                            forIndexPath:indexPath];
   
    NSInteger tmpIndex = indexPath.row;
    @try
    {
       if (tmpIndex >= self.mBannerDataSource.count)
       {
           NSException *arrayOutRangeError = [NSException exceptionWithName:@"OutOfArrayCount" reason:@"DataSource越界" userInfo:nil];
           @throw arrayOutRangeError;
       }
        NSString * tmpImageUrl = self.mBannerDataSource[tmpIndex];
        [cell setDataOfBanner:tmpImageUrl isFromLocal:self.isBannerFromLocal];
    }
    @catch (NSException *exception)
    {
       //数据源出现越界,暂不处理。
        
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.bannerDelegate respondsToSelector:@selector(clickBannerEvent:bannerIndex:)])
    {
        [self.bannerDelegate clickBannerEvent:self bannerIndex:indexPath];
    }
    else if(self.clickBlock)
    {
        self.clickBlock(indexPath);
    }
}

#pragma mark ---- ScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentNum = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.mPageControl.currentPage = currentNum-1;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //停止自动轮播
    [self.mTimerTool bannerAutoPlayStop];
    self.mIsUserHanderDrag = YES;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //重新开始轮播
     [self startAutoPlay];
    self.mIsUserHanderDrag = NO;
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.mIsUserHanderDrag)
    {
        [self startAutoPlay];
    }
    [self caculateNextShowPage];
}

#pragma mark ---- other tools


-(void)startAutoPlay
{
    if (_mBannerDataSource.count > 1)
    {
        [self.mTimerTool bannerAutoPlayTime:self.mTimeInterval];
        [self.mTimerTool bannerAutoPlayBegin];
    }
}
/**
 *  自动轮播
 */
-(void)autoPlayBanner
{
    NSInteger currentPage =(NSInteger)self.mCollectionView.contentOffset.x / self.mCollectionView.frame.size.width;
    
    if (self.scrollDirection == bannerScrollRight)
    {
        currentPage += 1;
        CGFloat contenOffsetX = self.mCollectionView.frame.size.width * currentPage;
        [self.mCollectionView setContentOffset:CGPointMake(contenOffsetX, 0) animated:YES];
        if (currentPage +1 >= self.mBannerDataSource.count)
        {
            //延迟操作
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(),
              ^{
                
              CGFloat  contenOffsetX = 1*self.mCollectionView.frame.size.width;
                [self.mCollectionView setContentOffset:CGPointMake(contenOffsetX, 0) animated:NO];
            });

        }
    }
    else
    {
        currentPage -= 1;
        CGFloat contenOffsetX = self.mCollectionView.frame.size.width * currentPage;
        [self.mCollectionView setContentOffset:CGPointMake(contenOffsetX, 0) animated:YES];
        if (currentPage == 0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(),
               ^{
            //延迟操作 
            CGFloat contenOffsetX = self.mCollectionView.contentSize.width - 2*self.mCollectionView.frame.size.width;
            [self.mCollectionView setContentOffset:CGPointMake(contenOffsetX, 0) animated:NO];
            });
        }
    }

}
/**
 * 拼装数据源
 *
 *  @param source 数据数组
 */
- (void)packageTheDataSourceWithSource:(NSArray*)source
{
    NSMutableArray * tmpArray = [NSMutableArray arrayWithArray:source];
    if (source.count > 1)
    {
        id lastObj = tmpArray.lastObject;
        id firstObj = tmpArray.firstObject;
        [tmpArray insertObject:lastObj atIndex:0];
        [tmpArray addObject:firstObj];
    }
    self.mBannerDataSource = tmpArray;
}

/**
 *  计算下一次展示
 */
- (void)caculateNextShowPage
{
    NSInteger currentNum = self.mCollectionView.contentOffset.x / self.mCollectionView.frame.size.width;
    if (currentNum +1 >= self.mBannerDataSource.count)
    {
        CGFloat contenOffsetX = 1*self.mCollectionView.frame.size.width;
        [self.mCollectionView setContentOffset:CGPointMake(contenOffsetX, 0) animated:NO];
    }
    else if (currentNum == 0)
    {
        CGFloat contenOffsetX = self.mCollectionView.contentSize.width - 2*self.mCollectionView.frame.size.width;
        [self.mCollectionView setContentOffset:CGPointMake(contenOffsetX, 0) animated:NO];
    }
}

@end
