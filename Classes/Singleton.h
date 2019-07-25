//
//  Singleton.h
//  New Financial Personal for iPad
//
//  Created by DevCH on 10/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Opciones.h"

@interface Singleton : NSObject{
    NSString *pathPList;
    NSMutableDictionary *dataPList;
	BOOL IsDelete;
    NSString *NombreCompletoUsuario;
    NSString *Version;
    
}



@property (nonatomic, retain) NSString *NombreCompletoUsuario;
@property (nonatomic, retain) NSString *Version;
@property (nonatomic, retain) NSString *currentVersion;
// URL's
@property (nonatomic, retain) NSString *urlBase;
@property (nonatomic, retain) NSString *urlLogin;
@property (nonatomic, retain) NSString *urlPagos;
@property (nonatomic, retain) NSString *urlDependencias;
@property (nonatomic, retain) NSString *urlAvisoPrivacidad;

@property (nonatomic) NSInteger applicationIconBadgeNumber;
@property (nonatomic) NSInteger noIngresos;
@property (nonatomic) NSInteger IdConcepto;
@property (nonatomic) int IdTarget;
@property (nonatomic, retain) NSString* Valor;

@property (nonatomic, retain) Opciones *objSingleData;

@property (nonatomic) BOOL IsDelete;

@property(nonatomic, retain) NSString    *typeDevice;  // a string unique to each device based on various
@property(nonatomic, retain) NSString    *uniqueIdentifier;  // a string unique to each device based on various
@property(nonatomic, retain) NSUUID *identifierForVendor;

@property(nonatomic,retain) NSString *tokenUser;              // e.g. "My iPhone"
@property(nonatomic,retain) NSString *FCMToken;
@property(nonatomic,retain) NSString *APNSToken;
@property(nonatomic,retain) NSMutableDictionary *dataPList;
@property(nonatomic,retain) NSString *pathPList;


@property (nonatomic) int IdTipoGobierno;
@property (nonatomic) int IdDependencia;
@property (nonatomic) int IdArea;


+(Singleton*)sharedMySingleton;

- (BOOL) validateEmail: (NSString *) candidate;

-(NSString *) getDeviceData:(int )field;

-(NSString*) sha1:(NSString*)input;
-(NSString *)makeUniqueString;

-(int)intInRangeMinimum:(int)min andMaximum:(int)max;
-(double)intInRangeDouble:(double)min andMaximum:(double)max;

-(void)setPlist;
-(void)insertUser:(NSString *) User insertPass:(NSString *) PWD;
-(void)deleteUser;

-(NSString *) getUser;
-(NSString *) getPassword;
-(NSArray*)explodeString:(NSString*)stringToBeExploded WithDelimiter:(NSString*)delimiter;

-(NSInteger) addAccess;
-(NSInteger) getAccess;

-(NSInteger) getBadge;
-(NSInteger) incrementBadge;
-(NSInteger) decrementBadge;

-(void)setTarget:(int)oIdTarget;
-(int)getIdTarget;



-(void) removeBadge;



@end
