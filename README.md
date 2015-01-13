# Test Double Present™

[![Stories in Ready](https://badge.waffle.io/testdouble/present.png?label=ready&title=Ready)](http://waffle.io/testdouble/present)


This is an open source application for tracking activities on a weekly billing model and generating invoices via the Harvest API.

## Do you bill clients on a weekly rate?

We wrote Present because [test double](http://testdouble.com) bills (almost all) our clients on a weekly rate, but pretty much every T&E system only supports hourly billing. Our goal is to have a system to track our activity for generating invoices with a minimal amount of friction. The system also supports clients billed hourly.

![screen shot 2014-11-02 at 12 00 25 am](https://cloud.githubusercontent.com/assets/79303/4874205/e5ea1010-6244-11e4-96e9-cbbec677a12b.png)

A few features and aspects of the app:

* Weekly-rate projects, each entry tracking absence/half-day/full-day
* Hourly-rate projects, tracking numeric hours
* Biweekly billing cadence
* Users mark when their time is ready to be invoiced to their client(s)
* Lists invoices that need to be sent, along with any problems with the invoicing period's timesheets
* Generates invoices and sends them to Harvest
* Tracks location worked, each user with a default location that can be overridden for each entry
* Tracks holiday & vacation time

There are a few values hard-coded into the application specific to test double, but could otherwise be deployed and used by other organizations. If you're interested in using Present and would like to chat about it or see a demo of it in action, please get in touch with us [by e-mail](mailto:hello@testdouble.com)!

## Getting up and running

You'll need postgres up & running. You'll also need a whole bunch of environment variables set:

``` bash
export PRESENT_GITHUB_CLIENT_SECRET=""
export PRESENT_GITHUB_CLIENT_ID=""
export PRESENT_WEEKLY_RATE=""
export PRESENT_HOURLY_RATE=""
export PRESENT_ADMIN_GITHUB_IDS="username1,username2"
export PRESENT_HARVEST_SUBDOMAIN=""
export PRESENT_HARVEST_USERNAME=""
export PRESENT_HARVEST_PASSWORD=""
```

As implied above, you'll need a Github app with a valid callback URL and a Harvest account (I use `ngrok` with a set hostname for this).

Finally, you can go through a pretty standard Ruby dance of setting up a rails app:

```
$ bundle install
$ rake db:create db:migrate db:seed
$ ./script/start.dev
```
