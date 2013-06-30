DotNetNuke-PasswordReset
========================

Allows your users to quickly manage their passwords without the additional profile configuration modules. Also allows administrators to quickly change a user's password utilzing the SUserId querystring parameter.

### About
* Module allows are user to reset their password provided that they know their password password.
* An administrator can reset any specific user's password.

### Roadmap
* Email option to notify users when their password is reset.
* Add additional implementations for password types (Question & Answer, Hash)

### Requirements
* DotNetNuke Version 5.x

Note: I haven't confirmed running it on anything but 7.x but the API and install manifest is the same so it should work.

### Fun Facts
* This module is built as a website project. Therefore there is no .dll

### Screenshot

User changing their password.

![ScreenShot](https://dl.dropboxusercontent.com/u/10620012/DotNetNuke-PasswordReset-User.png)

Administrator changing a user's password.

![ScreenShot](https://dl.dropboxusercontent.com/u/10620012/DotNetNuke-PasswordReset-Admin.png)

