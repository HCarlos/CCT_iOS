//
//  Singleton.m
//  New Financial Personal for iPad
//
//  Created by DevCH on 10/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Singleton.h"
#import <CommonCrypto/CommonDigest.h>
#import "Opciones.h"


@implementation Singleton

@synthesize uniqueIdentifier;
@synthesize pathPList, dataPList, IsDelete, noIngresos, IdConcepto;
@synthesize NombreCompletoUsuario, Valor;
@synthesize tokenUser, typeDevice, Version, currentVersion, FCMToken, APNSToken, IdTarget;
@synthesize applicationIconBadgeNumber;
@synthesize urlBase, urlLogin, urlPagos, urlDependencias, urlAvisoPrivacidad;

@synthesize IdTipoGobierno, IdDependencia, IdArea;

static Singleton* _sharedMySingleton = nil;
//extern NSString* CTSettingCopyMyPhoneNumber();

+(Singleton*)sharedMySingleton
{
    
    
	@synchronized([Singleton class])
    {
        if (!_sharedMySingleton)
            _sharedMySingleton = [[self alloc] init];
        
        return _sharedMySingleton;
    }
    
    return nil;
}

+(id)alloc
{
	@synchronized([Singleton class])
	{
		NSAssert(_sharedMySingleton == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedMySingleton = [super alloc];
		return _sharedMySingleton;
	}
	
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
		
        NSString * version = nil;
        version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        if (!version) {
            version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
        }
        
        self.IdTarget = 0;

        self.IdTipoGobierno = 0;
        self.IdDependencia = 0;
        self.IdArea = 0;
        
        self.Version = version;
        self.currentVersion = version;
        self.IdConcepto = 0;
        self.Valor = @"none";
        self.urlBase = @"https://uipeapp01.uipe.tabascoweb.com/";
        self.urlLogin = [NSString stringWithFormat:@"%@%@", self.urlBase, @"getLoginUserMobile/"];
        self.urlPagos = [NSString stringWithFormat:@"%@%@", self.urlBase, @"php/01/mobile/pagos_layout.php?idedocta=%d&user=%@&iduser=%d@&idconcepto=%ld"];
        self.urlAvisoPrivacidad = [NSString stringWithFormat:@"%@%@", self.urlBase, @"getAvisoPrivacidad/"];

        self.urlDependencias = [NSString stringWithFormat:@"%@%@", self.urlBase, @"getDependencias/"];

        
	}
	
	return self;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized([Singleton class]) {
		NSAssert(_sharedMySingleton == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedMySingleton= [super allocWithZone:zone];
		return _sharedMySingleton; // assignment and return on first allocation
	}
	return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (void)dealloc {
}

-(NSString *) getDeviceData:(int )field{
    
    NSString *UUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceID"];
    if (!UUID) {
        NSString *newUUID = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:newUUID forKey:@"deviceID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return UUID;
}

-(NSString *) phoneNumber {
 
    
    NSString *phone = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
    
	if (phone  == NULL){
		phone = @"iOS8";
	}
    NSLog(@"Phone Number: %@", phone);

    return phone;
}


-(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(NSUInteger i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

-(void)setPlist{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    pathPList = [documentsDirectory stringByAppendingPathComponent:@"UserConnect.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: pathPList])
    {
        pathPList = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"UserConnect.plist"] ];
    }else{
    }
    
    fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: pathPList])
    {
        dataPList = [[NSMutableDictionary alloc] initWithContentsOfFile: pathPList];
    }
    else
    {
        dataPList = [[NSMutableDictionary alloc] init];
        [dataPList writeToFile: pathPList atomically:YES];

    }

    BOOL key2Exists = !![dataPList objectForKey:@"badge"];
    
    if (!key2Exists){
        [self incrementBadge];
    }
    
}

-(void)insertUser:(NSString *) User insertPass:(NSString *) PWD{
    ///// INSERTAR ////////
    
    //To insert the data into the plist
    NSString *Usr = User;
    NSString *Pwd = PWD;
    [dataPList setObject:[NSString stringWithString:Usr] forKey:@"username"];
    [dataPList setObject:[NSString stringWithString:Pwd] forKey:@"password"];

    [dataPList writeToFile: pathPList atomically:YES];
    //[data release];
    
}

-(void)deleteUser{

    [dataPList removeObjectForKey:@"username"];
    [dataPList writeToFile:pathPList atomically:YES];

    [dataPList removeObjectForKey:@"password"];
    [dataPList writeToFile:pathPList atomically:YES];
    
}

-(NSString *) getUser{
    
    
    //To reterive the data from the plist
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: pathPList];
    NSString *value1;
    value1 = [savedStock objectForKey:@"username"] ;
    return value1;

}

-(NSString *) getPassword{
    
    
    //To reterive the data from the plist
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: pathPList];
    NSString *value1;
    value1 = [savedStock objectForKey:@"password"] ;
    return value1;
    
}


-(NSInteger) incrementBadge{
    NSInteger valret = [self getBadge] + 1;
    [dataPList setObject:[NSNumber numberWithInteger:valret] forKey:@"badge"];
    [dataPList writeToFile: pathPList atomically:YES];
    return valret;
}

-(NSInteger) decrementBadge{
    NSInteger valret = [self getBadge] - 1;
    [dataPList setObject:[NSNumber numberWithInteger:valret] forKey:@"badge"];
    [dataPList writeToFile: pathPList atomically:YES];
    return valret;
}

-(NSInteger) getBadge{
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: pathPList];
    NSInteger badge = [[savedStock objectForKey:@"badge"] integerValue] ;
    return badge;
    
}

-(void)removeBadge{
    
    [dataPList removeObjectForKey:@"badge"];
    [dataPList writeToFile:pathPList atomically:YES];
    
}


-(NSInteger) addAccess{
    
    NSInteger valret = [self getAccess] + 1;
    [dataPList setObject:[NSNumber numberWithInteger:valret] forKey:@"numero_de_ingresos"];
    [dataPList writeToFile: pathPList atomically:YES];
    self.noIngresos = valret;
    return valret;
    
}

-(NSInteger) getAccess{
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: pathPList];
    NSInteger _noIngresos = [[savedStock objectForKey:@"numero_de_ingresos"] integerValue];
    self.noIngresos = _noIngresos;
    return noIngresos;
    
}

-(BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

-(NSArray*)explodeString:(NSString*)stringToBeExploded WithDelimiter:(NSString*)delimiter
{
    return [stringToBeExploded componentsSeparatedByString: delimiter];
}

-(NSString *)makeUniqueString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyMMddHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    //[dateFormatter release];
    int randomValue = arc4random() % 100000;
    NSString *unique = [NSString stringWithFormat:@"%@h%d",dateString,randomValue];
    return unique;
}

-(int)intInRangeMinimum:(int)min andMaximum:(int)max {
    if (min > max) { return -1; }
    int adjustedMax = (max + 1) - min; // arc4random returns within the set {min, (max - 1)}
    int random = arc4random() % adjustedMax;
    int result = random + min;
    return result;
}
-(double)intInRangeDouble:(double)min andMaximum:(double)max {
    return (double)rand()/RAND_MAX * (max - min) + min;
}

-(void)setTarget:(int)oIdTarget{
    self.IdTarget = oIdTarget;
}
-(int)getIdTarget{
    return self.IdTarget;
}


@end
