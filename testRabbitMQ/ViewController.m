//
//  ViewController.m
//  testRabbitMQ
//
//  Created by gameDeveloper on 14-9-10.
//  Copyright (c) 2014年 gameDeveloper. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.delegate =self;
    self.textViewWarning.delegate = self;
    
    dispatch_queue_t queue = dispatch_queue_create("test22", NULL);
    //异步async是在新线程下执行而不是主线程。
    dispatch_async(queue, ^{
        //    ----------****如果服务器关闭会crash掉****----------
        
        //连接
        _conn = [[AMQPConnection alloc]init];
        [_conn connectToHost:@"zerogame.wicp.net" onPort:5672];
        [_conn loginAsUser:@"zerogame" withPasswort:@"zerogame2014" onVHost:@"zerogame"];
        
        //设置频道
        _channel =[_conn openChannel];
        
        //设置交换机
        _exchange = [[AMQPExchange alloc]initFanoutExchangeWithName:@"exchange1234" onChannel:_channel isPassive:false isDurable:true getsAutoDeleted:false];
        
        //设置队列
        _queue = [[AMQPQueue alloc] initWithName:@"7778" onChannel:_channel isPassive:false isExclusive:false isDurable:true getsAutoDeleted:false];
        [_queue bindToExchange:_exchange withKey:@"fanout"];
        
        //设置队列,用于测试多队列消息接收
        //    _queue7779 = [[AMQPQueue alloc] initWithName:@"7779" onChannel:_channel isPassive:false isExclusive:false isDurable:true getsAutoDeleted:false];
        //    [_queue7779 bindToExchange:_exchange withKey:@"fanout"];
    });
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMethod:(id)sender {

    dispatch_queue_t queue = dispatch_queue_create("test22", NULL);
    //异步async是在新线程下执行而不是主线程。
    dispatch_async(queue, ^{
        [_exchange publishMessage:self.textView.text usingRoutingKey:@"fanout"];
        //    [exchange publishPicture:@"QQ20140911-1" WithType:@"png" usingRoutingKey:@"fanout"];
        });
}

- (IBAction)receiveMethod:(id)sender {
    
    
    dispatch_queue_t queue = dispatch_queue_create("test", NULL);
    //异步async是在新线程下执行而不是主线程。
    dispatch_async(queue, ^{
        
        //创建消费者
        AMQPConsumer *consumer = [[AMQPConsumer alloc]initForQueue:_queue onChannel:_channel useAcknowledgements:true isExclusive:false receiveLocalMessages:YES];
        
        //通过上面的消费者创建消费者线程？
        AMQPConsumerThread *consumerThread = [[AMQPConsumerThread alloc] initWithConsumer:consumer];
        
        consumerThread.delegate = self;
        
        //启动main方法来接收消息。注意：此方法并没有开启多线程，只是把消费者接收消息放到自动释放池，所以上面的创建消费者线程？我并不知道为何要命名为AMQPConsumerThread。
        [consumerThread main];
    });
}



#pragma mark - consumerThreadDelegate
//接收消息后调用的方法
- (void)amqpConsumerThreadReceivedNewMessage:(AMQPMessage*)theMessage
{
    
    NSLog(@"%@",theMessage.body);
    
    self.label.text = theMessage.body;
    
    NSLog(@"%d",theMessage.deliveryTag);
}

#pragma mark - UITextView Delegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]||textView.tag == 10086) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
