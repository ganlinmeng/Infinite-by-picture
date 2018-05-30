//
//  ViewController.m
//  图片轮播器WuXIanXunHuan
//
//  Created by 成 on 16/4/15.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "ViewController.h"
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define   Kpage 3
@interface ViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIPageControl *pageCtrl;
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) UIImageView *currentImageView; // 当前imageView
@property (nonatomic,weak) UIImageView *nextImageView; // 下一个imageView
@property (nonatomic,weak) UIImageView *preImageView; //上一个imageView
@property (nonatomic,assign) BOOL isDragging; // 是否正在拖动
@property (nonatomic,strong)NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollView =[[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [self.scrollView setContentSize:CGSizeMake(kDeviceWidth * 3, kDeviceWidth)];
    //  设置隐藏横向条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //  设置自动分页
    self.scrollView.pagingEnabled = YES;
    //  设置代理
    self.scrollView.delegate = self;
    //  设置当前点
    self.scrollView.contentOffset = CGPointMake(kDeviceWidth, 0);
    //  设置是否有边界
    self.scrollView.bounces = NO;
    //  初始化当前视图
    UIImageView *currentImageView =[[UIImageView alloc] init];
    currentImageView.image = [UIImage imageNamed:@"bg_01.jpg"];
    [self.scrollView addSubview:currentImageView];
    self.currentImageView = currentImageView;
    self.currentImageView.frame = CGRectMake(kDeviceWidth, 0, kDeviceWidth, kDeviceHeight);
    self.currentImageView.contentMode = UIViewContentModeScaleAspectFill;
    //  初始化下一个视图
    UIImageView *nextImageView = [[UIImageView alloc] init];
    nextImageView.image = [UIImage imageNamed:@"bg_02.jpg"];
    [self.scrollView addSubview:nextImageView];
    self.nextImageView = nextImageView;
    self.nextImageView.frame = CGRectMake(kDeviceWidth * 2, 0, kDeviceWidth, kDeviceHeight);
    self.nextImageView.contentMode = UIViewContentModeScaleAspectFill;
    //  初始化上一个视图
    UIImageView *preImageView =[[UIImageView alloc] init];
    preImageView.image = [UIImage imageNamed:@"bg_03.jpg"];
    preImageView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    [self.scrollView addSubview:preImageView];
    self.preImageView = preImageView;
    self.preImageView.contentMode =UIViewContentModeScaleAspectFill;

    //  设置时钟动画 定时器

    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(update:) userInfo:nil repeats:YES];
    //  将定时器添加到主线程
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.view addSubview:self.pageCtrl];
}
    // 分页
-(UIPageControl *)pageCtrl{
    if (_pageCtrl == nil) {
        
        //分页控件
        _pageCtrl = [[UIPageControl alloc]init];
        _pageCtrl.numberOfPages = Kpage;
        
        CGSize size = [_pageCtrl sizeForNumberOfPages:Kpage];
        _pageCtrl.bounds = CGRectMake(0, 0, size.width, size.height);
        _pageCtrl.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.scrollView.frame) - 20);
        _pageCtrl.pageIndicatorTintColor = [UIColor redColor];
        _pageCtrl.currentPageIndicatorTintColor = [UIColor greenColor];

    }
    return _pageCtrl;
}


-(void)updateTimer{
    //修改页号
    int page = (self.pageCtrl.currentPage + 1 ) % Kpage;
    self.pageCtrl.currentPage = page;
  
}


- (void)update:(NSTimer *)timer{
    //定时移动
    
    if (_isDragging == YES) {
        
        return ;
    }
    CGPoint offSet = self.scrollView.contentOffset;
    offSet.x +=offSet.x;
    
    [self updateTimer];
    
    [self.scrollView setContentOffset:offSet animated:YES];
    if (offSet.x >= kDeviceWidth *2) {
        offSet.x = kDeviceWidth;
    }
   
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isDragging = YES;
}
    //  停止滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _isDragging = NO;

}

    // 开始拖动
- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    static int i =1; //   当前展示的是第几张图片
    float offset = self.scrollView.contentOffset.x;
    if (self.nextImageView.image == nil || self.preImageView.image == nil) {
    //  加载下一个视图
    NSString *imageName1 = [NSString stringWithFormat:@"bg_0%d.jpg",i == Kpage ? 1:i +1];
    _nextImageView.image = [UIImage imageNamed:imageName1];
    // 加载上一个视图
    NSString *imageName2 = [NSString stringWithFormat:@"bg_0%d.jpg",i==1 ? Kpage :i-1];
    _preImageView.image = [UIImage imageNamed:imageName2];
     
    }
    if(offset ==0){
        _currentImageView.image = _preImageView.image;
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        _preImageView.image = nil;
        if (i == 1) {
        i =Kpage;
        } else{
        i-=1;
        }

    }
    if (offset == scrollView.bounds.size.width * 2) {
        _currentImageView.image = _nextImageView.image;
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        _nextImageView.image = nil;
        if (i == Kpage) {
        i = 1 ;
        }else{
        i +=1 ;
        }
      
    }
   
}


@end
