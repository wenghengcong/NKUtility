//
//  BiometricAuthenticationConstants.swift
//  BiometricAuthentication
//
//  Created by Rushi on 27/10/17.
//  Copyright © 2018 Rushi Sangani. All rights reserved.
//

import Foundation
import LocalAuthentication

let kBiometryNotAvailableReason = "kBiometryNotAvailableReason".localizedInCommonString

/// ****************  Touch ID  ****************** ///

let kTouchIdAuthenticationReason = "kTouchIdAuthenticationReason".localizedInCommonString
let kTouchIdPasscodeAuthenticationReason = "kTouchIdPasscodeAuthenticationReason".localizedInCommonString

/// Error Messages Touch ID
let kSetPasscodeToUseTouchID = "kSetPasscodeToUseTouchID".localizedInCommonString
let kNoFingerprintEnrolled = "kNoFingerprintEnrolled".localizedInCommonString
let kDefaultTouchIDAuthenticationFailedReason = "kDefaultTouchIDAuthenticationFailedReason".localizedInCommonString

/// ****************  Face ID  ****************** ///

let kFaceIdAuthenticationReason = "kFaceIdAuthenticationReason".localizedInCommonString
let kFaceIdPasscodeAuthenticationReason = "kFaceIdPasscodeAuthenticationReason".localizedInCommonString

/// Error Messages Face ID
let kSetPasscodeToUseFaceID = "kSetPasscodeToUseFaceID".localizedInCommonString
let kNoFaceIdentityEnrolled = "kNoFaceIdentityEnrolled".localizedInCommonString
let kDefaultFaceIDAuthenticationFailedReason = "kDefaultFaceIDAuthenticationFailedReason".localizedInCommonString
