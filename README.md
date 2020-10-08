# README

* Ruby version: 2.6.1

* Configuration:
run: bundle install

(If you don't have bundler installed, first run: gem install bundler)

* Database setup
Make sure you install the pg gem:
    gem install pg
First, make sure you have postgres and then set up an user in postgres:
    sudo -u postgres psql
    -> create role yoestuveaqui with createdb login password 'WHATEVERPASSWORDYOUWANT';
run: rake db:setup
     rake db:migrate

If you run into the error "peer authentication failed", please view your pg_hba.conf file (located at /etc/postgresql/SOME_NUMBER/pg_hba.conf)
And the change the line that says:
    local   all             postgres                                peer
To:
    local   all             postgres                                md5

* How to run the test suite
TBD
* Services (job queues, cache servers, search engines, etc.)
TBD
* Deployment instructions
TBD