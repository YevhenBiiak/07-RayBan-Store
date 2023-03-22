# 07-RayBan-Store
<p align="center" width="100%">
  <img width=23% src="https://user-images.githubusercontent.com/80542175/226192639-a10dba70-ec3e-47e4-90a0-86b4c1b6f367.PNG">
  <img width=23% src="https://user-images.githubusercontent.com/80542175/226192728-6ce98b9f-433a-44e5-bd4f-b8f71ed03dc5.PNG">
  <img width=23% src="https://user-images.githubusercontent.com/80542175/226193737-ec85fe0f-56ca-4a82-acb1-05ebfa353ced.PNG">
  <img width=23% src="https://user-images.githubusercontent.com/80542175/226194586-e73f63bb-5b75-41ed-9cb5-ae38bd4a8518.PNG">
</p>

<details><summary>More screenshots</summary>
  <p align="center" width="100%">
    <img width=23% src="https://user-images.githubusercontent.com/80542175/226192677-10842365-fa6e-4deb-9928-263124b6908e.PNG">
    <img width=23% src="https://user-images.githubusercontent.com/80542175/226194576-148be03a-b965-40d6-8200-ba1189b2634e.PNG">
    <img width=23% src="https://user-images.githubusercontent.com/80542175/226194616-7389fe01-6eb4-4158-a71b-74463643353c.PNG">
    <img width=23% src="https://user-images.githubusercontent.com/80542175/226194617-c4b1c6e9-6ee2-4645-9716-ad1dbb347cde.PNG">
  </p>
  <p align="center" width="100%">
    <img width=23% src="https://user-images.githubusercontent.com/80542175/226194594-d0b5088d-3436-4dca-b5f5-f01330bee437.PNG">
    <img width=23% src="https://user-images.githubusercontent.com/80542175/226194613-17438830-36d6-4792-b75b-7395bd25dbd8.PNG">
    <img width=23% src="https://user-images.githubusercontent.com/80542175/226194603-cc1bca8d-cbeb-4dde-b98b-4720e0e365f3.PNG">
    <img width=23% src="https://user-images.githubusercontent.com/80542175/226194618-76c7cbd1-420e-491f-8caf-52fc107f6566.PNG">
  </p>
</details>


#### Description 
This is a full-featured app (excluding purchases) that allows users to order glasses from the online store. The app has a shopping cart where users can add and remove items, as well as a wish list where they can keep their favorite items for future purchases. Users can also place orders, choose shipping options, and enter their address for delivery. The app also has a feature that allows users to view their order history.


## The Goal

The project was developed for the purpose of studying Clean Architecture and MVP presentation pattern, as well as for learning Firebase frameworks such as AuthFirebase and RealtimeDatabase. Storyboards were not used in the project.

The goal of the project was to build a complex, scalable, and maintainable application that adheres to SOLID principles, features multiple screens (15), and communicates with a real-time database.


## Features and Implementation

One of the key features of the app is its use of async/await concurrency. This enables the app to perform multiple tasks at once, such as loading images, fetching product data, and updating the UI, without causing the app to freeze or crash.

For the product list screen was implemented infinite scrolling (with a batch size of 6 products) and shimmer view as a loading indicator. 
As a network layer for obtaining images was implemented an API using URLSession and custom configuration for image caching.

In addition, the project implements my own approach to handling and displaying errors (since I couldn't find similar articles on the internet). Product data was collected from a website with the same name and converted into a JSON structure for the database.

The AuthFirebase framework was used to implement:
  * facebook login (Facebook SDK)
  * email and password login
  * email and password registration
  * forgot password
  * change email
  * change password

The application uses five types of alerts (see spoiler):
  - <details><summary>inline (for text field errors)</summary><br>
      <img width=300 title="inline" src="https://user-images.githubusercontent.com/80542175/226196356-a04862ce-f049-4921-b645-d6e7313fb51d.PNG"/>
    </details>
  - <details><summary>toast (for errors that cannot be inline)</summary><br>
      <img width=300 title="toast" src="https://user-images.githubusercontent.com/80542175/226196368-41533bff-16e3-4523-8795-830e4acc6b2e.PNG"/>
    </details>
  - <details><summary>blocking (for blocking user interaction with app)</summary><br>
      <img width=300 title="blocking" src="https://user-images.githubusercontent.com/80542175/226196393-434e75a4-a4eb-4934-b036-9b65d9c2c5ed.PNG"/>
    </details>
  - <details><summary>dialog alert (for confirmation of actions)</summary><br>
      <img width=300 title="dialog" src="https://user-images.githubusercontent.com/80542175/226196406-b196d56d-6036-4275-9b7f-d0f506a4a516.PNG"/>
    </details>
  - <details><summary>alert (simple alert with one action for error or success messages)</summary><br>
      <img width=300 title="alert" src="https://user-images.githubusercontent.com/80542175/226196414-31b6a211-af05-4415-9af8-d81174a32c98.PNG"/>
    </details>
    
## Used frameworks

- `UIKit`
- `Stevia`
- `CoreAnimation`
- `Firebase SDK` (`FirebaseAuth`, `FirebaseDatabase`)
- `Facebook SDK`
- `Network` (`NWPathMonitor`)
- `URLSession`

## The technology stack

- `Swift`
- `CocoaPods`
- `SwiftLint`
- `AutoLayout`
- `Concurrency` (`async/await`)
- `JSON`


## Video demo

<details>
  <summary>Login with Facebook</summary><br>
  <video src="https://user-images.githubusercontent.com/80542175/226197066-7e84e612-49aa-4183-8402-c950ac6ebbca.mov">
</details>
<details>
  <summary>Registration with email and password</summary><br>
  <video src="https://user-images.githubusercontent.com/80542175/226197070-13060592-e803-48fe-b36f-5fd266a79054.mov">
</details>
<details>
  <summary>Login with email and password</summary><br>
  <video src="https://user-images.githubusercontent.com/80542175/226197072-f6c65275-975c-4ed7-83c7-b74833ad9aa0.mov">
</details>
<details>
  <summary>Forgot password</summary><br>
  <video src="https://user-images.githubusercontent.com/80542175/226197073-52db263a-c633-4960-9651-35500cc67dc4.mov">
</details>

<details>
  <summary>Products list and products categories</summary><br>
  <video src="https://user-images.githubusercontent.com/80542175/226197688-3af3976c-ae26-468f-9ade-15e67829af1d.mov">
</details>
<details>
  <summary>Product details and favorite list</summary><br>
  <video src="https://user-images.githubusercontent.com/80542175/226197697-acf61689-05e5-420f-b5c8-6e917c5501e3.mov">
</details>
<details>
  <summary>Image zooming</summary><br>
  <video src="https://user-images.githubusercontent.com/80542175/226197704-042a421a-831d-4acf-9898-3731604dba02.mov">
</details>
<details>
  <summary>Adding products to cart</summary><br>
  <video src="https://user-images.githubusercontent.com/80542175/226197715-ff6ae9b6-5317-461d-906c-c7a673e2135e.mov">
</details>
<details>
  <summary>Shopping bag, Checkout, Create order</summary><br>
  <video src="https://user-images.githubusercontent.com/80542175/226197767-ff6b2325-09d1-4107-b478-3da054a54608.mov">
</details>

<details>
  <summary>Order history</summary><br>
  <video src="https://user-images.githubusercontent.com/80542175/226198249-ffc84f2c-aa1a-4be3-9d6c-f6c8d5a9c51e.mov">
</details>
<details>
  <summary>Adding to cart from products list</summary><br>
  <video src="https://user-images.githubusercontent.com/80542175/226198278-5579431e-f93c-4e21-ab84-814d7d9f574f.mov">
</details>
<details>
  <summary>Adding to cart from Order history</summary><br>
  <video src="https://user-images.githubusercontent.com/80542175/226198287-82e01877-b133-450f-89ee-c36d661f5d24.mov">
</details>
<details>
  <summary>Buy now feature</summary><br>
  <video src="https://user-images.githubusercontent.com/80542175/226198294-b1d2f5c0-30e9-409b-956c-c87e37305b6b.mov">
</details>

<details>
  <summary>Profile changing</summary><br>
  <video src="https://user-images.githubusercontent.com/80542175/226198535-e39c9abb-d1c3-4cc7-a553-8ffb28304dcd.mov">
</details>
<details>
  <summary>Email changing</summary><br>
  <video src="https://user-images.githubusercontent.com/80542175/226198556-d495af0a-9dc1-4db7-9803-929b77b47946.mov">
</details>
<details>
  <summary>Password changing</summary><br>
  <video src="https://user-images.githubusercontent.com/80542175/226198563-05941cba-ed09-44c8-bd9c-5f330557bc82.mov">
</details>
