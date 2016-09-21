//
//  HLFragmentDragView.m
//  playImagetestdemo
//
//  Created by 江 on 16/7/11.
//  Copyright © 2016年 江. All rights reserved.
//

#import "HLFragmentDragView.h"
#define EveryViewSpace_FragmentView 5
#define ImageViewTag_FragmentView   100
#define PointSpace_FragmentView     10
#define NoIndex_FragmentView        999
@interface HLFragmentDragView () <UIScrollViewDelegate>
@property (nonatomic, strong) NSArray<__kindof UIImage      *> *arr;
@property (nonatomic, strong) NSArray<__kindof UIScrollView *> *sclArray;
@property (nonatomic, strong) UIView       *theKuang;
@property (nonatomic, assign) NSInteger    curScrollView;
@end
@implementation HLFragmentDragView
- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray<__kindof UIImage *> *)arr {
    if (self = [super initWithFrame:frame]) {
        self.sclArray                    = @[];
        
        self.theKuang                    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        [self addSubview:self.theKuang];
//        self.theKuang.layer.cornerRadius = 8;
        self.theKuang.layer.borderWidth  = 2;
        self.theKuang.layer.borderColor  = [UIColor orangeColor].CGColor;
        
        self.curScrollView               = NoIndex_FragmentView;
        
        [self settingImages:arr];
    }
    return self;
}
- (void)settingImages:(NSArray<__kindof UIImage *> *)arr {
    self.arr = arr;
    switch (arr.count) {
        case 1:
        {
            [self lauoutOne];
            break;
        }
        case 2:
        {
            [self lauoutTwo];
            break;
        }
        case 3:
        {
            [self lauoutThree];
            break;
        }
        case 4:
        {
            [self lauoutFour];
            break;
        }
        default:
            break;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.arr.count > 1) {
        NSInteger index = [self getIndexWithPanGestureRecognizer:scrollView.panGestureRecognizer];
        if (index != self.curScrollView && index != NoIndex_FragmentView) {
            if (self.sclArray.count > index && scrollView.isDragging) {
                UIScrollView *secondScl = self.sclArray[index];
                secondScl.layer.borderColor = [UIColor orangeColor].CGColor;
                secondScl.layer.borderWidth = 2;
            }
        }
        else {
            for (UIScrollView *scl in self.sclArray) {
                scl.layer.borderWidth = 0;
            }
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.arr.count > 1) {
        self.curScrollView = [self.sclArray indexOfObject:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.arr.count > 1) {
        NSInteger index = [self getIndexWithPanGestureRecognizer:scrollView.panGestureRecognizer];
        if (index != self.curScrollView && index != NoIndex_FragmentView) {
            if (self.sclArray.count > index) {
                UIScrollView *scl = self.sclArray[index];
                [UIView animateWithDuration:.3 animations:^{
                    CGRect frame     = scl.frame;
                    scl.frame        = scrollView.frame;
                    scrollView.frame = frame;
                    
                    [self settingFrameWithImage:[scl viewWithTag:ImageViewTag_FragmentView] withScrollView:scl];
                    [self settingFrameWithImage:[scrollView viewWithTag:ImageViewTag_FragmentView] withScrollView:scrollView];
                } completion:^(BOOL finished) {
                    NSMutableArray *muarr = self.sclArray.mutableCopy;
                    NSUInteger index1 = [muarr indexOfObject:scrollView];
                    NSUInteger index2 = index;
                    [muarr exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
                    self.sclArray = muarr.copy;
                }];
            }
        }
    }
}
#pragma mark 获取手指在哪一个scrollView
- (NSInteger)getIndexWithPanGestureRecognizer:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self];
    int i = 0;
    for (UIScrollView *scl in self.sclArray) {
        if (scl.frame.origin.x + PointSpace_FragmentView < point.x &&
            scl.frame.origin.y + PointSpace_FragmentView < point.y &&
            (scl.frame.origin.x + scl.frame.size.width - PointSpace_FragmentView > point.x) &&
            (scl.frame.origin.y + scl.frame.size.height - PointSpace_FragmentView > point.y)
            ) {
            return i;
        }
        i++;
    }
    return NoIndex_FragmentView;
}
#pragma mark 当UIScrollView尝试进行缩放的时候就会调用
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:ImageViewTag_FragmentView];
}
#pragma mark 初始化scrollview
- (UIScrollView *)getScroll {
    UIScrollView *scl                  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    scl.delegate                       = self;
    scl.layer.cornerRadius             = 0;
    scl.minimumZoomScale               = 1;
    scl.maximumZoomScale               = 2;
    scl.alwaysBounceVertical           = YES;
    scl.alwaysBounceHorizontal         = YES;
    scl.showsVerticalScrollIndicator   = NO;
    scl.showsHorizontalScrollIndicator = NO;
    return scl;
}
#pragma mark 初始化imageView
- (UIImageView *)getImageViewWithScroll:(UIScrollView *)scl withImage:(UIImage *)theImage {
    if (!scl || !theImage) {
        return nil;
    }
    CGFloat theImageRadio = theImage.size.width / theImage.size.height;
    UIImageView *tem3;
    if (theImageRadio * scl.bounds.size.height >= scl.bounds.size.width) {
        tem3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, theImageRadio * scl.bounds.size.height, scl.bounds.size.height)];
    }
    else {
        tem3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scl.bounds.size.width, scl.bounds.size.width / theImageRadio)];
    }
    scl.contentSize = CGSizeMake(tem3.bounds.size.width, tem3.bounds.size.height);
    tem3.image = theImage;
    tem3.tag = ImageViewTag_FragmentView;
    return tem3;
}
#pragma mark 改变imageView的frame
- (void)settingFrameWithImage:(UIImageView *)imgView withScrollView:(UIScrollView *)scl {
    scl.zoomScale = 1.0;
    UIImage *theImage = imgView.image;
    CGFloat theImageRadio = theImage.size.width / theImage.size.height;
    if (theImageRadio * scl.frame.size.height >= scl.frame.size.width) {
        imgView.frame = CGRectMake(0, 0, theImageRadio * scl.frame.size.height, scl.frame.size.height);
    }
    else {
        imgView.frame = CGRectMake(0, 0, scl.frame.size.width, scl.frame.size.width / theImageRadio);
    }
    scl.contentSize = CGSizeMake(imgView.bounds.size.width, imgView.bounds.size.height);
}
#pragma mark 返回所有scrollView的当前画布
- (NSArray<__kindof UIImage *> *)getScrollViewAllImage {
    NSMutableArray *temArray = @[].mutableCopy;
    for (UIScrollView *scl in self.sclArray) {
        [temArray addObject:[self getScrollViewCurrentImageWithScl:scl]];
    }
    return temArray.copy;
}
- (UIImage *)getScrollViewCurrentImageWithScl:(UIScrollView *)scl {
    UIGraphicsBeginImageContextWithOptions(scl.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef concext = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(concext, -scl.contentOffset.x, -scl.contentOffset.y);
    [scl.layer renderInContext:concext];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
#pragma mark 布局
- (void)lauoutOne {
    UIScrollView *scl = [self getScroll];
    scl.frame = CGRectMake(0,
                           0,
                           self.frame.size.width,
                           self.frame.size.height
                           );
    [self addSubview:scl];
    
    UIImageView *img = [self getImageViewWithScroll:scl withImage:self.arr.firstObject];
    [scl addSubview:img];
    self.sclArray = [self.sclArray arrayByAddingObject:scl];
}
- (void)lauoutTwo {
    if (self.arr.count == 2) {
        UIScrollView *scl = [self getScroll];
        scl.frame = CGRectMake(0,
                               0,
                               (self.frame.size.width - 1 * EveryViewSpace_FragmentView) / 2.0,
                               self.frame.size.height
                               );
        [self addSubview:scl];
        UIImageView *img = [self getImageViewWithScroll:scl withImage:self.arr.firstObject];
        [scl addSubview:img];
        
        UIScrollView *scl1 = [self getScroll];
        scl1.frame = CGRectMake(scl.frame.origin.x + scl.frame.size.width + EveryViewSpace_FragmentView,
                                0,
                                (self.frame.size.width - 1 * EveryViewSpace_FragmentView) / 2.0,
                                self.frame.size.height
                                );
        [self addSubview:scl1];
        UIImageView *img1 = [self getImageViewWithScroll:scl1 withImage:self.arr[1]];
        [scl1 addSubview:img1];
        
        self.sclArray = [self.sclArray arrayByAddingObjectsFromArray:@[scl, scl1]];
    }
}
- (void)lauoutThree {
    if (self.arr.count == 3) {
        UIScrollView *scl = [self getScroll];
        scl.frame = CGRectMake(0,
                               0,
                               (self.frame.size.width - 1 * EveryViewSpace_FragmentView) / 2.0,
                               self.frame.size.height
                               );
        [self addSubview:scl];
        UIImageView *img = [self getImageViewWithScroll:scl withImage:self.arr.firstObject];
        [scl addSubview:img];
        
        UIScrollView *scl1 = [self getScroll];
        scl1.frame = CGRectMake(scl.frame.origin.x + scl.frame.size.width + EveryViewSpace_FragmentView,
                                0,
                                (self.frame.size.width - 1 * EveryViewSpace_FragmentView) / 2.0,
                                (self.frame.size.height - 1 * EveryViewSpace_FragmentView) / 2.0
                                );
        [self addSubview:scl1];
        UIImageView *img1 = [self getImageViewWithScroll:scl1 withImage:self.arr[1]];
        [scl1 addSubview:img1];
        
        UIScrollView *scl2 = [self getScroll];
        scl2.frame = CGRectMake(scl1.frame.origin.x,
                                scl1.frame.origin.y + scl1.frame.size.height + EveryViewSpace_FragmentView,
                                (self.frame.size.width - 1 * EveryViewSpace_FragmentView) / 2.0,
                                (self.frame.size.height - 1 * EveryViewSpace_FragmentView) / 2.0
                                );
        [self addSubview:scl2];
        UIImageView *img2 = [self getImageViewWithScroll:scl2 withImage:self.arr[2]];
        [scl2 addSubview:img2];
        
        self.sclArray = [self.sclArray arrayByAddingObjectsFromArray:@[scl, scl1, scl2]];
    }
}
- (void)lauoutFour {
    if (self.arr.count == 4) {
        CGFloat imageWidth = (self.frame.size.width - 1 * EveryViewSpace_FragmentView) / 2.0;
        CGFloat imageHeight = (self.frame.size.height - 1 * EveryViewSpace_FragmentView) / 2.0;
        
        UIScrollView *scl = [self getScroll];
        scl.frame = CGRectMake(0,
                               0,
                               imageWidth,
                               imageHeight
                               );
        [self addSubview:scl];
        UIImageView *img = [self getImageViewWithScroll:scl withImage:self.arr.firstObject];
        [scl addSubview:img];
        
        UIScrollView *scl1 = [self getScroll];
        scl1.frame = CGRectMake(scl.frame.origin.x + scl.frame.size.width + EveryViewSpace_FragmentView,
                                0,
                                imageWidth,
                                imageHeight
                                );
        [self addSubview:scl1];
        UIImageView *img1 = [self getImageViewWithScroll:scl1 withImage:self.arr[1]];
        [scl1 addSubview:img1];
        
        UIScrollView *scl2 = [self getScroll];
        scl2.frame = CGRectMake(0,
                                scl.frame.origin.y + scl.frame.size.height + EveryViewSpace_FragmentView,
                                imageWidth,
                                imageHeight
                                );
        [self addSubview:scl2];
        UIImageView *img2 = [self getImageViewWithScroll:scl2 withImage:self.arr[2]];
        [scl2 addSubview:img2];
        
        UIScrollView *scl3 = [self getScroll];
        scl3.frame = CGRectMake(scl2.frame.origin.x + scl2.frame.size.width + EveryViewSpace_FragmentView,
                                scl1.frame.origin.y + scl1.frame.size.height + EveryViewSpace_FragmentView,
                                imageWidth,
                                imageHeight
                                );
        [self addSubview:scl3];
        UIImageView *img3 = [self getImageViewWithScroll:scl3 withImage:self.arr[3]];
        [scl3 addSubview:img3];
        
        self.sclArray = [self.sclArray arrayByAddingObjectsFromArray:@[scl, scl1, scl2, scl3]];
    }
}
@end
