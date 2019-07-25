//
//  AcercadeViewController.h
//  CeroCorrupcionTabasco
//
//  Created by Carlos Hidalgo on 7/2/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "Singleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface AcercadeViewController : UIViewController<WKUIDelegate, WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtom;
@property (strong, nonatomic) Singleton *Singleton;
@end

NS_ASSUME_NONNULL_END
