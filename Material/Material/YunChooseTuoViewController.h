//
//  YunChooseTuoViewController.h
//  Material
//
//  Created by wayne on 14-6-9.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Yun;

@interface YunChooseTuoViewController : UIViewController
@property(nonatomic,strong)Yun *yun;
@property(nonatomic,strong)Yun *yunTarget;
@property(nonatomic,strong)NSString *type;
@property (strong,nonatomic) NSString *barTitle;
@end
