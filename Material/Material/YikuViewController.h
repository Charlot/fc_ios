//
//  YikuViewController.h
//  Material
//
//  Created by exmooncake on 15-6-18.
//  Copyright (c) 2015年 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Captuvo.h"
#import "AFNetOperate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ShiftingDetailViewController.h"

/**
 *  移库vc
 */
@interface YikuViewController
    : UIViewController <CaptuvoEventsProtocol, UITextFieldDelegate,
                        UIAlertViewDelegate,
                        ShiftingDetailViewControllerDelegate>
@property NSString *movementListID;
@end
