//  MIT Licence
//
//  Created on 22/09/2013.
//
//  Copyright (c) 2013 Brice Rosenzweig.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//  

#import "GCWithingsRequestMeasures.h"
#import "GCAppGlobal.h"
#import "GCHealthMeasure.h"
#import "GCWebUrl.h"
#import "Flurry.h"
#import "GCHealthOrganizer.h"


@implementation GCWithingsRequestMeasures
-(gcWebService)service{
    return gcWebServiceWithings;
}
+(GCWithingsRequestMeasures*)withingsRequestMeasuresForUser:(NSDictionary*)aUser{
    GCWithingsRequestMeasures * rv = [[[GCWithingsRequestMeasures alloc] init] autorelease];
    if (rv) {
        rv.user = aUser;
    }
    return rv;
}

-(void)dealloc{
    [_user release];
    [super dealloc];
}
-(void)saveError:(NSString*)theString{
    NSError * e;
    NSString * fname = @"error_withings_measures.json";
    if(![theString writeToFile:[RZFileOrganizer writeableFilePath:fname] atomically:true encoding:NSUTF8StringEncoding error:&e]){
        RZLog(RZLogError, @"Failed to save %@. %@", fname, e.localizedDescription);
    }
}

-(NSString*)url{
    NSString * uid = self.user ? (self.user)[@"id"] : @"";
    NSString * key = self.user ? (self.user)[@"publickey"] :@"";
    return GCWebWithingsMeasure(uid, key);
}
-(NSString*)description{
    return NSLocalizedString(@"Downloading from withings",@"Request Description");
}
-(NSDictionary*)deleteData{
    return nil;
}
-(NSDictionary*)postData{
    return nil;
}
-(NSData*)fileData{
    return nil;
}
-(NSString*)fileName{
    return nil;
}

-(void)process:(NSString*)theString encoding:(NSStringEncoding)encoding andDelegate:(id<GCWebRequestDelegate>) delegate{
    NSError * err = nil;
#if TARGET_IPHONE_SIMULATOR
    NSError * e = nil;
    NSString * fn = [NSString stringWithFormat:@"withings_measure_%@.json",self.user ? (self.user)[@"id"] : @""];
    [theString writeToFile:[RZFileOrganizer writeableFilePath:fn] atomically:true encoding:encoding error:&e];
#endif

    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:[theString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err ];
    if (json==nil) {
        RZLog(RZLogError, @"json parsing failed %@", err);
        [self saveError:theString];
        _status = GCWebStatusConnectionError;
    }else {
        NSArray * raw = json[@"body"][@"measuregrps"];
        if (raw) {

            for (NSDictionary * one in raw) {
                NSDate * date = nil;
                NSNumber * grpid = nil;

                NSNumber * dateN = one[WS_KEY_DATE];
                if (dateN && [dateN isKindOfClass:[NSNumber class]]) {
                    date = [NSDate dateWithTimeIntervalSince1970:dateN.longValue];
                }

                grpid = one[WS_KEY_GRPID];
                if (![grpid isKindOfClass:[NSNumber class]]) {
                    grpid = nil;
                }

                if (grpid&&date) {
                    NSArray * meas = one[WS_KEY_MEASURES];
                    if (meas) {
                        for (NSDictionary * m in meas) {
                            GCHealthMeasure * hm = [GCHealthMeasure healthMeasureFromWithings:m forDate:date andId:grpid.integerValue];
                            [[GCAppGlobal health] addHealthMeasure:hm];
                        }
                    }
                }
            }
            [[GCAppGlobal profile] serviceSuccess:gcServiceWithings set:YES];
            [GCAppGlobal saveSettings];
            [Flurry logEvent:EVENT_WITHINGS];
        }
    }
    [delegate processDone:self];
}
-(id<GCWebRequest>)nextReq{
    return nil;
}




@end
