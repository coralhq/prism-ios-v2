# Prism Mobile SDK

## Getting Started

This SDK's projects is hosted in **DemoPrismCore** project, so you only need to open **DemoPrismCore.xcodeproj** file to see all of SDK's projects.

If you want to run the Demo app, choose **DemoPrismCore scheme**


## Build Command

Before executing these script, make sure your current directory position is inside **DemoPrismCore** folder.

### Requirement
- [XCPretty](https://github.com/supermarin/xcpretty)

### PrismCore

```
xcodebuild -project DemoPrismCore.xcodeproj \
-scheme PrismCoreTests \
-sdk iphonesimulator \
-destination 'platform=iOS Simulator,name=iPhone 6,OS=10.3.1' \
test | xcpretty -c -r junit -r html
```

### PrismUI

```
xcodebuild -project DemoPrismCore.xcodeproj \
-scheme PrismUnitTests \
-sdk iphonesimulator \
-destination 'platform=iOS Simulator,name=iPhone 6s,OS=10.3.1' \
test | xcpretty -c -r junit -r html
```

## Generate Test Coverage Command

### Requirement

- [Slather](https://github.com/SlatherOrg/slather)

### PrismCore

Run this script

```
slather coverage --html \
--ignore '../PrismCore/PrismCore/Networking/Network.swift' \
--ignore '../PrismCore/PrismCore/Vendor/*' \
--ignore '../PrismCore/PrismCoreTests/*' \
--output-directory ../PrismCore/build/reports/html/ \
--scheme PrismCoreTests DemoPrismCore.xcodeproj
```

Open Index.html file inside `PrismCore/build/reports/html` folder


### PrismUI

Run this script

```
slather coverage --html \
--ignore '../PrismUI/PrismUI/Vendors/*' \
--ignore '../PrismUI/PrismUI/ViewControllers/*' \
--ignore '../PrismUI/PrismUI/Views/*' \
--ignore '../PrismUI/PrismUI/Components/Extensions/*' \
--ignore '../PrismUI/PrismUI/Cells/*' \
--ignore '../PrismUI/PrismUI/Helpers/*' \
--ignore '../PrismUI/PrismUI/Utils/*' \
--ignore '../PrismUI/PrismUnitTests/*' \
--ignore '../PrismUI/PrismUI/ViewModels/ChatSectionViewModel.swift' \
--ignore '../PrismUI/PrismUI/Kits/*' \
--ignore '../PrismUI/PrismUI/ViewModels/AuthViewModel.swift' \
--ignore '../PrismUI/PrismUI/PrismUI.swift' \
--ignore '/*' \
--ignore '../PrismCore/*' \
--ignore '../PrismUI/PrismUI/Analytics/*' \
--output-directory ../PrismUI/build/reports/html \
--scheme PrismUnitTests DemoPrismCore.xcodeproj
```

Open Index.html file inside `PrismUI/build/reports/html` folder