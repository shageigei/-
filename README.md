# 轮播图



使用方法：

``` objective-c
GLPageChange *page = [[GLPageChange alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) scrollDuration:3.f];
    page.imagesArray = @[@"test1.png",@"test2.png",@"test3.png",@"test4.png",@"test5.png",@"test6.png",@"test7.png"];
    [self.view addSubview:page];
    //指定初始显示图片
 //    page.curIndex = 3;
    
    
 //点击当前图片的索引
  page.clickAction = ^(NSInteger currentIndex) {
        NSLog(@"currentIndex is %ld",currentIndex);
        self.tapLabel.text = [NSString stringWithFormat:@"当前点击图片为：%ld",(long)currentIndex];
    };
```





![scrollImage](../轮播图Demo:计时器/scrollImage.gif)