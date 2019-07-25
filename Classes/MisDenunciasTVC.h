//
//  MisDenunciasTableViewController.h
//  CeroCorrupcionTabasco
//
//  Created by Carlos Hidalgo on 7/3/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Opciones.h"
#import "Singleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface MisDenunciasTVC : UIViewController<UITableViewDataSource, UITableViewDelegate, NSURLSessionTaskDelegate, NSURLSessionDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic) int Key;
@property(nonatomic, retain) NSString *Value;
@property(nonatomic, retain) NSString *Titulo;

@property (nonatomic, strong) NSMutableArray *opciones;
@property (strong, nonatomic) Singleton *Singleton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Indicator;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtom;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnRefresh;

- (IBAction)btnRefresh:(id)sender;

- (void)customSetup;
-(void)getDataOptions:(NSString *)Url;


@end

NS_ASSUME_NONNULL_END
