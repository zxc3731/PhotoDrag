//
//  HLFragmentDragView.h
//  playImagetestdemo
//
//  Created by 江 on 16/7/11.
//  Copyright © 2016年 江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLFragmentDragView : UIView
- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray<__kindof UIImage *> *)arr;
- (NSArray<__kindof UIImage *> *)getScrollViewAllImage;
@end
