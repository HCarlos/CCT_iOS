//
//  MiDenunciaVC.h
//  CeroCorrupcionTabasco
//
//  Created by Carlos Manuel Hidalgo Ruiz on 7/13/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Opciones.h"
#import "Singleton.h"
#import "MisDenunciasTVCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MiDenunciaVC : UIViewController<UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate, NSURLSessionTaskDelegate, UIAlertViewDelegate>


@property (nonatomic, strong) NSMutableArray *opciones;
@property (strong, nonatomic) Singleton *Singleton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Indicator;
@property(nonatomic, retain) NSString *Titulo;

@property (nonatomic) int IdDenuncia;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


-(void)getDataOptions:(NSString *)Url;

@end

NS_ASSUME_NONNULL_END
