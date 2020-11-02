# AlertFactory

[![CI Status](https://img.shields.io/travis/umobi/AlertFactory.svg?style=flat)](https://travis-ci.org/umobi/AlertFactory)
[![Version](https://img.shields.io/cocoapods/v/AlertFactory.svg?style=flat)](https://cocoapods.org/pods/AlertFactory)
[![License](https://img.shields.io/cocoapods/l/AlertFactory.svg?style=flat)](https://cocoapods.org/pods/AlertFactory)
[![Platform](https://img.shields.io/cocoapods/p/AlertFactory.svg?style=flat)](https://cocoapods.org/pods/AlertFactory)

## Installation

AlertFactory is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AlertFactory'
```

### Definitions

----

#### 1. RawAlert

- .with(title: Title) ✅
- .with(text: Text) ✅
- .otherButton(title: String, onTap: (() -> Void)?=nil) ✅
- .cancelButton(title: String, onTap: (() -> Void)?=nil) ✅
- .destructiveButton(title: String, onTap: (() -> Void)? = nil) ✅
- .onDismiss( _ completion: (() -> Void)?) ❌
- .present(completion: (() -> Void)? = nil) ❌
- .append() ❌
- .asAlertView() -> UIViewController? ❌

## Author

brennobemoura, brennobemoura@outlook.com.br

## License

AlertFactory is available under the MIT license. See the LICENSE file for more info.

### End
