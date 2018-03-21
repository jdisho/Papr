# 🌁 Papr
[![Build Status](https://travis-ci.com/jdisho/Papr.svg?token=xQbkrEbREfF5iXgoNCsn&branch=master)](https://travis-ci.com/jdisho/Papr)

Papr is an unofficial Unsplash app for iOS.

<p float="center">
  <img src="https://github.com/jdisho/Papr/blob/develop/Screenshots/login.png" width="33%"/> 
  <img src="https://github.com/jdisho/Papr/blob/develop/Screenshots/home.png" width="33%"/> 
  <img src="https://github.com/jdisho/Papr/blob/develop/Screenshots/photo_details.png" width="33%"/>
</p>

## 🏃‍♂️ Getting Started
1. Clone the repository.
1. Run `pod install` to install dependencies.

## ⚙️ Setup
To be able to log in during development, you'll need a Client ID and Client Secret.
To get these, [register](https://unsplash.com/oauth/applications) a new OAuth application on Unsplash.
Make sure the Authorization callback URL is set to `freetime://`. The others can be filled in as you wish.

To add the Client ID and Client Secret to the App, follow these steps:
###
1. In Xcode, go to `Product`> `Scheme` > `Manage Schemes...`
2. Select `Papr` and click `Edit...`
3. Go to `Run` > `Arguments`
4. Add your Client ID (`UNSPLASH_CLIENT_ID` as key) and Client Secret (`UNSPLASH_CLIENT_SECRET`) to the Environment Variables.


## 🎉 Why am I building this?
1. Pushing [`RxSwift`](https://github.com/ReactiveX/RxSwift) to its limits. 🔥
1. MVVM + Coordinator
1. Using Codable
1. Using [TinyNetworking](https://github.com/jdisho/TinyNetworking) (lightweight network library)
1. Exploring Unsplash and its [API](https://unsplash.com/developers)
1. Using as little dependecies as possible.
1. Fun thing! 🤙

## 🧘‍♀️ Current state
1. Login with Unsplash
1. Explore New/Curated photos
1. Photo details
1. Like/Unlike photos

## 🧗‍♂️ ToDo
1. Download photos.
1. Search photos/users/collections.
1. User profile.
1. Add/edit/remove photos to a collection.
1. **Write tests**.
1. ... more

## Contributing
I intend for this project to be more as an educational resource, learn by open sourcing. 

I very open for feedback and contribution. ❤️🤙

