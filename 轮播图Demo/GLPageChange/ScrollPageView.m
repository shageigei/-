//
//  ScrollPageView.m
//  轮播图Demo
//
//  Created by lang on 2018/4/16.
//  Copyright © 2018年 lang. All rights reserved.
//

#import "ScrollPageView.h"

@interface ScrollPageView()<UIScrollViewDelegate> {
    NSInteger currentIndex;
    NSInteger count;
    NSTimer *timer;
}

@property (nonatomic, strong) UIScrollView *lopScrollView;

@property (nonatomic, strong) UIImageView *leftImgView;         /*!< 左侧的imgView*/
@property (nonatomic, strong) UIImageView *centerImgView;       /*!< 中间的imgView*/
@property (nonatomic, strong) UIImageView *rightImgView;        /*!< 右侧的imgView*/

@end

@implementation ScrollPageView

static const int viewNumber = 3;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        currentIndex = 0;
    }
    return self;
}


- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    count = dataArray.count;
    
    //新建ScrollView
    [self createScrollView];
    
    //新建定时器
    [self creatTimer];
    
    //pageControl
    
}

- (void)creatTimer{
    
    __weak typeof(self) WeakSelf = self;
    timer = [NSTimer timerWithTimeInterval:1.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
        [WeakSelf timeAction];
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)timeAction{
    
    [self.lopScrollView scrollRectToVisible:(CGRect){2*self.frame.size.width,0,self.frame.size.width,self.frame.size.height} animated:YES];
}

- (void)invalidateTimer{
    [timer invalidate];
    timer = nil;
}

- (void)createScrollView{
    
    self.lopScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.lopScrollView.pagingEnabled = YES;
    self.lopScrollView.delegate = self;
    self.lopScrollView.showsVerticalScrollIndicator = NO;
    self.lopScrollView.showsHorizontalScrollIndicator = NO;
    self.lopScrollView.contentSize = CGSizeMake(self.bounds.size.width *viewNumber, self.bounds.size.height);
    [self addSubview:self.lopScrollView];
    
    self.leftImgView = [[UIImageView alloc] initWithFrame:(CGRect){0,0,self.bounds.size.width,self.bounds.size.height}];
    self.leftImgView.image = [UIImage imageNamed:_dataArray[count - 1]];
    
    self.centerImgView = [[UIImageView alloc] initWithFrame:(CGRect){self.bounds.size.width,0,self.bounds.size.width,self.bounds.size.height}];
    self.centerImgView.image = [UIImage imageNamed:_dataArray[0]];
    
    self.rightImgView = [[UIImageView alloc] initWithFrame:(CGRect){self.bounds.size.width * 2,0,self.bounds.size.width,self.bounds.size.height}];
    self.rightImgView.image = [UIImage imageNamed:_dataArray[1]];
    
    [self.lopScrollView addSubview:self.leftImgView];
    [self.lopScrollView addSubview:self.centerImgView];
    [self.lopScrollView addSubview:self.rightImgView];
    
    //设置初始偏移量
    self.lopScrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == 2 * self.frame.size.width) {
        //滑到最右边
        currentIndex++;
        //重新计算
        [self calculateImg];
    } else if (scrollView.contentOffset.x == 0){
        currentIndex = currentIndex + count;
        currentIndex--;
        [self calculateImg];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x == 2 * self.frame.size.width) {
        //滑到最右边
        currentIndex++;
        //重新计算
        [self calculateImg];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //准备拖动的时候，定时器失效
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self creatTimer];
}

- (void)calculateImg{
    
    self.leftImgView.image = [UIImage imageNamed:_dataArray[(currentIndex-1)%count]];
    self.centerImgView.image = [UIImage imageNamed:_dataArray[(currentIndex)%count]];
    self.rightImgView.image = [UIImage imageNamed:_dataArray[(currentIndex+1)%count]];
    
    self.lopScrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
}











@end
