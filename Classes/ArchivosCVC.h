//
//  ArchivosCVC.h
//  CeroCorrupcionTabasco
//
//  Created by Carlos Manuel Hidalgo Ruiz on 7/15/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Opciones.h"
#import "Singleton.h"
#import "ArchivoCVCell.h"
#import "PreloaderVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArchivosCVC : UICollectionViewController<NSURLSessionDelegate, NSURLSessionTaskDelegate, UIAlertViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, NSURLSessionDataDelegate, UIVideoEditorControllerDelegate,UIDocumentPickerDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, retain) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic, retain) NSURLSession *session;

@property (nonatomic, strong) NSMutableArray *archivos;
@property (strong, nonatomic) Singleton *Singleton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Indicator;
@property(nonatomic, retain) NSString *Titulo;
- (IBAction)btnSubirArchivo:(id)sender;
- (IBAction)btnRefresh:(id)sender;


@property (nonatomic) int TypeMedia;

@property (nonatomic) int IdDenuncia;
@property (nonatomic) int IdArchivo;

@property (nonatomic) UIImage *imgArchivo;


-(void)getDataOptions:(NSString *)Url;


@end

NS_ASSUME_NONNULL_END
