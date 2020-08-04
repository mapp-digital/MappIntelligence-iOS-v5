//
//  DatabaseManager.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 09/06/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "DatabaseManager.h"
#import "RequestData.h"
#import <sqlite3.h>

#define DB_PATH @"/MappIntelligence/DB/mappIntelligenceRequestsDB.db"
#define DB_DIR_PATH @"/MappIntelligence/DB"

NSString *const StorageDomainSqlite = @"MAPP_SQLiteDomain";
NSString *const StorageErrorDescriptionOpenDB = @"Failed to open DB";
NSString *const StorageErrorDescriptionCloseDB = @"Failed to close DB";
NSString *const StorageErrorDescriptionExecuteStatement =
    @"Failed to execute SQL statement";
NSString *const StorageErrorDescriptionCreateFunction =
    @"Failed creating SQL function";
NSString *const StorageErrorDescriptionPrepareDB = @"Failed preparing DB";
NSString *const StorageErrorDescriptionInsertionBulk =
    @"Failed while inserting bulks";
NSString *const StorageErrorDescriptionGeneralError = @"General Error";

@interface DatabaseManager ()

@property(nonatomic, strong) NSNumber *regionsDataVersion; // double
@property(strong, nonatomic) NSString *databasePath;
@property(strong, nonatomic) NSString *dbFolderDirectoryPath;
@property(nonatomic) sqlite3 *requestsDB;
@property dispatch_queue_t executionQueue;

@end

@implementation DatabaseManager

#pragma mark - Initialization

- (instancetype)init {
  self = [super init];

  if (self) {

    _executionQueue = dispatch_queue_create("I/O operations DB", NULL);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirecotry = YES;
    // we will also create the 'DB' directory now.
    if (![fileManager fileExistsAtPath:self.dbFolderDirectoryPath
                           isDirectory:&isDirecotry]) {

      NSError *error;
      [fileManager createDirectoryAtPath:self.dbFolderDirectoryPath
             withIntermediateDirectories:YES
                              attributes:nil
                                   error:&error];
      NSLog(@"%@", error);
    }
    [self createDatabaseWithCompletionHandler:^(NSError *_Nonnull error,
                                                id _Nullable data) {
      if (error) {
        NSLog(@"%@", error);
      }
    }];
  }

  return self;
}

- (void)dealloc
{
    sqlite3_close(_requestsDB);
}

+ (instancetype)shared {
  static DatabaseManager *sharedInstance = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[DatabaseManager alloc] init];
  });

  return sharedInstance;
}

#pragma mark - Class Methods

- (void)createDatabaseWithCompletionHandler:
    (StorageManagerCompletionHandler)completionHandler {

  dispatch_sync(_executionQueue, ^{

    NSError *error;

    NSFileManager *fileManager = [NSFileManager defaultManager];

    // create DB if it does not already exists
    if (![fileManager fileExistsAtPath:self.databasePath]) {

      const char *dbPath = [self.databasePath UTF8String];
      int rc = sqlite3_open(dbPath, &self->_requestsDB);
      if (rc == SQLITE_OK) {

        char *errorMsg;
        const char *sql_statement_parameters =
            "CREATE TABLE IF NOT EXISTS PARAMETERS_TABLE (ID INTEGER PRIMARY "
            "KEY AUTOINCREMENT, NAME TEXT, VALUE TEXT, REQUEST_TABLE_ID "
            "INTEGER, FOREIGN KEY (REQUEST_TABLE_ID) REFERENCES REQUESTS_TABLE "
            "(ID))";
        const char *sql_statement =
            "CREATE TABLE IF NOT EXISTS REQUESTS_TABLE (ID INTEGER PRIMARY KEY "
            "AUTOINCREMENT, DOMAIN TEXT, IDS TEXT, STATUS UINT, DATE TEXT)";

        if (sqlite3_exec(self->_requestsDB, sql_statement, NULL, NULL,
                         &errorMsg) != SQLITE_OK) {

          NSDictionary *userInfo = @{
            NSLocalizedDescriptionKey : StorageErrorDescriptionExecuteStatement,
            NSLocalizedFailureReasonErrorKey :
                [[NSString alloc] initWithCString:errorMsg
                                         encoding:NSUTF8StringEncoding]
          };
          error = [[NSError alloc] initWithDomain:StorageDomainSqlite
                                             code:0
                                         userInfo:userInfo];
        }
          NSLog(@"Create Database with status: %d", sqlite3_exec(self->_requestsDB, sql_statement_parameters, NULL,
                                                                 NULL, &errorMsg));
        if (sqlite3_exec(self->_requestsDB, sql_statement_parameters, NULL,
                         NULL, &errorMsg) != SQLITE_OK) {

          NSDictionary *userInfo = @{
            NSLocalizedDescriptionKey : StorageErrorDescriptionExecuteStatement,
            NSLocalizedFailureReasonErrorKey :
                [[NSString alloc] initWithCString:errorMsg
                                         encoding:NSUTF8StringEncoding]
          };
          error = [[NSError alloc] initWithDomain:StorageDomainSqlite
                                             code:0
                                         userInfo:userInfo];
        }

      } else {

        NSDictionary *userInfo =
            @{NSLocalizedDescriptionKey : StorageErrorDescriptionOpenDB};
        error = [[NSError alloc] initWithDomain:StorageDomainSqlite
                                           code:0
                                       userInfo:userInfo];
      }
    }

    dispatch_async(dispatch_get_main_queue(), ^{

      if (completionHandler) {
          const char *dbPath = [self.databasePath UTF8String];
          NSLog(@"open database with: %d and requestDB: %d", sqlite3_open(dbPath, &self->_requestsDB), self->_requestsDB == NULL);
          if (sqlite3_open(dbPath, &self->_requestsDB) != SQLITE_OK) {
              NSLog(@"Failed to open database!");
          }

        completionHandler(error, nil);
      }
    });
  });
}

- (void)deleteDataBaseWithCompletionHandler:
    (StorageManagerCompletionHandler)completionHandler {
  dispatch_queue_t queue = dispatch_queue_create("Remove DB", NULL);

  dispatch_async(queue, ^{

    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error;

    if ([fileManager fileExistsAtPath:self.databasePath]) {
      [fileManager removeItemAtPath:self.databasePath error:&error];
    }

    dispatch_async(dispatch_get_main_queue(), ^{

      if (completionHandler) {

        completionHandler(error, nil);
      }
    });
  });
}

- (BOOL)deleteAllRequest {
  BOOL success = YES;
    
dispatch_async(_executionQueue, ^{
  sqlite3_stmt *sql_statement;
  const char *dbPath = [self.databasePath UTF8String];

    if (sqlite3_open_v2(dbPath, &self->_requestsDB,
                      SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE |
                          SQLITE_OPEN_SHAREDCACHE,
                      NULL) == SQLITE_OK) {

    NSString *insertSQL =
        [NSString stringWithFormat:@"DELETE FROM REQUESTS_TABLE"];

    const char *insertStatement = [insertSQL UTF8String];

      sqlite3_prepare_v2(self->_requestsDB, insertStatement, -1, &sql_statement, NULL);


    if (sqlite3_step(sql_statement) != SQLITE_DONE) {

      //success = NO;
    }
      sqlite3_exec(self->_requestsDB, "BEGIN TRANSACTION", NULL, NULL, NULL);
    sqlite3_finalize(sql_statement);

    // remove also paramters from parameters table
    insertSQL = [NSString
        stringWithFormat:
            @"DELETE FROM PARAMETERS_TABLE"];

    insertStatement = [insertSQL UTF8String];

      sqlite3_prepare_v2(self->_requestsDB, insertStatement, -1, &sql_statement, NULL);

    if (sqlite3_step(sql_statement) != SQLITE_DONE) {

      //success = NO;
    }
      sqlite3_exec(self->_requestsDB, "END TRANSACTION", NULL, NULL, NULL);
    sqlite3_finalize(sql_statement);

  } else {

    //success = NO;
  }
});
  return success;
}

- (BOOL)deleteRequest:(int)ID {
  BOOL success = YES;
dispatch_async(_executionQueue, ^{
  sqlite3_stmt *sql_statement;
  const char *dbPath = [self.databasePath UTF8String];

    if (sqlite3_open_v2(dbPath, &self->_requestsDB,
                      SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE |
                          SQLITE_OPEN_SHAREDCACHE,
                      NULL) == SQLITE_OK) {

    NSString *insertSQL =
        [NSString stringWithFormat:@"DELETE FROM REQUESTS_TABLE WHERE ID = ?"];

    const char *insertStatement = [insertSQL UTF8String];

        sqlite3_prepare_v2(self->_requestsDB, insertStatement, -1, &sql_statement, NULL);

    sqlite3_bind_int(sql_statement, 1, ID);

    if (sqlite3_step(sql_statement) != SQLITE_DONE) {

      //success = NO;
    }
        sqlite3_exec(self->_requestsDB, "BEGIN TRANSACTION", NULL, NULL, NULL);
    sqlite3_finalize(sql_statement);

    // remove also paramters from parameters table
    insertSQL = [NSString
        stringWithFormat:
            @"DELETE FROM PARAMETERS_TABLE WHERE REQUEST_TABLE_ID = ?"];

    insertStatement = [insertSQL UTF8String];

        sqlite3_prepare_v2(self->_requestsDB, insertStatement, -1, &sql_statement, NULL);

    sqlite3_bind_int(sql_statement, 1, ID);

    if (sqlite3_step(sql_statement) != SQLITE_DONE) {

      //success = NO;
    }
        sqlite3_exec(self->_requestsDB, "END TRANSACTION", NULL, NULL, NULL);
    sqlite3_finalize(sql_statement);

    //sqlite3_close(_requestsDB);

  } else {

    //success = NO;
  }
});
  return success;
}

-(BOOL)updateStatusOfRequestWithId: (int) identifier andStatus: (int) status {
    BOOL success = YES;
    dispatch_async(_executionQueue, ^{
    sqlite3_stmt *sql_statement;
    const char *dbPath = [self.databasePath UTF8String];

        if (sqlite3_open_v2(dbPath, &self->_requestsDB,
                        SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE |
                            SQLITE_OPEN_SHAREDCACHE,
                        NULL) == SQLITE_OK) {

      NSString *insertSQL =
          [NSString stringWithFormat:@"UPDATE REQUESTS_TABLE SET STATUS = ? WHERE REQUESTS_TABLE.ID = ?"];

      const char *insertStatement = [insertSQL UTF8String];

        sqlite3_prepare_v2(self->_requestsDB, insertStatement, -1, &sql_statement, NULL);

      sqlite3_bind_int(sql_statement, 1, status);
      sqlite3_bind_int(sql_statement, 2, identifier);

      if (sqlite3_step(sql_statement) != SQLITE_DONE) {

        //success = NO;
      }
        sqlite3_exec(self->_requestsDB, "BEGIN TRANSACTION", NULL, NULL, NULL);
      sqlite3_finalize(sql_statement);
    }
    //sqlite3_close(_requestsDB);
    });
    return success;
}

- (BOOL)deleteTooOldRequests {
  BOOL success = YES;

    dispatch_async(_executionQueue, ^{
    
  sqlite3_stmt *sql_statement;
  const char *dbPath = [self.databasePath UTF8String];

        if (sqlite3_open(dbPath, &self->_requestsDB) == SQLITE_OK) {

    NSString *insertSQL = [NSString
        stringWithFormat:@"SELECT ROWID FROM REQUESTS_TABLE ORDER BY id ASC "
                         @"LIMIT CASE WHEN (SELECT COUNT(*) FROM "
                         @"REQUESTS_TABLE) > 100000 THEN (SELECT COUNT(*) "
                         @"FROM REQUESTS_TABLE) - 100000 ELSE 0 END"];

    const char *insertStatement = [insertSQL UTF8String];

            sqlite3_prepare_v2(self->_requestsDB, insertStatement, -1, &sql_statement, NULL);

    NSMutableArray *requestIds = [[NSMutableArray alloc] init];

    while (sqlite3_step(sql_statement) == SQLITE_ROW) {

      int uniqueId = sqlite3_column_double(sql_statement, 0);
      [requestIds insertObject:@(uniqueId) atIndex:0];
    }
    if ([requestIds count] != 0) {
      insertSQL = [NSString
          stringWithFormat:@"DELETE FROM REQUESTS_TABLE WHERE ID IN (%@)",
                           [requestIds componentsJoinedByString:@","]];

      insertStatement = [insertSQL UTF8String];

        sqlite3_prepare_v2(self->_requestsDB, insertStatement, -1, &sql_statement,
                         NULL);
      if (sqlite3_step(sql_statement) != SQLITE_OK) {
       // success = NO;
      }

      insertSQL = [NSString
          stringWithFormat:@"DELETE FROM PARAMETERS_TABLE WHERE "
                           @"REQUEST_TABLE_ID IN (%@)",
                           [requestIds componentsJoinedByString:@","]];

      insertStatement = [insertSQL UTF8String];
        sqlite3_prepare_v2(self->_requestsDB, insertStatement, -1, &sql_statement,
                         NULL);
      if (sqlite3_step(sql_statement) != SQLITE_OK) {
       // success = NO;
      }
    }
            sqlite3_exec(self->_requestsDB, "END TRANSACTION", NULL, NULL, NULL);
    sqlite3_finalize(sql_statement);

    //sqlite3_close(_requestsDB);

  } else {

   // success = NO;
  }
    });
  return success;
}

- (BOOL)insertRequest:(Request *)request {
  BOOL success = YES;

  if (request) {
      dispatch_async(_executionQueue, ^{

    sqlite3_stmt *sql_statement;
      const char *dbPath = [self.databasePath UTF8String];
          NSLog(@"DB: %d", self->_requestsDB == nil);
          if (sqlite3_open(dbPath, &self->_requestsDB) == SQLITE_OK) {

      NSString *insertSQL =
          [NSString stringWithFormat:@"INSERT INTO REQUESTS_TABLE (DOMAIN, "
                                     @"IDS, STATUS, DATE) VALUES(?, ?, ?, ?)"];

      const char *insertStatement = [insertSQL UTF8String];

              sqlite3_prepare_v2(self->_requestsDB, insertStatement, -1, &sql_statement,
                         NULL);

      sqlite3_bind_text(sql_statement, 1, [request.domain UTF8String], -1,
                        SQLITE_TRANSIENT);
      sqlite3_bind_text(sql_statement, 2, [request.track_ids UTF8String], -1,
                        SQLITE_TRANSIENT);
      sqlite3_bind_int(sql_statement, 3, [request.status intValue]);
      time_t rawtime;
      struct tm *currentTime;
      time(&rawtime);
      currentTime = localtime(&rawtime);

      const int TIME_STRING_LENGTH = 20;
      char buffer[TIME_STRING_LENGTH];

      // SQLite expected date string format is "YYYY-MM-DD HH:MM:SS" (there are
      // others too)
      strftime(buffer, TIME_STRING_LENGTH, "%Y-%m-%d %H:%M:%S", currentTime);
      sqlite3_bind_text(sql_statement, 4, buffer, -1, SQLITE_TRANSIENT);

      if (sqlite3_step(sql_statement) != SQLITE_DONE) {

        //success = NO;
      }

        long long lastRowID = sqlite3_last_insert_rowid(self->_requestsDB);

      // TODO: add parameters to database
      for (Parameter *parameter in request.parameters) {
        parameter.request_uniqueId =
            [[NSNumber alloc] initWithLongLong:lastRowID];
        [self insertParameter:parameter];
      }
        //TODO:check do we need it
      //[self deleteTooOldRequests];
        sqlite3_exec(self->_requestsDB, "END TRANSACTION", NULL, NULL, NULL);
      sqlite3_finalize(sql_statement);
        //sqlite3_close(self->_requestsDB);

    } else {

      //success = NO;
    }
      });
  }

  return success;
}

- (BOOL)insertParameter:(Parameter *)parameter {
  BOOL success = YES;

  if (parameter) {

    sqlite3_stmt *sql_statement;
    const char *dbPath = [self.databasePath UTF8String];

    if (sqlite3_open(dbPath, &_requestsDB) == SQLITE_OK) {

      NSString *insertSQL = [NSString
          stringWithFormat:@"INSERT INTO PARAMETERS_TABLE (name, VALUE, "
                           @"REQUEST_TABLE_ID) VALUES(?, ?, ?) "];

      const char *insertStatement = [insertSQL UTF8String];

      sqlite3_prepare_v2(_requestsDB, insertStatement, -1, &sql_statement,
                         NULL);

      sqlite3_bind_text(sql_statement, 1, [parameter.name UTF8String], -1,
                        SQLITE_TRANSIENT);
      sqlite3_bind_text(sql_statement, 2, [parameter.value UTF8String], -1,
                        SQLITE_TRANSIENT);
      sqlite3_bind_int(sql_statement, 3, [parameter.request_uniqueId intValue]);

      if (sqlite3_step(sql_statement) != SQLITE_DONE) {

        success = NO;
      }

      if (sqlite3_reset(sql_statement) != SQLITE_OK) {
        return NO;
      }

    } else {

      success = NO;
    }
  }

  return success;
}

- (NSError *)insertRequests:(NSArray *)requests {
  NSError *error;
  char *cError;
  const char *dbPath = [self.databasePath UTF8String];
  sqlite3_stmt *sql_statement;

  if (sqlite3_open(dbPath, &_requestsDB) == SQLITE_OK) {

    sqlite3_exec(_requestsDB, "BEGIN TRANSACTION", NULL, NULL, &cError);

    NSString *statement =
        [NSString stringWithFormat:@"INSERT INTO REQUESTS_TABLE (DOMAIN, IDS, "
                                   @"STATUS) VALUES(?, ?, ?)"];

    if (sqlite3_prepare_v2(_requestsDB, [statement UTF8String], -1,
                           &sql_statement, NULL) == SQLITE_OK) {

      for (Request *request in requests) {

        sqlite3_bind_text(sql_statement, 1, [request.domain UTF8String], -1,
                          SQLITE_TRANSIENT);
        sqlite3_bind_text(sql_statement, 2, [request.track_ids UTF8String], -1,
                          SQLITE_TRANSIENT);
        sqlite3_bind_int(sql_statement, 3, [request.status intValue]);

        if (sqlite3_step(sql_statement) == SQLITE_DONE) {

          long long lastRowID = sqlite3_last_insert_rowid(_requestsDB);

          // TODO: add parameters to database
          for (Parameter *parameter in request.parameters) {
            parameter.request_uniqueId =
                [[NSNumber alloc] initWithLongLong:lastRowID];
            [self insertParameter:parameter];
          }

          if (sqlite3_reset(sql_statement) != SQLITE_OK) {

            NSDictionary *userInfo = @{
              NSLocalizedDescriptionKey : StorageErrorDescriptionInsertionBulk
            };
            error = [[NSError alloc] initWithDomain:StorageDomainSqlite
                                               code:0
                                           userInfo:userInfo];
            break;
          }
        }
      }
      [self deleteTooOldRequests];
    }

    sqlite3_exec(_requestsDB, "END TRANSACTION", NULL, NULL, &cError);

    if (sqlite3_finalize(sql_statement) == SQLITE_OK) {
    }
  }

  return error;
}

- (void)fetchAllRequestsFromInterval:(double)interval andWithCompletionHandler:
    (StorageManagerCompletionHandler)completionHandler {
  //dispatch_queue_t queue = dispatch_queue_create("Fetch Resulats", NULL);
//TODO: select count of request and make logic around it
  dispatch_async(_executionQueue, ^{

    NSMutableArray *requests = nil;
    NSMutableArray *requestIds = nil;

    const char *dbPath = [self.databasePath UTF8String];

    NSError *error;

    if (sqlite3_open(dbPath, &self->_requestsDB) == SQLITE_OK) {

      NSString *querySQL = [[NSString alloc]
          initWithFormat:
              @"SELECT rowid, * FROM REQUESTS_TABLE "
                            @" ORDER BY ID LIMIT %i;", (int)interval];
      sqlite3_stmt *sql_statement;

      const char *query_stmt = [querySQL UTF8String];

      if (sqlite3_prepare_v2(self->_requestsDB, query_stmt, -1, &sql_statement,
                             NULL) == SQLITE_OK) {

        requests = [[NSMutableArray alloc] init];
        requestIds = [[NSMutableArray alloc] init];

        while (sqlite3_step(sql_statement) == SQLITE_ROW) {

          int uniqueId = sqlite3_column_double(sql_statement, 1);
          NSString *domain = [[NSString alloc]
              initWithUTF8String:(const char *)sqlite3_column_text(
                                     sql_statement, 2)];
          NSString *ids = [[NSString alloc]
              initWithUTF8String:(const char *)sqlite3_column_text(
                                     sql_statement, 3)];
          int status = sqlite3_column_double(sql_statement, 4);
          NSString *date = [[NSString alloc]
              initWithUTF8String:(const char *)sqlite3_column_text(
                                     sql_statement, 5)];

          NSDictionary *keyedValues = @{
            @"id" : @(uniqueId),
            @"track_domain" : domain,
            @"track_ids" : ids,
            @"status" : @(status),
            @"date" : date
          };
          Request *request = [[Request alloc] initWithKeyedValues:keyedValues];
          [requestIds insertObject:@(uniqueId) atIndex:0];
          [requests insertObject:request atIndex:0];
        }

      } else {

        NSDictionary *userInfo =
            @{NSLocalizedDescriptionKey : StorageErrorDescriptionPrepareDB};
        error = [[NSError alloc] initWithDomain:StorageDomainSqlite
                                           code:0
                                       userInfo:userInfo];
      }

    } else {

      NSDictionary *userInfo =
          @{NSLocalizedDescriptionKey : StorageErrorDescriptionOpenDB};
      error = [[NSError alloc] initWithDomain:StorageDomainSqlite
                                         code:0
                                     userInfo:userInfo];
    }

    dispatch_async(dispatch_get_main_queue(), ^{

      if (completionHandler) {

        NSArray *reveresedRequests =
            [[requests reverseObjectEnumerator] allObjects];

        [self fetchAllParametersForRequestID:requestIds
                      andCompletitionHandler:^(NSError *_Nonnull error,
                                               id _Nullable data) {
                        NSMutableArray<Parameter *> *parameters =
                            (NSMutableArray<Parameter *> *)data;
                        for (Request *request in reveresedRequests) {
                          NSPredicate *predicate =
                              [NSPredicate predicateWithBlock:^BOOL(
                                               id _Nullable evaluatedObject,
                                               NSDictionary<NSString *, id>
                                                   *_Nullable bindings) {
                                Parameter *paramater =
                                    (Parameter *)evaluatedObject;
                                return (paramater.request_uniqueId ==
                                        request.uniqueId);
                              }];
                          request.parameters =
                              (NSMutableArray<Parameter *> *)[parameters
                                  filteredArrayUsingPredicate:predicate];
                        }
                        RequestData *requestData = [[RequestData alloc]
                            initWithRequests:reveresedRequests];
                        completionHandler(error, requestData);
                      }];
      }
    });
  });
}

- (void)fetchAllParametersForRequestID:(NSArray *)ids
                andCompletitionHandler:
                    (StorageManagerCompletionHandler)completionHandler {

  dispatch_queue_t queue = dispatch_queue_create("Fetch Resulats", NULL);

  dispatch_async(queue, ^{

    NSMutableArray *parameters = nil;

    const char *dbPath = [self.databasePath UTF8String];

    NSError *error;

    if (sqlite3_open(dbPath, &self->_requestsDB) == SQLITE_OK) {

      NSString *querySQL = [[NSString alloc]
          initWithFormat:@"SELECT rowid, * FROM PARAMETERS_TABLE WHERE "
                         @"REQUEST_TABLE_ID IN (%@)",
                         [ids componentsJoinedByString:@","]];

      sqlite3_stmt *sql_statement;

      const char *query_stmt = [querySQL UTF8String];

      if (sqlite3_prepare_v2(self->_requestsDB, query_stmt, -1, &sql_statement,
                             NULL) == SQLITE_OK) {

        parameters = [[NSMutableArray alloc] init];

        while (sqlite3_step(sql_statement) == SQLITE_ROW) {

          NSString *uuid = [[NSString alloc]
              initWithUTF8String:(const char *)sqlite3_column_text(
                                     sql_statement, 1)];
          NSNumber *uniqueId = @([uuid doubleValue]);
          NSString *name = [[NSString alloc]
              initWithUTF8String:(const char *)sqlite3_column_text(
                                     sql_statement, 2)];
          NSString *value = [[NSString alloc]
              initWithUTF8String:(const char *)sqlite3_column_text(
                                     sql_statement, 3)];
          int request_uniqueId = sqlite3_column_int(sql_statement, 4);

          NSDictionary *keyedValues = @{
            @"id" : uniqueId,
            @"name" : name,
            @"value" : value,
            @"request_table_id" : @(request_uniqueId)
          };
          Parameter *parameter =
              [[Parameter alloc] initWithKeyedValues:keyedValues];
          [parameters insertObject:parameter atIndex:0];
        }

      } else {

        NSDictionary *userInfo =
            @{NSLocalizedDescriptionKey : StorageErrorDescriptionPrepareDB};
        error = [[NSError alloc] initWithDomain:StorageDomainSqlite
                                           code:0
                                       userInfo:userInfo];
      }

    } else {

      NSDictionary *userInfo =
          @{NSLocalizedDescriptionKey : StorageErrorDescriptionOpenDB};
      error = [[NSError alloc] initWithDomain:StorageDomainSqlite
                                         code:0
                                     userInfo:userInfo];
    }
    dispatch_async(dispatch_get_main_queue(), ^{

      if (completionHandler) {

        NSArray *reveresedRarameters =
            [[parameters reverseObjectEnumerator] allObjects];
        completionHandler(error, reveresedRarameters);
      }
    });
  });
}

- (void)removeOldRequestsWithCompletitionHandler:
    (StorageManagerCompletionHandler)completionHandler {
  dispatch_queue_t queue = dispatch_queue_create("Remove DB", NULL);

  dispatch_async(queue, ^{

    NSMutableArray *requestIds = nil;

    const char *dbPath = [self.databasePath UTF8String];

    NSError *error;

    if (sqlite3_open(dbPath, &self->_requestsDB) == SQLITE_OK) {
      // TODO: change it to be 14 days, this is only for testing purpose
      NSString *querySQL = @"SELECT ID FROM REQUESTS_TABLE WHERE "
                           @"datetime(DATE, '+14 days') <= datetime('now','localtime');";

      sqlite3_stmt *sql_statement;

      const char *query_stmt = [querySQL UTF8String];

      if (sqlite3_prepare_v2(self->_requestsDB, query_stmt, -1, &sql_statement,
                             NULL) == SQLITE_OK) {

        requestIds = [[NSMutableArray alloc] init];

        while (sqlite3_step(sql_statement) == SQLITE_ROW) {

          int uniqueId = sqlite3_column_double(sql_statement, 0);
          [requestIds insertObject:@(uniqueId) atIndex:0];
        }
        // removing requests
        if ([requestIds count] != 0) {

          NSString *insertSQL = [NSString
              stringWithFormat:@"DELETE FROM REQUESTS_TABLE WHERE ID IN (%@)",
                               [requestIds componentsJoinedByString:@","]];

          const char *insertStatement = [insertSQL UTF8String];

          sqlite3_prepare_v2(self->_requestsDB, insertStatement, -1,
                             &sql_statement, NULL);

          if (sqlite3_step(sql_statement) != SQLITE_DONE) {
            // TODO: error while deleting old requests
          }

          // remove also paramters from parameters table
          insertSQL = [NSString
              stringWithFormat:@"DELETE FROM PARAMETERS_TABLE WHERE "
                               @"REQUEST_TABLE_ID IN (%@)",
                               [requestIds componentsJoinedByString:@","]];

          insertStatement = [insertSQL UTF8String];

          sqlite3_prepare_v2(self->_requestsDB, insertStatement, -1,
                             &sql_statement, NULL);

          if (sqlite3_step(sql_statement) != SQLITE_DONE) {
            // TODO: hendle error
          }
        }

      } else {

        NSDictionary *userInfo =
            @{NSLocalizedDescriptionKey : StorageErrorDescriptionPrepareDB};
        error = [[NSError alloc] initWithDomain:StorageDomainSqlite
                                           code:0
                                       userInfo:userInfo];
      }

    } else {

      NSDictionary *userInfo =
          @{NSLocalizedDescriptionKey : StorageErrorDescriptionOpenDB};
      error = [[NSError alloc] initWithDomain:StorageDomainSqlite
                                         code:0
                                     userInfo:userInfo];
    }

    dispatch_async(dispatch_get_main_queue(), ^{

      if (completionHandler) {

        completionHandler(error, NULL);
      }
    });
  });
}

- (void)removeRequestsDB:(NSArray *)requestIds {
  const char *dbPath = [self.databasePath UTF8String];

  if (sqlite3_open(dbPath, &self->_requestsDB) == SQLITE_OK) {

    sqlite3_stmt *sql_statement;
    // removing requests
    if ([requestIds count] != 0) {

      NSString *insertSQL = [NSString
          stringWithFormat:@"DELETE FROM REQUESTS_TABLE WHERE ID IN (%@)",
                           [requestIds componentsJoinedByString:@","]];

      const char *insertStatement = [insertSQL UTF8String];

      sqlite3_prepare_v2(self->_requestsDB, insertStatement, -1, &sql_statement,
                         NULL);

      if (sqlite3_step(sql_statement) != SQLITE_DONE) {
        // TODO: error while deleting old requests
      }

      // remove also paramters from parameters table
      insertSQL = [NSString
          stringWithFormat:
              @"DELETE FROM PARAMETERS_TABLE WHERE REQUEST_TABLE_ID IN (%@)",
              [requestIds componentsJoinedByString:@","]];

      insertStatement = [insertSQL UTF8String];

      sqlite3_prepare_v2(self->_requestsDB, insertStatement, -1, &sql_statement,
                         NULL);

      if (sqlite3_step(sql_statement) != SQLITE_DONE) {
        // TODO: hendle error
      }
    }

  }
}

#pragma mark - Getters && Setters

- (NSString *)databasePath {
  if (!_databasePath) {

    NSArray *directories = NSSearchPathForDirectoriesInDomains(
        NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirecotry = [directories lastObject];
    _databasePath = [[NSString alloc]
        initWithString:[cachesDirecotry
                           stringByAppendingPathComponent:DB_PATH]];
  }
  NSLog(@"Database path: %@", _databasePath);
  return _databasePath;
}

- (NSString *)dbFolderDirectoryPath {
  if (!_dbFolderDirectoryPath) {
    NSArray *directories = NSSearchPathForDirectoriesInDomains(
        NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirecotry = [directories lastObject];
    _dbFolderDirectoryPath = [[NSString alloc]
        initWithString:[cachesDirecotry
                           stringByAppendingPathComponent:DB_DIR_PATH]];
  }
  return _dbFolderDirectoryPath;
}
@end
