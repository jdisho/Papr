# 🌁 Papr
[![Build Status](https://app.bitrise.io/app/2a2fcf982f53badd/status.svg?token=0XXibUe3FFc0Ff9qry6eTg&branch=develop)](https://www.bitrise.io/app/2a2fcf982f53badd)
[![Build Status](https://img.shields.io/badge/Swift-5.1.1-orange.svg)](https://swift.org)


Papr is an unofficial Unsplash app for iOS.
  <p float="right">
    <img src="https://github.com/jdisho/Papr/blob/develop/Screenshots/login_page.png" width="24%"/> 
    <img src="https://github.com/jdisho/Papr/blob/develop/Screenshots/home.png" width="24%"/> 
    <img src="https://github.com/jdisho/Papr/blob/develop/Screenshots/photo_details.png" width="24%"/>
    <img src="https://github.com/jdisho/Papr/blob/develop/Screenshots/add_to_collection.png" width="24%"/>
    <img src="https://github.com/jdisho/Papr/blob/develop/Screenshots/explore.png" width="24%"/> 
    <img src="https://github.com/jdisho/Papr/blob/develop/Screenshots/photo_collection.png" width="24%"/> 
    <img src="https://github.com/jdisho/Papr/blob/develop/Screenshots/search.png" width="24%"/>
  </p>

## 🏃‍♂️ Getting Started

``` bash
git clone https://github.com/jdisho/Papr.git
cd Papr
pod install
open Papr.xcworkspace # or xed .
```

## ⚙️ Setup
To be able to log in during development, you'll need a Client ID and Client Secret.

To get these, [register](https://unsplash.com/oauth/applications) a new OAuth application on Unsplash.

Make sure the Authorization callback URL is set to `papr://unsplash`. The others can be filled in as you wish.

To add the Client ID and Client Secret to the App, follow these steps:
###
1. In Xcode, go to `Product`> `Scheme` > `Manage Schemes...`
2. Select `Papr` and click `Edit...`
3. Go to `Run` > `Arguments`
4. Add your Client ID (`UNSPLASH_CLIENT_ID` as key) and Client Secret (`UNSPLASH_CLIENT_SECRET`) to the Environment Variables.


## 🎉 Why am I building this?
1. Pushing [`RxSwift`](https://github.com/ReactiveX/RxSwift) to its limits. 🔥
1. `MVVM` + `Coordinator`
1. Using `Codable`, [`RxDataSources`](https://github.com/RxSwiftCommunity/RxDataSources), [`Action`](https://github.com/RxSwiftCommunity/Action).
1. Exploring [Unsplash](https://unsplash.com) and its [API](https://unsplash.com/developers)
1. Fun thing!

## ❤️ Contributing
I intend for this project to be more as an educational resource, learn by open sourcing. 

I am very open for feedback and contribution.

