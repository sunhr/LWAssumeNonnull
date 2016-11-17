# LWAssumeNonnull
[![Build Status](https://travis-ci.org/sunhr/LWAssumeNonnull.svg?branch=master)](https://travis-ci.org/sunhr/LWAssumeNonnull)


Xcode 8+ extension for adding `NS_ASSUME_NONNULL_BEGIN` and `NS_ASSUME_NONNULL_END` marco automatically

## Feature


## Building
0. Setup Code Signing for Target `LWAssumeNonnullContainer` and `LWAssumeNonnull` by applying your own Team
1. Build Target `LWAssumeNonnull`
2. Copy all `app` and `appex` products to your `Application` folder
3. Open `LWAssumeNonnullContainer.app` then close it
4. Open `Preference - Extension` of macOS, make sure `LWAssumeNonnull` is selected as Xcode Source Editor
5. Restart Xcode and enjoy it, add a shortcut if you like