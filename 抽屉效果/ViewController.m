//
//  ViewController.m
//  抽屉效果
//
//  Created by Yuri on 15/10/18.
//  Copyright © 2015年 Yuri. All rights reserved.
//

#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"
@interface ViewController ()
/**    主视图*/
@property (nonatomic, weak) UIView  *mainView;

/**    左视图*/
@property (nonatomic, weak) UIView  *LeftView;

/**    右视图*/
@property (nonatomic, weak) UIView  *RightView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //添加view
    [self setUPView];
    
    //1.拖动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    //2.添加手势
    [self.mainView addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];  //(点击添加了tap事件)
    
    //2.添加手势
    [self.view addGestureRecognizer:tap];
}

- (void)tap{
    [UIView animateWithDuration:0.2 animations:^{
        self.mainView.frame = self.view.frame;
    }];
}

#define MaxR 280
#define MaxL -280
- (void)pan:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateBegan) {
            NSLog(@"开始拖动");
    }else if(pan.state == UIGestureRecognizerStateChanged){
        
        //获取手指的偏移量,相对于最原始的偏移量
        CGPoint transP =  [pan translationInView:self.mainView];
        
        NSLog(@"%f",transP.x);
        self.mainView.frame = [self setFrame:transP.x];
        //y轴方向 不偏移
//        self.mainView.transform = CGAffineTransformTranslate(self.mainView.transform, transP.x, 0);
        

        //判断 主视图的前一个师图 是否出现 1.前一个视图不出现 2.就会出现 前前视图
        if(self.mainView.frame.origin.x < 0 ){
            self.RightView.hidden = NO;
        }
        else{
            self.RightView.hidden = YES;
        }
        
        //复位操作,(相对于上一次).防止相对于最原始的偏移量
        [pan setTranslation:CGPointZero inView:self.mainView];
    
    }else if(pan.state == UIGestureRecognizerStateEnded){
        NSLog(@"手指离开");
        
        CGFloat target = 0;
        //设置  在超过屏幕1/2的时候 向右平移 然后到自定义（280）的时候停止
        if(self.mainView.frame.origin.x > screenW * 0.5){
            target = MaxR;
        }
        else if(CGRectGetMaxX(self.mainView.frame)  < screenW * 0.5){
            target = MaxL;
        }
        CGFloat offSetX = target - self.mainView.frame.origin.x;
        
        [UIView animateWithDuration:0.2 animations:^{
             self.mainView.frame = [self setFrame:offSetX];
        }];
       
    }
}
#define MaxY 100
//高度  变化
//width / x = 100 / y
- (CGRect)setFrame:(CGFloat)offsetX{
    //要改变mainView的frame  首先要拿到主视图frame
    CGRect frame = self.mainView.frame;
    
    //每次 都会计算和上次之间的间距 所以要 累加
    frame.origin.x += offsetX;
    
    //相似三角求出y值
    frame.origin.y = fabs((MaxY * frame.origin.x)/screenW);
    frame.size.height = screenH - 2 * frame.origin.y;

    return frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUPView{
    UIView *LeftView = [[UIView alloc]initWithFrame:self.view.bounds];
    LeftView.backgroundColor = [UIColor blueColor];
    _LeftView = LeftView;
    [self.view addSubview:LeftView];
    
    UIView *RightView = [[UIView alloc]initWithFrame:self.view.bounds];
    RightView.backgroundColor = [UIColor orangeColor];
    _RightView = RightView;
    [self.view addSubview:RightView];
    
    UIView *mainView = [[UIView alloc]initWithFrame:self.view.bounds];
    mainView.backgroundColor = [UIColor purpleColor];
    _mainView = mainView;
    [self.view addSubview:mainView];

}

@end
