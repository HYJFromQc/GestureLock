//
//  HYJGestureLocView.h
//  GestureLock
//
//  Created by HYJ on 15/3/3.
//  Copyright © 2015年 HYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYJGestureLockView;
@protocol  HYJGestureLocViewDelegate<NSObject>

- (void)gestureLockView:(HYJGestureLockView *)gestureLockView password:(NSString *)password;

@end

@interface HYJGestureLockView : UIView

@property(nonatomic,weak)id<HYJGestureLocViewDelegate>delegate;
/**
 *  是否显示轨迹
 */
@property(nonatomic,assign,getter=isLineVisible)BOOL lineVisible;

@end
