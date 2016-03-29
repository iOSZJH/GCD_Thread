//
//  ViewController.m
//  GCD_Thread
//
//  Created by 张锦辉 on 16/3/23.
//  Copyright © 2016年 张锦辉. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIImage *image1;
    UIImage *image2;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
}



- (IBAction)GCD_sync:(id)sender {
    
    [self syncMain];
    //[self syncSerial];
    //[self syncConcurrent];
   
}


- (IBAction)GCD_async:(id)sender {
    
    //[self asyncMain];
    //[self asyncSerial];
   // [self asyncConcurrent];
    
    [self asyncGroup];
    
}




/**
 * 同步函数 + 主队列：
 */
- (void)syncMain
{
    NSLog(@"syncMain ----- begin");
    // 1.获得主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 2.将任务加入队列
    dispatch_sync(queue, ^{
        NSLog(@"1-----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2-----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3-----%@", [NSThread currentThread]);
    });
    
    NSLog(@"syncMain ----- end");
}



/**
 * 异步函数 + 主队列：只在主线程中执行任务
 */
- (void)asyncMain {
    // 1.获得主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 2.将任务加入队列
    dispatch_async(queue, ^{
        NSLog(@"1-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"3-----%@", [NSThread currentThread]);
    });
}


/**
 * 同步函数 + 串行队列：不会开启新的线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务
 */
// 俩参数，第一个是名字，第二个是执行的优先级
/**
* 全局并发队列的优先级
* #define DISPATCH_QUEUE_PRIORITY_HIGH 2 // 高
* #define DISPATCH_QUEUE_PRIORITY_DEFAULT 0 // 默认（中）
* #define DISPATCH_QUEUE_PRIORITY_LOW (-2) // 低
* #define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN // 后台
*/

- (void)syncSerial {
    // 1.创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("com.520it.queue", DISPATCH_QUEUE_SERIAL);
    // 2.将任务加入队列
    dispatch_sync(queue, ^{
        NSLog(@"1-----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2-----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3-----%@", [NSThread currentThread]);
    });
}



/**
 * 异步函数 + 串行队列：会开启新的线程，但是任务是串行的，执行完一个任务，再执行下一个任务
 */ - (void)asyncSerial {
     // 1.创建串行队列
     // 两个参数，第一个是名字，第二个是穿行队列
     // DISPATCH_QUEUE_CONCURRENT 并行队列
     // DISPATCH_QUEUE_SERIAL串行队列
     dispatch_queue_t queue = dispatch_queue_create("com.520it.queue", DISPATCH_QUEUE_SERIAL);
     //    默认是穿行队列，所以第二个参数传NULL也行
     //![Uploading Snip20160321_7_826971.png . . .]
     //dispatch_queue_t queue = dispatch_queue_create("com.520it.queue", NULL);
     // 2.将任务加入队列
     dispatch_async(queue, ^{
         NSLog(@"1-----%@", [NSThread currentThread]);
     });
     dispatch_async(queue, ^{
         NSLog(@"2-----%@", [NSThread currentThread]);
     });
     dispatch_async(queue, ^{
         NSLog(@"3-----%@", [NSThread currentThread]);
     });
 
 }


/**
 * 同步函数 + 并发队列：不会开启新的线程
 * 因为还是同步函数，所以你的并发执行并没有什么卵用
 */
- (void)syncConcurrent {
     // 1.获得全局的并发队列
    // 在你程序启动的时候，实际上GCD已经给你创建了几个全局的队列，你拿来用就好了，所以其实可以不用自己创建
    // 俩参数，第一个为线程的优先级，第二个为预留参数，传0就行了
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 2.将任务加入队列
    dispatch_sync(queue, ^{
        NSLog(@"1-----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2-----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3-----%@", [NSThread currentThread]);
    });
    NSLog(@"syncConcurrent--------end");
}



/**
 * 异步函数 + 并发队列：可以同时开启多条线程
 */
- (void)asyncConcurrent {
     // 1.创建一个并发队列
    // label : 相当于队列的名字
    // 俩参数，第一个是线程的名字，第二个是优先级
    //    dispatch_queue_t queue = dispatch_queue_create("com.520it.queue", DISPATCH_QUEUE_CONCURRENT);
    // 1.获得全局的并发队列
    // 在你程序启动的时候，实际上GCD已经给你创建了几个全局的队列，你拿来用就好了，所以其实可以不用自己创建
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 2.将任务加入队列
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<10; i++){
        NSLog(@"1-----%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<10; i++) {
            NSLog(@"2-----%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<10; i++) {
            NSLog(@"3-----%@", [NSThread currentThread]);
        }
    });
    NSLog(@"asyncConcurrent--------end");//    dispatch_release(queue);
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   
    //队列里之间的通信
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *imageUrl = [NSURL URLWithString:@"http://img-arch.pconline.com.cn/images/photoblog/9/9/8/1/9981681/200910/11/1255259355826.jpg"];
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        UIImage *image = [UIImage imageWithData:imageData];
        
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.imageView.image = image;
        });
        
    });
   
}


//
//设置依赖分组关系
//创建队列
//创建group组对象dispatch_group_create()
//讲操作加到组里
//在组里完成所有操作后，通过 dispatch_notify(<#object#>, <#queue#>, <#notification_block#>) 方法执行下一步操作，有三个参数，第一个是哪一组的，第二个是在哪个队列，第三个是要执行的方法block

-(void)asyncGroup {

    //一、创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //二、创建分组
    dispatch_group_t group = dispatch_group_create();
    
    //三、下载图片一
    dispatch_group_async(group, queue, ^{
        //图片1
        NSURL *url = [NSURL  URLWithString:@"http://img.pconline.com.cn/images/photoblog/9/9/8/1/9981681/200910/11/1255259355826.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        image1 = [UIImage imageWithData:data];
        
    });
    
    //四、下载图片二
    dispatch_group_async(group, queue, ^{
        
        //图片2
        NSURL *url2 = [NSURL  URLWithString:@"http://pic38.nipic.com/20140228/5571398_215900721128_2.jpg"];
        NSData *data2 = [NSData dataWithContentsOfURL:url2];
        image2 = [UIImage imageWithData:data2];
    });
    
    //五、合成新的图片
    dispatch_group_notify(group, queue, ^{
        
        //开启新的图形上下文
        UIGraphicsBeginImageContext(CGSizeMake(100, 100));
        
        //绘制图片
        [image1 drawInRect:CGRectMake(0, 0, 50, 100)];
        [image2 drawInRect:CGRectMake(0, 50, 50, 100)];
        
        //去的上下文新的图片
        UIImage  *image = UIGraphicsGetImageFromCurrentImageContext();
        
        //结束上下文图片
        UIGraphicsEndImageContext();
        
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            //显示图片
            self.imageView2.image = image;
        });
        
        
    });
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
