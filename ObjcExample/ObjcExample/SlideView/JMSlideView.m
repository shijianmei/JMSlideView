//
//  JMSlideView.m
//  ObjcExample
//
//  Created by jianmei on 2023/3/31.
//

   
#import "JMSlideView.h"
#import "UIView+Frame.h"

@interface JMSlideView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) float bottomH;//下滑后距离顶部的距离
@property (nonatomic, assign) float stop_y;//tableView滑动停止的位置
@property (nonatomic, assign) float smallHeight;//原始高度
@property (nonatomic, assign) float bigHeight;  //撑大的时候高度

@end

@implementation JMSlideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.smallHeight = self.height;
        
        [self setUI];
    }
    return self;
}

- (void)customTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.userInteractionEnabled = NO;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self addSubview:self.tableView];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


#pragma mark - Private Fun
- (void)goTop {
    [UIView animateWithDuration:0.5 animations:^{
        self.top = self.topH;
        self.height = self.bigHeight;
        self.tableView.height = self.bigHeight;
    }completion:^(BOOL finished) {
        self.tableView.userInteractionEnabled = YES;
    }];
}

- (void)goBack {
    [UIView animateWithDuration:0.5 animations:^{
        self.top = self.bottomH;
        self.height = self.smallHeight;
        self.tableView.height = self.smallHeight;
    }completion:^(BOOL finished) {
        self.tableView.userInteractionEnabled = NO;
    }];
}

- (void)setUI
{
    self.backgroundColor = [UIColor systemGrayColor];
    self.bottomH = self.top;
    
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:panGestureRecognizer];
    
    [self customTableView];
}

- (void)panAction:(UIPanGestureRecognizer *)pan
{
    // 获取视图偏移量
    CGPoint point = [pan translationInView:self];
    // stop_y是tableview的偏移量，当tableview的偏移量大于0时则不去处理视图滑动的事件
    if (self.stop_y>0) {
        // 将视频偏移量重置为0
        [pan setTranslation:CGPointMake(0, 0) inView:self];
        return;
    }
    
    // self.top是视图距离顶部的距离
    self.top += point.y;
    if (self.top < self.topH) {
        self.top = self.topH;
    } else {
        if (point.y > 0 && self.height > self.smallHeight) {
            CGFloat height = self.height - point.y;
            self.height = MAX(height, self.smallHeight);
            self.tableView.height = self.height;
        }
    }
    
    // self.bottomH是视图在底部时距离顶部的距离
    if (self.top > self.bottomH) {
        self.top = self.bottomH;
    } else {
        if (point.y < 0 && self.height < self.bigHeight) {
            CGFloat height = self.height - point.y;
            self.height = MIN(height, self.bigHeight);
            self.tableView.height = self.height;
        }
    }
    
    // 在滑动手势结束时判断滑动视图距离顶部的距离是否超过了屏幕的一半，如果超过了一半就往下滑到底部
    // 如果小于一半就往上滑到顶部
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        
        // 滑动速度
        CGPoint velocity = [pan velocityInView:self];
        CGFloat speed = 350;
        if (velocity.y < -speed) {
            [self goTop];
            [pan setTranslation:CGPointMake(0, 0) inView:self];
            return;
        }else if (velocity.y > speed){
            [self goBack];
            [pan setTranslation:CGPointMake(0, 0) inView:self];
            return;
        }
        
        if (self.top > kScreenHeight/2) {
            [self goBack];
        }else{
            [self goTop];
        }
    }
    
    [pan setTranslation:CGPointMake(0, 0) inView:self];
}


#pragma mark - Public Fun
- (void)setTopH:(float)topH {
    _topH = topH;
    self.bigHeight = CGRectGetMaxY(self.frame) - topH;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentPostion = scrollView.contentOffset.y;
    self.stop_y = currentPostion;
}

@end
