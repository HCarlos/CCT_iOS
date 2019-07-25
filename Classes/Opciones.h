//
//  Opciones.h
//  CeroCorrupcionTabasco
//
//  Created by Carlos Hidalgo on 6/29/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import <Foundation/Foundation.h>

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

// @property (nonatomic, assign) Objeto opciones;

+(Opciones*)newDataObject:(int)key value:(NSString*)value;

@end

NS_ASSUME_NONNULL_END
