# News

### Preview
![Paging](./Images/paging.gif) ![Register & Change category](./Images/register.gif)


### Requirements
Please create a new application with following conditions
1. Use https://newsapi.org/ as data source
2. Application must be written in Kotlin OR Swift
3. Application must be written in MVVM and MVP, and write a test case.
4. Use any framework and library that you know and understand
5. Application must have this feature:
    a. News List with image
    b. News detail with image
    c. Link to open original news
    d. Have 3 tab view at home and it will show list about:
        i. Top Headline news with image
        ii. Custom news based on user preferences (user must be presented with keyword selection from: bitcoin, apple, earthquake, animal. User can only choose one keyword)
        iii. Profile
6. User can register with username at profile and data (user preferences) will be saved on local storage
7. Please initialize version control with git for checking git history
8. Please upload to Github


### Achivements
- [x] Using MVVM architecture (MVVM-C)
- [x] Using RxSwift to bind data
- [x] Using 3rd party SDWebImage to load remote images
- [x] Unit test
- [x] 3 Tabs: Headlines, News, Profile
- [x] Register with username, saved the username and category on local storage 
- [x] Views detail article, open safari to get more detail
- [ ] Transforms the image from list view to detail view with a smooth animation
- [x] Supports paging (load, pull to refresh, load more)
- [x] Handles some common errors
- [x] Using version control with git
- [ ] Implement Cache data for offline
- [x] Supports dark mode 
- [x] Supports localization
 

------
# Setup & Run
### Setup Cocoapods
This project uses Cocoapods to manage 3rd parties, you have to run some commands to setup it.
1. Open Terminal App
2. $ `sudo gem install cocoapods`
3. enter your computer password, then enjoy a cup of tea and wait for installing

You can refer to the offical information here [cocoapods.org](https://cocoapods.org)


### Install 3rd parties & open App
1. Open Terminal app
2. $ `cd <the/path/to/project>`
3. $ `pod install`
4. $ `open News.xcworkspace`


### Other
I have been using swiftgen system-wide to generate localization strings and asset colors. In case you want to change it, you have to do the following steps:
1. Install swiftgen 
2. Open Terminal app
3. $ `cd <the/path/to/project/{Source code Project}>` // move to the folder containing `swiftgen.yml`
4. $ `swiftgen`

It's good if you're aware of swiftgen. If not, you can get more information here, [swiftgen](https://github.com/SwiftGen/SwiftGen). In my memory, the guidance is specific enough.
