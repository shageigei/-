//
//  GLPageChange.h
//  轮播图Demo
//
//  Created by lang on 2017/7/12.
//  Copyright © 2017年 lang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLPageChange : UIView

/** 当前点击索引 */
@property (nonatomic, copy) void (^clickAction)(NSInteger currentIndex);

/** 图片数组 */
@property (nonatomic, copy) NSArray *imagesArray;
@property (nonatomic, assign) NSInteger curIndex;           /** 当前视图索引 默认第1张*/
@property (nonatomic, assign) BOOL isShowPageControl;       /** 是否显示小圆点 默认显示*/


- (instancetype)initWithFrame:(CGRect)frame scrollDuration:(NSTimeInterval)duration;

@end
