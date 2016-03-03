//
//  HYJGestureLocView.m
//  GestureLock
//
//  Created by HYJ on 15/3/3.
//  Copyright © 2015年 HYJ. All rights reserved.
//

#import "HYJGestureLockView.h"

@interface HYJGestureLockView ()

@property(nonatomic,assign)CGPoint lastPoint;
@property(nonatomic,strong)NSMutableArray *seletedBtns;

@end

@implementation HYJGestureLockView

- (NSMutableArray *)seletedBtns
{
    if (!_seletedBtns) {
        _seletedBtns = [NSMutableArray array];
    }
    return _seletedBtns;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpButtons];
        
        //默认连线轨迹可见
        self.lineVisible = YES;
    }
    return self;
}


#pragma mark - 绘制手势连线轨迹
- (void)drawRect:(CGRect)rect
{
    NSInteger selCount = self.seletedBtns.count;
    
    //若无选择直接返回
    if (selCount == 0) return;
    
    //创建一个路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger i = 0 ; i < selCount; i++) {
        CGPoint btnCenter = [self.seletedBtns[i] center];
        if (i == 0) {
            [path moveToPoint:btnCenter];
        } else {
            [path addLineToPoint:btnCenter];
        }
    }
    
    
    // 追回一个点的路径,也就是还没有选中时候的轨迹
    [path addLineToPoint:self.lastPoint];
    /**
     *  设置线宽样式和颜色
     */
    path.lineWidth = 9;
    path.lineJoinStyle = kCGLineCapRound;
    path.lineCapStyle = kCGLineCapRound;
    [[UIColor purpleColor] set];
    
    
    //渲染
    [path stroke];
}



#pragma mark - 手势移动
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //1判断当前触摸点是否在按钮范围内，是在设置按钮选中状态为YES；
    
    //<1.1> 获取当前点
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:touch.view];
    
    //<1.2>判断范围
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, touchPoint)) {
            
            /**
             *  把即将要选中的按钮添到数组,就是避免重复添加
             */
            if (btn.selected == NO) {
                [self.seletedBtns addObject:btn];
            }
            btn.selected = YES;
            
            
        } else//记录最后触摸点
        {
            self.lastPoint = touchPoint;
        }
    }
    
    //判断是否显示轨迹
    self.lineVisible ? [self setNeedsDisplay] :NULL;
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSMutableString *password = [NSMutableString string];
    
    //取消连线
    for (UIButton *btn in self.seletedBtns) {
        btn.selected = NO;
        [password appendFormat:@"%ld",btn.tag];
    }
    NSLog(@"密：%@",password);
    if ([self.delegate respondsToSelector:@selector(gestureLockView:password:)]) {
        [self.delegate gestureLockView:self password:password];
    }
    
    [self.seletedBtns removeAllObjects];
    
    [self setNeedsDisplay];
    
}


- (void)setUpButtons
{
    //添加9个按钮
    for (NSInteger i = 0; i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        //不可点击
        btn.userInteractionEnabled = NO;
        [self addSubview:btn];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //九宫格布局
    NSInteger count = self.subviews.count;
    CGFloat btnW = 74;
    CGFloat btnH = btnW;
    
    CGFloat margin = (self.frame.size.width - 3 * btnW) / 4;
    
    for (NSInteger i = 0; i < count; i++) {
        UIView *view = self.subviews[i];
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            
            NSInteger column = i % 3;
            NSInteger row    = i / 3;
            
            CGFloat btnX = margin + (btnW + margin) * column;
            CGFloat btnY = margin + (btnH + margin) * row;
            
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        }
    }
}
@end
