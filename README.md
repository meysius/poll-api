# poll-api
This repository contains a **complete RESTful Rails-api** along with a clean documentation which walks developers through all construction steps. If you wish to start with ruby on rails, this repository is a great resource for you.

### [AngularJS Front-End Repository](https://github.com/mefeghhi/poll-web)

# Ruby on Rails Cheat Sheet

## Definitions

* **Homebrew** is for downloading and installing open source apps on mac. It is an open source package manager. 
* **RVM** is a version manager for ruby which lets you have projects which work with different versions of ruby. 
* **RubyGems** is a package manager for installing plugins and libraries for use with ruby rails. 
* A **Gem** is a ruby code packed for easy distribution. RubyGems.org is a public gem repository.
* **Rails** itself is a gem.
* **Bundler** is a gem that helps your rails app to load the right ruby gems.
* **Rake** is a gem which will make tasks.


## Setup
* Install homebrew
* Install rvm
* Find out the latest versions of rails and ruby: http://ruby-lang.org, http://rubyonrails.org/
```
$ rvm get head
$ rvm list known
$ rvm install 2.3.6 (or the version you want)
$ rvm list
$ rvm --default use 2.3.6 (or the version you want)
$ gem install bundler
$ gem install rails (or specify a version: -v 5.0.1)
```
* You could have several rubies installed. For each, there could be several `gemsets` only one of which is active at a time.
```
$ gem list (gives list of gems in your active gemset)
$ gem update --system (update all gems)
$ rvm gemset list (list of gemsets for current ruby version)
```

## Create Project

```sh
$ cd /your/desider/path
$ rails new <name> (--api)?
```
## Install Gems
Whenever you need to install a gem, add to `Gemfile`:

```ruby
gem 'name'
```

Then do:

```sh
$ bundle install
```

If at some point some command did not work for your project you need to put ```bundle exec``` at front of it so that the command is executed in the context of the specific bundle of gems your project has.

## Database Setup
### MySQL
```
$ brew install mysql
```
At the end it will give you a command that make mysql launch at startup. 
You can always manually do:
```
$ brew services stop/start mysql
```
Set password for user root:
```
$ mysqladmin -u root password
```
Add `-p` if root already has a password and you want to change it.
Login to MySql, create database and a user:
```
$ mysql -u <user> -p
> show databases;
> create database my_db;
> grant all privileges on my_db.* to 'my_user'@'localhost' identified by 'my_pass'
```
Install `mysql2` gem and configure `config/database.yml`

### MongoDB
```
$ brew install mongodb
```
If mongodb is going to be accessed from outside of server, you need to create a user that has appropriate access on that specific db name
Set password for user root:
```
$ mongo
> show dbs
> use admin
> db.createUser({
  user: "root",
  pwd: "<password>",
  roles: [{ role: "dbAdminAnyDatabase", db: "admin" }]
})
```
Create a user for a specific db name and make that user owner of the db
```
> use my_db
> db.createUser({
  user: "my_user",
  pwd: "<password>",
  roles: ["dbOwner"]
})
```
On server, mongodb is usually protected by authentication.
If you have password for root:
```
mongo --port 27017 -u "root" -p "<password>" --authenticationDatabase "admin"
```
If you don't have password of root you need to comment out `security` and `authorization` in `/etc/mongod.conf`, restart the mongodb service and do the above steps. 

If you are making a new rails app add `--skip-active-record`. If you already have an app, delete any lines starting with `config.active_record` from `config/environments/development` and `config/environments/production` then open `config/application.rb` and replace `require 'rails/all'` with:
```
require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"
```
Install gem `mongoid`
Then do:
```
$ rails g mongoid:config
```
Configure `config/mongoid.yml` accordingly.
Put the following code in `~/.irbrc`:
```ruby
if Object.const_defined?('Rails') && Object.const_defined?('Mongoid')
	Mongoid.load!("#{Rails.root}/config/mongoid.yml")
end
```
## Postgresql

```
$ brew install postgresql
$ psql postgres
postgres=# \du
postgres=# \list
postgres=# CREATE ROLE my_user WITH LOGIN PASSWORD 'password';
postgres=# ALTER ROLE my_user CREATEDB;
postgres=# CREATE DATABASE my_db;
postgres=# GRANT ALL PRIVILEGES ON DATABASE my_db TO my_user;
postgres=# \connect my_db
postgres=# \dt
postgres=# \q
```
Create rails app with `--database=postgresql` or install gem `pg` and configure `config/database.yml`

## Rails Commands
* Run server
```
$ rails s (production)?
```
* Run console

```
$ rails c (production)?
```
* Help for generating stuff 
```
$ rails g 
```

## Views
* Insert ruby code in views:

```html
<% code %>
```

* Print value of an expression:

```html
 <%= expression %>
```

* Drop variables in strings:

```ruby
"the beginning ... #{var} ... the end"
```

* Generating links, images, forms, etc. using rails helpers:
```ruby
<%= image_tag('logo.png') %>
<%= link_to(name, target) %>
```
```target``` could be rails hash:

```ruby
{controller: 'x', action: 'y', some_param: 't', …}
```

### Layouts
You can create as much `html.erb` layouts as you wish in `views/layouts`. Then put `<%= yield %>` inside them to specify where you want html fragments to be rendered. In the controller class you need to specify `layout 'name without html.erb>'`. The default layout is called `application`.

### Partials
You can exclude similar html fragments from full templates and put them in a Partial file. Partials have `_` at the beginning of their name. The below code is used to yield a partial within a full template:

```ruby
<%= render partial: 'name_or_path', locals: {key: value, …}) %>
```

### Helpers 
Rails provide a very strong set of text, number, date and more helpers. Just search for whatever you want to do first, it is likely that a function already exists for that. You can also create custom helper functions to use in the views. There are also sanitize helpers. Consider using them. They are absolutely necessary.


## Assets
Put all asset files in `app/assets` for rails to be able to perform optimization processes for production environment. In development environment, rails directly uses asset files in `app/assets`. In production however, it will optimize all asset files and put them in `public/assets`. Different kind of assets are kept in different folders under `app/assets`. In all of them there is a manifest file called ```application```. The comments at the beginning of these files are the manifest and are used as input to the optimization process. If you wish to process asset files of a particular kind in a certain order, you must explicitly define this order. To do that, before `//= require_tree .` add `//= require <asset_name>`

## Controllers
### Rendering Templates
By default, each controller action renders a template in `views/<controller_name>/<action_name>.html.erb`.

To overwrite this default behavior, you can put render command in controller actions:

```ruby
render template: 'path/to/the/view/template'
```

The template being rendered has access to all instance variables of the action which are those with `@` at the beginning.

### Redirecting

```ruby
redirect_to controller: :x, action: :y
```
or 

```ruby
redirect_to 'google.com'
```
### Accessing Request Parameters

Request parameters can be accessed using:

```ruby
params[:key]
```

Rails 4 has a very strong way of passing parameters when instantiating model objects in controllers called **Mass Assignment**. You can create a safe parameter hash and pass it to model ```new``` or ```create``` methods using the ```require``` and ```permit``` methods:

```ruby
params.require(:user).permit(:username, :email, :password)
```

## Migrations
**Ignore if you are using mongoid** 
```
$ rails generate migration name_for_migration
```

In each migration ruby class, put an ```up``` and a ```down``` method. These methods must be in the mirror order of each other. 

In `up` method u can do:

```ruby
create_table :cards do |t| 
  t.string :name [, options]?	
  t.integer :student_id
  t.timestamps
end
drop_table :cards
add_column :cards, :name, :string
remove_column :cards, :name
add_index :cards, :student_id
add_index :cards, [:student_id, :course_id]
```

Available types include: 
```
binary, boolean, date, datetime, decimal, float, integer, string, text, time
```
Available options:
```
limit: size
default: value
null: true/false
precision: number (for decimal type only)
scale: number (for decimal type only)
```
Migration commands:
```
$ rails db:migrate:status
$ rails db:migrate
$ rails db:migrate VERSION=0
$ rails db:rollback [STEP=n]?
$ rails db:migrate(:up/down/redo)? VERSION=number
```
It is a good practice to add index on all foreign key columns and those columns which are used frequently to look up for a row of data.

If you have a typo in your migration code it will cause the migration run to abort and you will get stuck in a state where you can not either go up or down. In such states just comment those executed lines of the broken method and try running the migration method again.

## Models
### One-to-one Association
[Complete association reference](http://guides.rubyonrails.org/association_basics.html)

#### MySQL or Postgresql
```ruby
class Student < ApplicationRecord 
  has_one :card
end
class Card < ApplicationRecord
  belongs_to :student
end
```

You also need to add foreign key to the `belongs_to` side in the migration file:

```ruby
create_table :cards do |t| 
  t.integer :student_id
end
```

When you set `student.card` or `card.student`, rails automatically saves the relationship in the database. Also if you set any of these to nil you will break the relationship.

#### MongoDB
```ruby
class Student
  include  Mongoid::Document
  has_one :card 
  # OR
  embeds_one :card
end
class Card
  include  Mongoid::Document
  belongs_to :student
  # OR
  embedded_in :student
end
```

### One-to-many Association
#### MySQL or Postgresql
```ruby
class Course < ApplicationRecord 
  has_many :projects
end
class Project < ApplicationRecord
  belongs_to :course
end
```

You also need to add foreign key to the `belongs_to` side in the migration file:

```ruby
create_table :projects do |t| 
  t.integer :course_id
end
```

#### MongoDB
```ruby
class Course
  include  Mongoid::Document
  has_many :projects 
  # OR
  embeds_many :projects
end
class Project
  include  Mongoid::Document
  belongs_to :course
  # OR
  embedded_in :course
end
```

Then you can do things like:

```ruby
course.projects
course.projects << p
course.projects = [p1, p2, p3]
course.projects.destroy(p1) # destroys completely 
course.projects.delete(p1) # deletes from the list of projects
course.projects.clear
course.projects.empty?
course.projects.size
```
If you perform any modification on ```course.projects```, rails will instantly sync the database accordingly.

### Many-to-many Association
#### MySQL or Postgresql
```ruby
class Student < ApplicationRecord 
  has_and_belongs_to_many :courses
end
class Course < ApplicationRecord
  has_and_belongs_to_many :students
end
```

You have to generate a migration to create join table for this relationship. Rails naming convention for the name of join table is:

```
first_table + _ + second_table
```
(in alphabetical order)

The migration file should look like this:

```ruby
def up
  create_table :courses_students, :id => false do |t|
    t.integer :student_id
    t.integer :course_id
  end 
  add_index :courses_students, [:student_id, :course_id]
end

def down
  drop_table :courses_students
end
```

#### MongoDB
```ruby
class Student
  include  Mongoid::Document
  has_and_belongs_to_many :courses
end
class Course
  include  Mongoid::Document
  has_and_belongs_to_many :students
end
```

If you change the name of the relationship from its default name, you would have to configure the relationship in order for it to work as it should:
```ruby
join_table: :table_name
class_name: 'ActualClassNameInCaseYouChangeTheRelationshipKey'
foreign_key: :name_of_column_used_as_foreign_key
```

Again, If you perform any modification on objects in either side of such relationship, rails will instantly sync the database accordingly.

### Inheritance
Two main types of class inheritance:
- Single Table Inheritance
- Class Table Inheritance (https://github.com/mvdamme/dbview_cti)


### Create, Update, and Delete

```ruby
u = User.new
u.assign_attributes(hash) # Update without saving
u.update_attributes(hash) # Update and save
u.update_attributes!(hash) # Update and raise errors
u = User.new(hash) # initialize object
u.new_record? # has it been saved in the database?
u.save # save and return true false
u.save! # save and raise error
u = User.create(hash) # new and save 
u = User.create!(hash) # new and save and raise error
u.destroy
```

### Fetching Objects

```ruby
u = User.find_by(hash)
u = User.find_or_create_by(hash) # try to find, create if not found
User.all
User.first
User.last
User.where(hash)
User.where([“column_1 = ? and column_2 > ?”, a, b])
```
`where`, `order`, `offset`, and `limit` are query methods available to ActiveRecord class.

**Named Scopes** are to make use of the above four methods but in a nicer way. For that, just add scopes to a Model:

```ruby
scope :name, -> (params) { where(hash) }
```

and then we use it like:

```ruby
Model.scope_name
```
### Validation
List of validation functions:

```ruby
validates_presence_of 
# options -> :message

validates_length_of
# options -> :is, :minimum, :maximum, :within, :in, :wrong_length, :too_short, :too_long

validates_numericality_of 
# options -> :equal_to, :greater_than, :less_than, :greater_than_or_equal_to, :less_than_or_equal_to, :odd, :even, :only_integer, :message

validates_inclusion_of
# options -> :in, :message

validates_exclusion_of
# options -> :in, :message

validates_format_of
# options -> :with, :message

validates_uniqueness_of
# options -> :case_sensitive, :scope, :message

validates_acceptance_of
# options -> :accept, :message

validates_confirmation_of
# options -> :message
```
Global Options we can use on almost all of the above:

```ruby
:allow_blank
:allow_nil
on: :create/:update/:save(default)
if: :method_name 
# a boolean returner function, indicating whether or not the object should be validated
```

There is another way to write validations called **Sexy Validation**: 

```ruby
validates 
  :attribute_to_check,
  :presence => {}, # or a boolean
  :numericality => {}, # or a boolean
  :length => {},
  :format => {},
  :inclusion => {},
  :exclusion => {},
  :acceptance => {},
  :uniqueness => {},
  :confirmation => {}
```

Call `.valid?` on objects to check their validity. Call `.errors` on objects to see its errors. 

You can also add your own custom validation methods to the model:

```ruby
def :name_of_validation 
	# check validation criteria
	# finally do:
	errors.add(:attribute or :base, "msg") 
end
```

And declare this validation on the Model:

```ruby
validate :method_name 
# you can also add :on or :if options here
```

## Cookies and Sessions
To set a cookies and session variables:

```ruby
cookies[:key] = val
session[:key] = val
cookies[:username] = {
  value: val,
  expires: 1.week.from_now
}
```

Session data can be stored in file, database, or we can use cookies to store them. Since we are sending information to the user's local machine we need a mechanism to check whether or not they are changed by anyone other than us. Rails use the secret key stored in `config/initializers/secret_token.rb` to validate the integrity of signed cookies. 

`$ rake secret` will produce new key for you which you can replace the old one with.

The configuration to make rails use cookies for storing sessions is stored in `config/initializers/session_store.rb`

## RESTful Routes

To see all routes of your app, do:

```ruby
$ rails routes 
```

Below is the standard list of RESTful routes:
```html
| URL                  | HTTP Method | Controller Action | Description                        |
|----------------------|-------------|-------------------|------------------------------------|
| /subjects            | GET         | index             | Show all items                     |
| /subjects/new        | GET         | new               | Show new form                      |
| /subjects            | POST        | create            | Create an item                     |
| /subjects/:id        | GET         | show              | Show item with :id                 |
| /subjects/:id/edit   | GET         | edit              | Show edit form for item with :id   |
| /subjects/:id        | PATCH       | update            | Update item with :id               |
| /subjects/:id/delete | GET         | delete            | Show delete form for item with :id |
| /subjects/:id        | DELETE      | destroy           | Delete item with :id               |
```
You can find routing configuration file in: `config/routes.rb`

## Building a RESTful Rails API
First, install this [gem](http://github.com/cyu/rack-cors) following instruction in its repo.

Then you need to add routes for your RESTful API:
```ruby
namespace :api, :defaults => {:format => :json} do
  resources :users, :only => [:create]
end
```

Then in controller actions you render json responses:

```ruby
render json: obj, status: 200
# OR
render nothing: true, status: 200
```

## Authentication
### MySQL and Postgresql
* Install `bcrypt` gem. 
* Add a column named `password_digest` on your users table. 
* Then simply add `has_secure_password` in the User model. What it does, is it adds a virtual attribute named `password` to that model. It also adds validation to check if `password` and `password_confirmation` are present and then whether or not they match. 
* Set plain password on a new user object and call save. It will encrypt this password and save it in `password_digest`.
* Check if user's given password is correct:
```ruby
u = User.last
u.authenticate('give password') # returns false or user
```
### Mongoid
* Install `bcrypt` gem 
* Add the following code to your User model.
```ruby
class User
  include Mongoid::Document
  include BCrypt
  field :password_hash, type: String

  def password
    if !password_hash.nil?
      @password ||= Password.new(password_hash)
    end
  end

  def password=(new_password)
    if !new_password.blank?
      @password = Password.create(new_password)
    end
    self.password_hash = @password
  end
end
```
* Check if user's give password is correct:
```ruby
u = User.last
u.password == 'given password'
```
### After Password is Confirmed
Put the username of the logged in user in session

If your application is only a rails api, you need to generate a Json Web Token instead of cookie session and send it back to user. To create this token, follow the instructions [here](https://github.com/jwt/ruby-jwt).

To check if user has logged in when they request for an action, first, add this method to ApplicationController:
```ruby
private

def confirm_logged_in 
  if <token is valid>
    return true
  else 
    render nothing: true, status: 401
    return false
  end
end
```

Now you have to add this line to all controllers to check if the user has logged in before an actions is actually run:

```ruby
before_action :confirm_logged_in, except: [:action_1]
# OR
before_action :confirm_logged_in, only: [:action_3]
# OR a combination of both :only and :except
```

## Deploy on Ubuntu VPS
- Make an ubuntu user to use for deployment
```
$ sudo adduser deploy
$ sudo adduser deploy sudo
$ su deploy
```
- Install RVM
```
$ sudo apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
$ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
$ curl -sSL https://get.rvm.io | bash -s stable
$ source ~/.rvm/scripts/rvm
$ rvm install 2.3.6
$ rvm use 2.3.6 --default
```
- Install ca-certificates, nginx, curl, git 
```
$ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
$ sudo apt-get install -y apt-transport-https ca-certificates curl git-core nginx -y
```
- Now Nginx is a service
```
$ sudo service nginx start|stop|restart|status
```
- Install rails and bundler
```
$ gem install bundler
$ gem install rails -v 5.x.x
```
- Make a SSH key
```
$ ssh-keygen -t rsa
Enter This name: /home/deploy/.ssh/#{appname}_rsa
```
- Print this key, and add it to your repo keys
```
$ cat /home/deploy/.ssh/#{appname}_rsa.pub
```
- Open `~/.ssh/config` and put the following line
```
IdentityFile ~/.ssh/#{appname}_rsa
```
- Check if your access is set:
```
$ ssh -T git@github.com
or
$ ssh -T git@bitbucket.org
```
- Add to your gem file
```
group :development do
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
end
```
- Bundle
```
$ bundle install
```
- create capistrano files
```
cap install
```
- Edit Capfile and paste
```
require 'capistrano/setup'
require 'capistrano/deploy'
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/rvm'
require 'capistrano/puma'
install_plugin Capistrano::Puma

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
```
- Paste the following in `config/deploy.rb` and edit server_path, repo_url, application_name
```ruby
# Change these
server '200.122.181.42', port: 22, roles: [:web, :app, :db], primary: true

set :repo_url,        'git@github.com:mefeghhi/poll-api.git'
set :application,     'poll-api'
set :user,            'deploy'
set :puma_threads,    [4, 16]
set :puma_workers,    0

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
# set :linked_files, %w{config/database.yml}
# set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma
```
- Edit your firewall to let incoming connection to port 22 (80 and 443) 
- Create file `config/nginx.conf` and paste the following and edit `appname`
```
upstream puma {
  server unix:///home/deploy/apps/#{appname}/shared/tmp/sockets/#{appname}-puma.sock;
}

server {
  listen 80 default_server deferred;
  # server_name example.com;

  root /home/deploy/apps/#{appname}/current/public;
  access_log /home/deploy/apps/#{appname}/current/log/nginx.access.log;
  error_log /home/deploy/apps/#{appname}/current/log/nginx.error.log info;

  location ^~ /assets/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
  }

  try_files $uri/index.html $uri @puma;
  location @puma {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect off;

    proxy_pass http://puma;
  }

  error_page 500 502 503 504 /500.html;
  client_max_body_size 10M;
  keepalive_timeout 10;
}
```
- Issue deploy command from development machine
```
$ cap production deploy:initial
```
- Create a shortcut or (symbolic link) to `config/nginx.conf` in `sites-enabled` 
```
$ sudo rm /etc/nginx/sites-enabled/default
$ sudo ln -nfs "/home/deploy/apps/#{appname}/current/config/nginx.conf" "/etc/nginx/sites-enabled/#{appname}"
```
- Restart Nginx
```
$ sudo service nginx restart
```
You should now be able to point your web browser to your server IP and see your Rails app in action!
- If you make change to `config/nginx.conf`, commit, issue a deploy command: `$ cap production deploy` and restart nginx on the server: `sudo service nginx restart`
- You might need to add environment variables in production server to read db password or secret_key_base. To do so, add variables like below to `/etc/environment` and reboot the server:
```
VAR_NAME="value"
```
## Domain parking
read:
- [How to point your domain to DigitalOcean servers](https://www.digitalocean.com/community/tutorials/how-to-point-to-digitalocean-nameservers-from-common-domain-registrars)

- [How to point your DigitalOcean server to your domain](https://www.digitalocean.com/community/tutorials/an-introduction-to-digitalocean-dns)

## Setting up HTTPS
Read [steps for setting up lets encrypt](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-16-04)
