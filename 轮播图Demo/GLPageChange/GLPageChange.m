//
//  GLPageChange.m
//  轮播图Demo
//
//  Created by lang on 2017/7/12.
//  Copyright © 2017年 lang. All rights reserved.
//

#import "GLPageChange.h"

@interface GLPageChange()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;   /** 小圆点 */
@property (nonatomic, strong) UIImageView *leftImageView;   /** 左侧的imageView */
@property (nonatomic, strong) UIImageView *centerImageView; /** 中间的imageView */
@property (nonatomic, strong) UIImageView *rightImageView;  /** 右侧的imageView */

@property (nonatomic, strong) NSTimer *scrollTimer;         /** 时间器 */

@property (nonatomic, assign) NSTimeInterval scrollDuration;    /** 滚动时间间隔 */

@end

@implementation GLPageChange

- (instancetype)initWithFrame:(CGRect)frame scrollDuration:(NSTimeInterval)duration{
    if (self = [super initWithFrame:frame]) {
        self.scrollDuration = 0.f;
        [self addObservers];
        [self configUI];
        
        if (duration > 0.f) {
            
            self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.scrollDuration = duration target:self selector:@selector(scrollTimerDidFired:) userInfo:nil repeats:YES];
            [self.scrollTimer setFireDate:[NSDate distantFuture]];
        }
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.scrollDuration = 0.f;
        [self addObservers];
        [self configUI];
    }
    return self;
}

-(void)dealloc{
    [self removeObservers];
    
    if (self.scrollTimer) {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}

- (void)configUI{
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.centerImageView];
    [self.scrollView addSubview:self.rightImageView];
    
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    
    [self placeSubViews];
}

- (void)placeSubViews{
    self.scrollView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.bounds) - 30.f, CGRectGetWidth(self.bounds), 20.f);
    
    CGFloat imageWidth = CGRectGetWidth(self.scrollView.bounds);
    CGFloat imageHeight = CGRectGetHeight(self.scrollView.bounds);
    
    self.leftImageView.frame = CGRectMake(imageWidth * 0, 0, imageWidth, imageHeight);
    self.centerImageView.frame = CGRectMake(imageWidth * 1, 0, imageWidth, imageHeight);
    self.rightImageView.frame = CGRectMake(imageWidth * 2, 0, imageWidth, imageHeight);
    
    self.scrollView.contentSize = CGSizeMake(imageWidth*3, 0);
    [self setScrollViewContentOffSetCenter];
}

#pragma mark - 把scrollView偏移到中心位置
- (void)setScrollViewContentOffSetCenter{
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0);
}


#pragma mark - KVO
- (void)addObservers{
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self caculateCurInde];
    }
}

#pragma mark - getters
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [UIPageControl new];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    
    return _pageControl;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        _leftImageView.backgroundColor = [UIColor clearColor];
    }
    
    return _leftImageView;
}

- (UIImageView *)centerImageView {
    if (!_centerImageView) {
        _centerImageView = [UIImageView new];
        _centerImageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
        [_centerImageView addGestureRecognizer:tap];
        _centerImageView.backgroundColor = [UIColor clearColor];
        _centerImageView.userInteractionEnabled = YES;
    }
    
    return _centerImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        _rightImageView.backgroundColor = [UIColor clearColor];
    }
    
    return _rightImageView;
}

- (void)setImagesArray:(NSArray *)imagesArray{
    if (imagesArray) {
        _imagesArray = imagesArray;
        self.curIndex = 0;
        
        if (imagesArray.count > 1) {
            [self.scrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.scrollDuration]];
            self.pageControl.numberOfPages = imagesArray.count;
            self.pageControl.currentPage = 0;
            self.pageControl.hidden = self.isShowPageControl = nil ? NO : self.isShowPageControl;
        }else{
            self.pageControl.hidden = YES;
            [self.leftImageView removeFromSuperview];
            [self.rightImageView removeFromSuperview];
            self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), 0);
        }
        
    }
}


- (void)setCurIndex:(NSInteger)curIndex{
    if (_curIndex >= 0) {
        _curIndex = curIndex;
        
        //当前索引为index时，左右两个索引的值
        NSInteger imageCount = self.imagesArray.count;
        NSInteger leftIndex = (curIndex + imageCount - 1) % imageCount;
        NSInteger rightInde = (curIndex + 1) % imageCount;
        
        //填充图片
        self.leftImageView.image = [UIImage imageNamed:self.imagesArray[leftIndex]];
        self.centerImageView.image = [UIImage imageNamed:self.imagesArray[curIndex]];
        self.rightImageView.image = [UIImage imageNamed:self.imagesArray[rightInde]];
        
        //每次滚动后，需要将当前页移动到中间位置
        [self setScrollViewContentOffSetCenter];
        self.pageControl.currentPage = curIndex;
    }
}

- (void)caculateCurInde{
    if (self.imagesArray && self.imagesArray.count > 0) {
        CGFloat pointX = self.scrollView.contentOffset.x;
        
        //临界值判断，第一个和第三个imageView的contentOffset
        CGFloat criticalValue = .2f;
        
        //向右滑动，右侧临界值的判断
        if (pointX > 2 *CGRectGetWidth(self.scrollView.bounds) - criticalValue) {
            self.curIndex = (self.curIndex + 1) % self.imagesArray.count;
        }else if (pointX < criticalValue){
            //向左滑动，左侧临界值判断
            self.curIndex = (self.curIndex + self.imagesArray.count - 1) % self.imagesArray.count;
        }
        
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.imagesArray.count > 1) {
        [self.scrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.scrollDuration]];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.imagesArray.count > 1) {
        [self.scrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.scrollDuration]];
    }
}


#pragma mark - 手势点击事件
- (void)imageClicked:(UITapGestureRecognizer *)tap{
    if (self.clickAction) {
        self.clickAction(self.curIndex);
    }
}

#pragma mark - timer action
- (void)scrollTimerDidFired:(NSTimer *)timer{
    //矫正定时器自动滚动出现的bug
    CGFloat criticalValue = .2f;
    if (self.scrollView.contentOffset.x < CGRectGetWidth(self.scrollView.bounds) - criticalValue || self.scrollView.contentOffset.x > CGRectGetWidth(self.scrollView.bounds) + criticalValue) {
        [self setScrollViewContentOffSetCenter];
    }
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.bounds), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
    
}


@end
