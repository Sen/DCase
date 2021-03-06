DCase
=====

Current version: 0.3

DCase is a lightweight dns proxy which can help you get through firewalls.

Usage
-----------

First, make sure you have Ruby 2.0.

    $ ruby -v
    ruby 2.0.0p353

Install Shadowsocks.

    gem install dcase

Create a file named `config.yml`, with the following content.

    side: 'local or server'
    password: 'your password'
    port: '8440'
    server: 'remote server address'
    dns_list:
      - '8.8.8.8'
      - '8.8.4.4'

Explanation of the fields:

    side      Local or Server side
    server    Remote server address
    port      Remote server port
    password  Password, should be same in client and server sides
    dns_list  A dns server list, which will picked on server side

`cd` into the directory of `config.yml`. Run `dcase` on your server. To run it in the background, run
`nohup dcase -c ./config.yml > log &`.

On your client machine, `cd` into the directory of `config.yml` also, run `sudo dcase -c config.yml`.

Command line args
------------------

You can use args to override settings from `config.json`.

    sudo dcase -s local -r remote_server_ip_address -p remote_server_port -k your_password
    dcase -s server -p remote_server_port -k your_password -l 8.8.8.8,8.8.4.4

License
-------
MIT

Bugs and Issues
----------------
Please visit [issue tracker](https://github.com/Sen/DCase/issues?state=open)
