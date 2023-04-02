//
//  JMSlideView.h
//  ObjcExample
//
//  Created by jianmei on 2023/3/31.
//

   
#import <UIKit/UIKit.h>
 
NS_ASSUME_NONNULL_BEGIN

/**
 * 滑动弹窗
 */
@interface JMSlideView : UIView
@property (nonatomic,assign) float topH;//上滑后距离顶部的距离
//@property (nonatomic, assign) float maxHeight;  //可以撑的最大的高度

@end

NS_ASSUME_NONNULL_END
