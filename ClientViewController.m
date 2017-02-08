//
//  ClientViewController.m
//  ClientSocket
//
//  Created by zivInfo on 16/8/5.
//  Copyright © 2016年 xiwangtech.com. All rights reserved.
//

#import "ClientViewController.h"

@interface ClientViewController ()
{
    int tag;
    NSString *ipStr;
    NSString *portStr;
    NSString *msgStr;
}

@end

@implementation ClientViewController

@synthesize clientSocket;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tag = 0;
    clientSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self initView];

}

- (void)initView
{
    self.IPTF.tag = 100001;
    self.IPTF.placeholder = @"请输入IP地址..";
    self.IPTF.returnKeyType = UIReturnKeyDone;
    self.IPTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.portTF.tag = 100002;
    self.portTF.placeholder= @"请输入端口号..";
    self.portTF.returnKeyType = UIReturnKeyDone;
    self.portTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.msgTF.tag = 100003;
    self.msgTF.placeholder = @"请输入要发送的消息..";
    self.msgTF.returnKeyType = UIReturnKeyDone;
    self.msgTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.jtBtn.layer.masksToBounds = YES;
    self.jtBtn.layer.cornerRadius = 4.0;
    self.jtBtn.layer.borderWidth = 1.0;
    self.jtBtn.layer.borderColor = [UIColor colorWithRed:73.0/255.0 green:189.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    
    self.sendBtn.layer.masksToBounds = YES;
    self.sendBtn.layer.cornerRadius = 4.0;
    self.sendBtn.layer.borderWidth = 1.0;
    self.sendBtn.layer.borderColor = [UIColor colorWithRed:73.0/255.0 green:189.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
}

- (IBAction)sendAction:(id)sender
{
    NSString *msg = msgStr;
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [clientSocket sendData:data toHost:ipStr port:[portStr intValue] withTimeout:-1 tag:tag];
    tag ++;
}

- (IBAction)jtAction:(id)sender
{
    if (clientSocket == nil)
    {
        [self setupSocket];
    }
}

- (void)setupSocket
{
    // Setup our socket.
    // The socket will invoke our delegate methods using the usual delegate paradigm.
    // However, it will invoke the delegate methods on a specified GCD delegate dispatch queue.
    //
    // Now we can configure the delegate dispatch queues however we want.
    // We could simply use the main dispatc queue, so the delegate methods are invoked on the main thread.
    // Or we could use a dedicated dispatch queue, which could be helpful if we were doing a lot of processing.
    //
    // The best approach for your application will depend upon convenience, requirements and performance.
    //
    // For this simple example, we're just going to use the main thread.
    
    NSError *error = nil;
    
    if (![clientSocket bindToPort:0 error:&error])
    {
        NSLog(@"Error binding: %@", error);
        return;
    }
    if (![clientSocket beginReceiving:&error])
    {
        NSLog(@"Error receiving: %@", error);
        return;
    }
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    // You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    // You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg) {
        NSLog(@"RECV: %@", msg);
        self.getMsg.text = msg;
    }
    else {
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
        
        NSLog(@"RECV: Unknown message from: %@:%hu", host, port);
    }
}

#pragma mark -
#pragma mark -
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 100001)
        ipStr = textField.text;
    else if (textField.tag == 100002)
        portStr = textField.text;
    else if (textField.tag == 100003)
        msgStr = textField.text;
}

//按下Done按钮的调用方法，我们让键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
