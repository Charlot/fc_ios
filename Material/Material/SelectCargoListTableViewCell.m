//
//  SelectCargoListTableViewCell.m
//  Material
//
//  Created by wayne on 17/2/10.
//  Copyright © 2017年 brilliantech. All rights reserved.
//

#import "SelectCargoListTableViewCell.h"

@implementation SelectCargoListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.CargoListNameLabel.adjustsFontSizeToFitWidth = YES;
    self.WhouseIDLabel.adjustsFontSizeToFitWidth = YES;
    self.StateLabel.adjustsFontSizeToFitWidth = YES;
    self.RemarkLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
