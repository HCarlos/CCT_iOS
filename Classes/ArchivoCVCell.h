//
//  ArchivoCVCell.h
//  CeroCorrupcionTabasco
//
//  Created by Carlos Manuel Hidalgo Ruiz on 7/15/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerImagenVC.h"
#import "Singleton.h"

NS_ASSUME_NONNULL_BEGIN

@class ArchivoCVCell;

@protocol ArchivoCVCellDelegate
    -(void)quitarArchivo:(int) idarchivo Archivo:(NSString *)archivo;
@end

@interface ArchivoCVCell : UICollectionViewCell

@property(nonatomic, weak) id <ArchivoCVCellDelegate> delegate;

@property (strong, nonatomic) Singleton *Singleton;
@property (nonatomic) UIImage *Imagen;
@property (weak, nonatomic) IBOutlet UIImageView *esVideo;
@property (weak, nonatomic) IBOutlet UIImageView *esDocument;
@property (weak, nonatomic) IBOutlet UIImageView *esAudio;
@property (nonatomic, strong) NSString *extensionArchivo;

@property (nonatomic, strong) NSString *Archivo;
@property (nonatomic) int IdArchivo;
//- (IBAction)btnImage:(id)sender;
-(IBAction)btnDelete:(id)sender;

- (IBAction)btnOpenFile:(id)sender;


@end

NS_ASSUME_NONNULL_END
