//
//  DatabaseManager.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 09/06/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "DatabaseManager.h"
#import <sqlite3.h>

@interface DatabaseManager ()

@property (nonatomic, strong) NSNumber *regionsDataVersion; // double
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *regionsDB;

@end

@implementation DatabaseManager

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        //self.regionsDataVersion = [[APXLSSystemManager shared] dbCachedVersionNumber];
    }
    
    return self;
}

+ (instancetype)shared
{
    static DatabaseManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DatabaseManager alloc] init];
    });
    
    return sharedInstance;
}


#pragma mark - Class Methods

- (void)createDatabaseWithCompletionHandler:(StorageManagerCompletionHandler)completionHandler
{
    dispatch_queue_t queue = dispatch_queue_create("Create DB", NULL);
    
    dispatch_async(queue, ^{
        
        NSError *error;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        // create DB if it does not already exists
        if (![fileManager fileExistsAtPath:self.databasePath]) {
            
            const char *dbPath = [self.databasePath UTF8String];
            
            if (sqlite3_open(dbPath, &self->_regionsDB) == SQLITE_OK) {
                
                char *errorMsg;
                const char *sql_statement = "CREATE TABLE IF NOT EXISTS REGIONS_TABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT, UUID TEXT, LONGTITUDE REAL, LATITUDE REAL, RADIUS REAL)";
                
                if (sqlite3_exec(self->_regionsDB, sql_statement, NULL, NULL, &errorMsg) != SQLITE_OK) {
                    
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : APXStorageErrorDescriptionExecuteStatement, NSLocalizedFailureReasonErrorKey : [[NSString alloc] initWithCString:errorMsg encoding:NSUTF8StringEncoding]};
                    error = [[NSError alloc] initWithDomain:APXStorageDomainSqlite code:0 userInfo:userInfo];
                }
                
                if (sqlite3_close(self->_regionsDB) != SQLITE_OK) {
                    
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : APXStorageErrorDescriptionCloseDB};
                    error = [[NSError alloc] initWithDomain:APXStorageDomainSqlite code:0 userInfo:userInfo];
                }
                
            } else {
                
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey : APXStorageErrorDescriptionOpenDB};
                error = [[NSError alloc] initWithDomain:APXStorageDomainSqlite code:0 userInfo:userInfo];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (completionHandler) {
                
                completionHandler(error, nil);
            }
        });
    });
}

@end
