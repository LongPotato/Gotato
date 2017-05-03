# Gotato

Gotato is an online sales database, built for online resellers to manage sales data.

[View the live version here](https://red-moose-2689.herokuapp.com/)

Demo accounts:
```
  Seller:
    seller@example.com
    123456

  Manager:
    admin@example.com
    123456
```

## How does Gotato work?

Gotato ends the depedence on various applications to manage sales data.

This is a program that I wrote for a specific group of people, a rereseller team.

This reseller team used to use Excel for handling files, Skype for communicating and Facebook Messenger for placing orders. Now with Gotato, they can do all of that in one place, from managing sales data, receiving orders to having a chat right within their web browser.

##Highlighted Features:

* Authorization: Different types of accounts have different types of permissions to access the database.
* Activity Feed: Users within the same database can see each other activities.
* Automatic Report Generation.
* Smart Search.
* Mailing System.
* Instant Messaging System.

## Screenshots:

![1](https://raw.githubusercontent.com/LongPotato/Gotato/master/app/assets/images/sc1.jpg)

![2](https://raw.githubusercontent.com/LongPotato/Gotato/master/app/assets/images/sc3.jpg)

![3](https://raw.githubusercontent.com/LongPotato/Gotato/master/app/assets/images/sc4.jpg)

![4](https://raw.githubusercontent.com/LongPotato/Gotato/master/app/assets/images/sc2.jpg)

## Setup:

Want to contribute or try it out on your local machine?

1. Install Ruby & Rails (If necessary) & [Fork the repo](http://help.github.com/forking/).

2. Clone your new fork: `git clone git@github.com:YOUR-USERNAME/Gotato.git`

3. Change to the project directory: `cd gotato`

4. Run `bundle install` to install all the gems.

5. Make sure that you can run PostgresQL on your machine.

6. Run `rake db:create && rake db:migrate && rake db:seed` to setup the database.

7. Run `rails server` to get the server running. Access the website at `http://localhost:3000`


