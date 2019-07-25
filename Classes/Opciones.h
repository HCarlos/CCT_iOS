//
//  Opciones.h
//  CeroCorrupcionTabasco
//
//  Created by Carlos Hidalgo on 6/29/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


NS_ASSUME_NONNULL_BEGIN
/*
typedef enum {
    obj_id = 0,
    Descripcion,
} Objeto;
*/

@interface Opciones : NSObject

@property (nonatomic, assign) int Key;
@property (nonatomic, strong) NSString *Value;
@property (nonatomic, strong) NSString *VString1;
@property (nonatomic, strong) NSString *VString2;
@property (nonatomic, strong) NSString *VString3;
@property (nonatomic, strong) NSString *VString4;
@property (nonatomic, strong) NSData *Data;
@property (nonatomic) UIImage *Imagen;

// @property (nonatomic, assign) Objeto opciones;

+(Opciones*)newDataObject:(int)key value:(NSString*)value;
+(Opciones*)newDataObject:(int)key value:(NSString*)value VString1:(NSString *)vstring1 VString2:(NSString *)vstring2;
+(Opciones*)newDataObject:(int)key value:(NSString*)value VString1:(NSString *)vstring1 Data:(NSData *)data;
+(Opciones*)newDataObjectWhitImage:(int)key value:(NSString*)value VString1:(NSString *)vstring1 Imagen:(UIImage *)imagen;
+(Opciones*)newDataObjectMedia:(int)key value:(NSString*)value VString1:(NSString *)vstring1 Imagen:(UIImage *)imagen Data:(NSData *)data;


@end

NS_ASSUME_NONNULL_END
