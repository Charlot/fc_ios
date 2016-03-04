//
//  ReceiveTuoViewController.h
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Yun.h"
#import "Tuo.h"

@interface ReceiveTuoViewController : UIViewController
@property(nonatomic,strong)Tuo *tuo;
@property(nonatomic,strong)Yun *yun;
@property(nonatomic,strong)NSArray *tuoArray;
@property(nonatomic)BOOL enableConfirm;
@property(nonatomic)BOOL enableCancel;
@property(nonatomic)BOOL enableBack;
@end
