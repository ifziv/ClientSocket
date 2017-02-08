//
//  ClientViewController.h
//  ClientSocket
//
//  Created by zivInfo on 16/8/5.
//  Copyright © 2016年 xiwangtech.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCDAsyncUdpSocket.h"

@interface ClientViewController : UIViewController <GCDAsyncUdpSocketDelegate,UITextFieldDelegate>

@property (nonatomic, strong) GCDAsyncUdpSocket *clientSocket;

@property (weak, nonatomic) IBOutlet UITextField *IPTF;
@property (weak, nonatomic) IBOutlet UITextField *portTF;
@property (weak, nonatomic) IBOutlet UITextField *msgTF;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *jtBtn;
@property (weak, nonatomic) IBOutlet UILabel *getMsg;

- (IBAction)sendAction:(id)sender;
- (IBAction)jtAction:(id)sender;

@end
