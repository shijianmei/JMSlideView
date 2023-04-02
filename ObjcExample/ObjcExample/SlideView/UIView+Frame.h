//
//  UIView+Frame.h
//  ObjcExample
//
//  Created by jianmei on 2023/3/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define kScreenWidth           ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight          ([UIScreen mainScreen].bounds.size.height)

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;

@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;


//判断self和View是否重叠
-(BOOL)intersectWithView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
