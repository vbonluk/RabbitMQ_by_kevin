//
//  ViewController.h
//  testRabbitMQ
//
//  Created by gameDeveloper on 14-9-10.
//  Copyright (c) 2014年 gameDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMQPWrapper.h"

@interface ViewController : UIViewController<AMQPConsumerThreadDelegate,UITextViewDelegate>
- (IBAction)sendMethod:(id)sender;
- (IBAction)receiveMethod:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextView *textViewWarning;

@property(strong,nonatomic) AMQPConnection *conn;
@property(strong,nonatomic) AMQPChannel *channel;
@property(strong,nonatomic) AMQPExchange *exchange;
@property(strong,nonatomic) AMQPQueue *queue;
@property(strong,nonatomic) AMQPQueue *queue7779;
@property (weak, nonatomic) IBOutlet UILabel *label;

- (void)amqpConsumerThreadReceivedNewMessage:(AMQPMessage*)theMessage;
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
@end
