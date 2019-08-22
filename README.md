### Features

- You can override `AlertFactory` for standarts error alerts using `AlertFactoryError`.
- `defaultCancelTitle` and `defaultForceCancelTitle` are properties in `AlertFactory` used to display default cancels buttons on alert.
- The `presentationViewController` should be overridden in case you have async alerts. It should return the current viewController displayed.

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

#### 1. AlertFactory
AlertFactory is the main core that should be specified the T generic type as UIViewController and **AlertFactoryType**.

The library already has implemented the extension for UIAlertController, so you can use the AlertFactory without writing any code, just calling `AlertFactory<UIAlertController>`.

The methods to create the alert are:

- .init(viewController: **UIViewController?**)
- .with(title: Title)
- .with(text: Text)
- .with(image: UIImage)
- .otherButton(title: String, onTap: (() -> Void)?=nil)
- .cancelButton(title: String, onTap: (() -> Void)?=nil)
- .destructiveButton(title: String, onTap: (() -> Void)? = nil)
- .forError(_ error: **AlertFactoryError**)
- .onDismiss( _ completion: (() -> Void)?)
- .present(completion: (() -> Void)? = nil)
- .append()
- .asAlertView() -> UIViewController?

The spectifications for otherButton, cancelButton and destructiveButton are for UIAlertController button types.

The append() method should be use to discard the AlertFactory self return 

#### 2. AlertFactoryType

The AlertFactoryType is a protocol that helps AlertFactory to delivery the payload that it has mounted to the AlertController provider. Here, you can integrate any UIViewController with AlertFactory.

So, the methods are similary with the methods used to create the alert:
##### func with(title: String) -> Self
Depending on the AlertController, you will have to recreate the AlertController or just call some method like .setTitle(title)

The example for UIAlertController already done in this library is:
```swift
extension UIAlertController: AlertFactoryType {
    public func with(title: String) -> Self {
        return .init(title: title, message: self.message, preferredStyle: self.preferredStyle)
    }
}
```
##### func with(text: String, at index: Int) -> Self
This method is a trick for different possible AlertControllers. By default, the index will be zero all the time that you call `AlertFactory<UIAlertController>().with(text: "This is the message")`.

Sometimes, you can have one AlertController that has different fields for body content where the message is shown. So, to make more easier, you can share this setting using the index parameter by calling the AlertFactory with index specified: `AlertFactory<UIAlertController>().with(text: "This is the subtitle").with(text: "This is the message", at: 1)`. Now, you can set the AlertController, if is available, like this:
```swift
extension ExampleAlertController: AlertFactoryType {
    func with(text: String, at index: Int) -> Self {
        if index == 0 {
            self.subtitle(text)
        } else {
            self.text(text)
        }
        return self
    }
}
```

##### func with(image: UIImage) -> Self
This method is optional but will be called everything you use AlertFactory.with(image:). Like it means, you can set image to your alert if is available.

```swift
extension ExampleAlertController: AlertFactoryType {
    func with(image: UIImage) -> Self {
        self.setImage(image)
        return self
    }
}
```

##### func append(button: AlertFactoryButton) -> Self

The AlertFactoryButton is a wrapper created by AlertFactory and holds the informations necessaly to create the action button. But, depending on your AlertController, the style property doesn't fit well. So, you should implement some adaptions to this.

The default UIAlertController example:
```swift
extension UIAlertController: AlertFactoryType {
    public func append(button: AlertFactoryButton) -> Self {
        let action = UIAlertAction(title: button.title, style: button.style, handler: { _ in
            button.onTap?()
        })

        self.addAction(action)

        if button.isPreferred {
            if #available(iOS 9.0, *) {
                self.preferredAction = action
            }
        }

        return self
    }
}
```

We have implemented the same method for [MDCAlertController](https://github.com/material-components/material-components-ios "MDCAlertController") in your other projects to use Dialogs from MaterialComponents.
```swift
extension MDCAlertController: AlertFactoryType {
    public func append(button: AlertFactoryButton) -> Self {
        let emphasis: MDCActionEmphasis = {
            switch button.style {
            case .default:
                return .medium
            case .destructive:
                return .high
            case .cancel:
                return .medium
            @unknown default:
                return .medium
            }
        }()

        self.addAction(MDCAlertAction(title: button.title, emphasis: emphasis, handler:  { _ in
            button.onTap?()
        }))

        return self
    }
}
```

##### Other methods

You can implement the methods `with(preferredStyle: UIAlertController.Style)`, `append(textField: AlertFactoryField)` and `didConfiguredAlertView()`. 

The `didConfiguredAlertView()` is important to stylize your AlertController without to implement a default class and use as your alert.

#### 3. AlertFactoryError
This class should be overridden to create your own error casting when you call .forError() in your AlertFactory.

In some projects, we had to call forError by setting as parameter the FieldValidationError, a internal class. So, first we create a BaseAlertFactory and create to methods.

```swift 
class BaseAlertFactory<T: UIViewController & AlertFactoryType>: AlertFactory<T> {
    override func forError(_ error: AlertFactoryError) -> Self {
        if let fieldError = self.error as? FieldValidationError {
            return self.with(text: fieldError.message)
        }

        super.forError(error).append()
        return self
    }

    func forError(_ error: Swift.Error) -> Self {
        return self.forError(AlertFactoryError(error))
    }
}
```
This is a simple example, but you can create classes extended with AlertFactoryError and override the title and message parameters and use it by implementing your own BaseAlertFactory like the example above.

### Usage
---
Now, you are able to start using AlertFactory by reading the **Definitions**. So, this project has an [example](https://github.com/umobi/AlertFactory/blob/master/Example/AlertFactory/ViewController.swift "example") to guide you using this library.

We have different situations to construct some alerts and we will specify the ones that we used in our projects.

#### 1. Creating a Simple Alert

```swift
import AlertFactory

class MainViewController: UIViewController {
    // ... MainViewController settings

    @IBAction func showHelloWorldAlert(_ sender: UIButton!) {
        AlertFactory<UIAlertController>(viewController: self)
            .with(title: "Hello World!")
            .with(text: "Implementing my first alert using AlertFactory")
            .cancelButton(title: "Dismiss")
            .present()
    }
}
```

#### 2. Treating Error Actions
As specified the FieldValidationError, we want to call the correct Field after the AlertController be dismissed using the **BaseAlertFactory** example.
```swift
import AlertFactory

class MainViewController: UIViewController {
    // ... MainViewController settings

    func showFieldValidationError(_ fieldError: FieldValidationError) {
        BaseAlertFactory<UIAlertController>(viewController: self)
            .forError(fieldError)
            .onDismiss { [weak self] in
                switch fieldError.field {
                case .cep:
                    _ = self?.cepField.becomeFirstResponder()
                case .neighborhood:
                    _ = self?.neighborhoodField.becomeFirstResponder()
                default:
                    break
                }
            }.present()
    }
}
```
#### 3. Different Buttons for some Event
This helps when you are creating the .actionSheet and you want to display or not the delete photo just if the user had selected some photo before. You can do this by calling .append() method.

```swift
import AlertFactory

extension MainViewController {
    func presentPickerOptions() {
        let alert = AlertFactory<UIAlertController>(viewController: self)
            .with(preferredStyle: .actionSheet)
            .with(title: "Profile")
            .with(message: "Pick your profile image")
            .cancelButton()
            .otherButton(title: "Photo Library") { [weak self] in
                self?.openImagePickerController(sourceType: .photoLibrary)
            }.otherButton(title: "Camera") { [weak self] in
                self?.openImagePickerController(sourceType: .camera)
            }

        if self.profileImage {
            alert.destructiveButton(title: "Delete Photo") { [weak self] in
                self?.deletePhoto()
            }.append()
        }

        alert.present()
    }
}
```

#### 4. Passing the AlertController as UIViewController
Sometimes, we can use other classes to present the AlertController and maybe its does not have the UIViewController.present(). With this, you can call .asAlertView() to create you AlertController using AlertFactory

```swift
import AlertFactory

class Event {
    func onEvent(_ event: EventPayload) {
        let alertController = AlertFactory<UIAlertController>()
            .with(title: event.title)
            .with(text: event.message)
            .cancelButton() {
                self.userDidCancel(event)
            }.otherButton(title: "Accept") {
                self.userDidAccept(event)
            }.asAlertView()

        self.present(alertController)
    }
}
```

#### 5. Hidden `T` generic type

To make your code more easier to read you can create a class that extends AlertFactory and call it without specifying the T parameter all the times.

```swift
import AlertFactory

class UIAlertFactory: AlertFactory<UIAlertController> {}
```

```swift
extension MainViewController {
    func presentAlert() {
        UIAlertFactory(viewController: self)
            .with(title: "Hello World")
            .present()
    }
}
```

## Author

brennoumobi, brenno@umobi.com.br

## License

AlertFactory is available under the MIT license. See the LICENSE file for more info.

### End
