# RedChairPGH

welcome to the show

## deployment

The way this application is deployed (simply uploading a zip to aws) combined with it's usage of sqlite3 puts it in sort of a weird scenario where unless we push new code *with* the production database, it'll get re-written. The way we solve this is to just download the current production database via ssh and package it with the updated code before a deploy.

It should be as easy as running `./util/package_build.sh` and uploading the resulting zip to the aws beanstalk control panel, AFTER you set the environment variable `RCPGH_ROOT` to the absolute path of the project root, and put the ssh credentials in `/util/env/key.pem`. The ssh credentials are not version controled!

#### key points

- at the moment the production instance is configured to only allow incoming ssh traffic from the ip address of fivestar's office. this can be re-configured via the aws control panels.
- they credentials used to authenticate the ssh traffic is not version controlled. if you need it ask michael w for it. worst comes to worst we can regen keys and reconfigure the instance to use the new keys. this can be done via the aws control panels.
- to use the scripts in the `/util` folder in aiding deployments you MUST set the environment variable `RCPGH_ROOT` to the root of the repo on your machine.
