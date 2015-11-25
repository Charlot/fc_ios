//
//  MovementListFinishViewController.h
//  Material
//
//  Created by ryan on 11/25/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovementList.h"

@interface MovementListFinishViewController
    : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) NSString *movement_list_id;
@end
