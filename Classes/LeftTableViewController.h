//
//  LeftTableViewController.h
//  CeroCorrupcionTabasco
//
//  Created by Carlos Hidalgo on 6/28/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface SWUITableViewCell : UITableViewCell
@property (nonatomic) IBOutlet UILabel *label;
@end

@interface LeftTableViewController : UITableViewController

@property (strong,nonatomic) Singleton *Singleton;

@property (nonatomic, strong) NSMutableArray *opciones;

@end

NS_ASSUME_NONNULL_END
