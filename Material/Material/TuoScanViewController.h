//
//  TuoScanViewController.h
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tuo.h"

@interface TuoScanViewController : UIViewController
@property(nonatomic,strong)Tuo *tuo;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *userID;
@property(nonatomic,strong)NSString *rukuList;
@property(nonatomic)BOOL hideCheckButton;
@property(nonatomic)BOOL enablePop;
@property(nonatomic,strong) NSMutableArray *xiangdetailist;
@end
