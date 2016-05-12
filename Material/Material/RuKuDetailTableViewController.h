//
//  RuKuDetailTableViewController.h
//  Material
//
//  Created by wayne on 16/5/12.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tuo.h"

@interface RuKuDetailTableViewController : UIViewController
@property(nonatomic,strong)NSString *listID;
@property(nonatomic,strong)Tuo *tuo;
@property(nonatomic,strong)NSString *rukuList;
@property(nonatomic,strong)NSString *userID;
@property(nonatomic,strong) NSMutableArray *xiangdetailist;
@end
