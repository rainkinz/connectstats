//  MIT Licence
//
//  Created on 17/01/2016.
//
//  Copyright (c) 2016 Brice Rosenzweig.
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

#import <Foundation/Foundation.h>

@class GCActivity;

@interface GCCalendarDataMarkerInfo : NSObject

@property (nonatomic,retain) NSString * activityTypeKey;

@property (nonatomic,retain) GCNumberWithUnit * sumDuration;
@property (nonatomic,retain) GCNumberWithUnit * sumDistance;
@property (nonatomic,retain) GCNumberWithUnit * sumSteps;
@property (nonatomic,assign) NSUInteger count;

+(GCCalendarDataMarkerInfo*)markerInfo;

-(void)addActivity:(GCActivity*)act;
-(void)maxMarkerInfo:(GCCalendarDataMarkerInfo*)marker;

@end
