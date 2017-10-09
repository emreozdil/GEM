// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license.
//
// Microsoft Cognitive Services (formerly Project Oxford): https://www.microsoft.com/cognitive-services
//
// Microsoft Cognitive Services (formerly Project Oxford) GitHub:
// https://github.com/Microsoft/Cognitive-Face-iOS
//
// Copyright (c) Microsoft Corporation
// All rights reserved.
//
// MIT License:
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED ""AS IS"", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#import "MPOFaceAttributes.h"

@implementation MPOFaceAttributes
-(instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.age = dict[@"age"];
        self.gender = dict[@"gender"];
        self.smile = dict[@"smile"];
        self.glasses = dict[@"glasses"];
        self.facialHair = [[MPOFacialHair alloc] initWithDictionary:dict[@"facialHair"]];
        self.emotion = [[MPOFaceEmotion alloc] initWithDictionary:dict[@"emotion"]];
        self.headPose = [[MPOFaceHeadPose alloc] initWithDictionary:dict[@"headPose"]];
        self.hair = [[MPOHair alloc] initWithDictionary:dict[@"hair"]];
        self.makeup = [[MPOMakeup alloc] initWithDictionary:dict[@"makeup"]];
        self.occlusion = [[MPOOcclusion alloc] initWithDictionary:dict[@"occlusion"]];
        self.accessories = [[MPOAccessories alloc] initWithArray:dict[@"accessories"]];
        self.blur = [[MPOBlur alloc] initWithDictionary:dict[@"blur"]];
        self.exposure = [[MPOExposure alloc] initWithDictionary:dict[@"exposure"]];
        self.noise = [[MPONoise alloc] initWithDictionary:dict[@"noise"]];
    }
    return self;
}
@end
