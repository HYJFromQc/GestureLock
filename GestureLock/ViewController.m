//
//  ViewController.m
//  GestureLock
//
//  Created by HYJ on 15/3/3.
//  Copyright © 2015年 HYJ. All rights reserved.
//

#import "ViewController.h"
#import "HYJGestureLockView.h"


@interface ViewController ()<HYJGestureLocViewDelegate>

@property(nonatomic,weak)HYJGestureLockView *lockView;
@property(nonatomic,copy)NSString *tempPwd;
@property(nonatomic,strong)NSUserDefaults *defaults;

@end

@implementation ViewController


- (IBAction)click:(id)sender {
    if (_lockView.isLineVisible) {
        _lockView.lineVisible = NO;
    }else
    {
        _lockView.lineVisible = YES;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _defaults = [NSUserDefaults standardUserDefaults];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_refresh_bg"]];
    
    HYJGestureLockView *lockView = [[HYJGestureLockView alloc] init];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    lockView.bounds = CGRectMake(0, 0, screenW, screenW);
    lockView.center = self.view.center;
    lockView.backgroundColor = [UIColor clearColor];
    lockView.delegate = self;
    [self.view addSubview:lockView];
    
    _lockView = lockView;

}

static int i = 0;
- (void)setPassword:(NSString *)password
{
    i++;
    if (i == 1 ) {
        self.tempPwd = password;
        
    } else if (i == 2){
        if ([self.tempPwd isEqualToString:password]) {
            [_defaults setObject:password forKey:@"pwdKey"];

            [self alertView:@"密码设置成功"];

        }else{

            [self alertView:@"两次密码不一样,请重设"];
            i = 0;
        }
    }

}

#pragma mark - 代理
- (void)gestureLockView:(HYJGestureLockView *)gestureLockView password:(NSString *)password
{
    NSString *pwd = [_defaults objectForKey:@"pwdKey"];
    if (pwd) {
        
        if ([password isEqualToString:pwd]) {
            [self performSegueWithIdentifier:@"sb" sender:self];
        } else {

            [self alertView:@"密码错误"];
        }
        
    } else {
        //设置密码
        [self setPassword:password];
    }
  
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"sb");
    
}


- (void)alertView:(NSString *)alertStr
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:alertStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert show];

    
}

@end
