//
//  ViewController.m
//  ObjcExample
//
//  Created by jianmei on 2023/3/31.
//

#import "ViewController.h"
#import "JMSlideView.h"
#import "UIView+Frame.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.view.backgroundColor = [UIColor yellowColor];
    
    JMSlideView * slideView = [[JMSlideView alloc] initWithFrame:CGRectMake(0, kScreenHeight-200, kScreenWidth, 160)];
    slideView.topH = 100;
    [self.view addSubview:slideView];

}


@end
