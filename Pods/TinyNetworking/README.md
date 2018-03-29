<p align="center">
  <img src="https://github.com/jdisho/TinyNetworking/blob/master/Images/tinynetworking-logo.png">
</p>

#
[![Platform](https://img.shields.io/cocoapods/p/TinyNetworking.svg?style=flat)](https://github.com/jdisho/TinyNetworking)
[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg)](https://swift.org)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/TinyNetworking.svg)](https://cocoapods.org/pods/TinyNetworking)

## 🌩 What is TinyNetworking
TinyNetworking is a simple network layer written in Swift.

- Just a tiny wrapper around NSURLSession. 🌯
- Supports CRUD methods (GET, POST, PUT, DELETE). ✌️
- No external dependencies. 🎉
- Works if you can determine how your data is being represented in JSON. 😇
- Works for non JSON types as well.
- Highly inspired by: https://talk.objc.io/episodes/S01E01-tiny-networking-library ❤️

## 🛠 Installation

### CocoaPods

To integrate TinyNetworking into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'TinyNetworking', '~> 0.3'
    
#or
    
pod 'TinyNetworking/RxSwift', '~> 0.3' # for the RxSwift extentions
```

Then, run the following command:

```bash
$ pod install
```
### Carthage 
*Comming Soon*

### Swift Package Manager 
*Comming Soon*

### Manually

If you prefer not to use any of the dependency managers, you can integrate TinyNetworking into your project manually, by downloading the source code and placing the files on your project directory.

## 👨🏻‍💻 Usage

### 📦 Resource
Resource is the core part of TinyNetworking and is generic over the result type.

Resource has five properties: 

|    Properties     |   |
----------|-----------------
URL | URL of the endpoint
Request method | by default `GET`, but required for `PUT`, `POST`, `DELETE`
Parameters | **only** [String: String]
Headers | [String: String]
Decoding function | by default `JSONDecoding`, but required if you want to implement your decoding function.

#### Create Resource

```swift
Resource<BodyType, ResponseType>(url: URL(string: "..."))
```
*Resouce contains two generic types, the type of the response that is expected and the type of the object that is part of the request body*

##### 🔗 `GET` resource:

```swift
Resource<Void,  ResponseType>(url: URL(string: "..."))
```
or simpler: 
```swift
SimpleResource<ResponseType>(url: URL(string: "..."))
```

##### 🔗 `POST` resource:

```swift
Resource<BodyType,  ResponseType>(url: URL(string: "..."), .post(*body*))
```

##### 🔗 `PUT` resource:

```swift
Resource<BodyType,  ResponseType>(url: URL(string: "..."), .put(*body*))
```

##### 🔗 `DELETE` resource:

```swift
Resource<BodyType,  ResponseType>(url: URL(string: "..."), .delete(*body*))
```

#### 💄 Add parameters

```swift
var params: [String: String] = [:]
params["page"] = "1"
params["per_page"] = "10"
params["order_by"] = "popular"

SimpleResource<ResponseType>(url: URL(string: "..."), parameters: params)
```

#### 🎩 Add header

```swift
let resource = SimpleResource<ResponseType>(url: URL(string: "..."))
resource.addHeader(key: "...", value: "...")
```

### ⚙️ Making and handling a request
The Resouce is useless until is part of a request:

```swift
import TinyNetworking

let tinyNetworking = TinyNetworking()

let resource = SimpleResource<ResponseType>(url: URL(string: "..."))

tinyNetworking.request(resource) { results in
  switch results {
    case let .success(response):
      print(response)
    case let .error(error):
      print(error.localizedDescription)
  }
}
```

## 🔥 Reactive Extensions
Reactive extensions are cool. TinyNetworking provides reactive extensions for RxSwift and **soon** for ReactiveSwift.

### RxSwift
```swift
tinyNetworking.rx.request(resource).subscribe { event in
   switch event {
   case let .success(response):
      print(response)
   case let .error(error):
       print(error.localizedDescription)
   }
}
```

## 🐨 Author
This tiny library is created with ❤️ by [Joan Disho](https://twitter.com/_disho) at [QuickBird Studios](www.quickbirdstudios.com)

## 🙏 Acknowledgements
This library is highly insipired on these amazing [talks](https://talk.objc.io/collections/networking) by **Chris Eidhof** and **Florian Kugler** at Swift Talk

### 📃 License

TinyNetworking is released under an MIT license. See [License.md](https://github.com/jdisho/TinyNetworking/blob/master/LICENSE) for more information.
