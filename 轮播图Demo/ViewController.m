//
//  ViewController.m
//  轮播图Demo
//
//  Created by lang on 2017/7/12.
//  Copyright © 2017年 lang. All rights reserved.
//

#import "ViewController.h"
#import "GLPageChange.h"
#import "ScrollPageView.h"

@interface ViewController ()
{
    UIButton * btn2;
    UIButton * btn1;
}
@property (weak, nonatomic) IBOutlet UILabel *tapLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    GLPageChange *page = [[GLPageChange alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) scrollDuration:3.f];
    page.imagesArray = @[@"test1.png",@"test2.png",@"test3.png",@"test4.png",@"test5.png",@"test6.png",@"test7.png"];
    [self.view addSubview:page];
//    page.curIndex = 3;
    
    
    
    page.clickAction = ^(NSInteger currentIndex) {
        NSLog(@"currentIndex is %ld",currentIndex);
        self.tapLabel.text = [NSString stringWithFormat:@"当前点击图片为：%ld",(long)currentIndex];
    };

//    ScrollPageView *page = [[ScrollPageView alloc] initWithFrame:(CGRect){0,100,self.view.frame.size.width,200}];
//    page.dataArray = @[@"test1.png",@"test2.png",@"test3.png",@"test4.png",@"test5.png",@"test6.png",@"test7.png"];
//    [self.view addSubview:page];
    
    
//    [self test];
    
}



- (void)test{
    
    btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"btn1" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(testClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setBackgroundImage:[self createImageWithColor:[UIColor orangeColor]] forState:UIControlStateNormal];
    [btn2 setFrame:(CGRect){100,200,150,50}];
    btn1.layer.cornerRadius = 10.f;
    [self.view addSubview:btn2];
    
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"btn1" forState:UIControlStateNormal];
    [btn1 setBackgroundImage:[self createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [btn1 setFrame:(CGRect){0,0,50,50}];
    [btn1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
//    [btn2 addSubview:btn1];
    
    
    
//    [btn2 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];

    
}


- (void)testClick:(UIButton *)sender{
    // 开启倒计时效果
        
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [btn2 setTitle:@"重新发送" forState:UIControlStateNormal];
//                    [self.authCodeBtn setTitleColor:[UIColor colorFromHexCode:@"FB8557"] forState:UIControlStateNormal];
                btn2.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [btn2 setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
//                    [self.authCodeBtn setTitleColor:[UIColor colorFromHexCode:@"979797"] forState:UIControlStateNormal];
                btn2.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}



- (void)click:(UIButton *)sender{
    [btn1 setBackgroundImage:[self createImageWithColor:[UIColor redColor]] forState:UIControlStateHighlighted];
    [btn2 setTitle:@"a11" forState:UIControlStateNormal];
}


- (void)valueChange{
    [btn2 setBackgroundImage:[self createImageWithColor:[UIColor blueColor]] forState:UIControlStateNormal];
}

- (UIImage*)createImageWithColor:(UIColor*)color{
    
    CGRect rect=CGRectMake(0.0f,0.0f,1.0f,1.0f);UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();UIGraphicsEndImageContext();
    return theImage;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
