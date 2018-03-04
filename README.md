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
$ mkdir -p /data/db
$ mongo
> show dbs
> use admin
> db.createUser({
  user: "root",
  pwd: "<password>",
  roles: [{ role: "dbAdminAnyDatabase", db: "admin" }]
})
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

Install gem `mongoid` and do:
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
Install gem `pg` and configure `config/database.yml`

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

##### 12.1 Generating models

```sh
$ rails generate model CamleCaseName
```

Presistable models (entities) must inherit from ```ActiveRecord``` class.

We do not need to define attributes in our models. By default, rails create methods for accessing the model's attributes based on the model's migration file.

##### 12.2 One-to-one Association
[Complete association reference](http://guides.rubyonrails.org/association_basics.html)

On the model class of the owner side (Student):

```ruby 
has_one(:card)
``` 

On the model class of the other side (Card):

```ruby
belongs_to(:student)
``` 

You also need to add foreign key to the ```belongs_to``` side in the migration file:

```ruby
...
	t.references(:student)
...
```

When you set ```student.card``` or ```card.student```, rails automatically saves the relationship in the database. Also if you set any of these to nil you will break the relationship.

##### 12.3 One-to-many Association
On the model class of the owner side (Course):

```ruby
has_many(:projects)
```

On the model class of the other side (Project):

```ruby
belongs_to(:course)
```

You also need to add foreign key to the ```belongs_to``` side in the migration file:

```ruby
...
	t.references(:course)
...
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

##### 12.4 Many-to-many Association

On the model class of one side (Student):

```ruby
has_and_belongs_to_many(:courses)
```

On the model class of the other side (Course):

```ruby
has_and_belongs_to_many(:students)
```

```has_and_belongs_to_many``` can also take additional parameters to configure the relationship:

```ruby
:join_table => 'table_name'
:class_name => 'ActualClassNameInCaseYouChangeTheRelationshipKey'
:foreign_key => 'column_name_in_table_for_actual_class'
```

We have to generate a migration to create join table for this relationship. Rails naming convention for the name of join table is:

```
first_table + _ + second_table
```
(in alphabetical order)

The migration file should look like this:

```ruby
def up
	create_table :courses_students, :id => false do |t|
		t.references(:student)
		t.references(:course)
	end 
	add_index(:courses_students, ['student_id', 'course_id'])
end

def down
	drop_table(:courses_students)
end
```
Again, If you perform any modification on objects in either side of such relationship, rails will instantly sync the database accordingly.

##### 12.5 Inheritance
Two main types of class inheritance:
- Single Table Inheritance
- Class Table Inheritance (https://github.com/mvdamme/dbview_cti)


##### 12.6 Creating and saving model objects

```ruby
m = ModelName.new
m = ModelName.new(hash to initialize attributes)

m.new_record? 
 # has it been saved in the database?

m.save

m = ModelName.create(hash to initialize attributes) 
 # this will call save itself after instantiation
```

##### 12.7 Finding model objects

```ruby
m = ModelName.find(id)
 # returns error if not found

m = ModelName.find_by_<column_name>(value)
 # returns nil if not found or the first record matching the search
 
ModelName.all
ModelName.first
ModelName.last
ModelName.where(hash)
ModelName.where([“where clause with ?s in the middle”, val1, val2, …])
 # where, order, offset, and limit are query methods available to ActiveRecord class.
```

**Named Scopes** are to make use of the above four methods but in a nicer way. For that, just add scopes to a Model:

```ruby
scope(:<name>, -> (params) {where(…)})
```

and then we use it like:

```ruby
ModelName.<scope_name>
```

##### 12.8 Updating model objects

```ruby
m = ModelName.find(id)
 # you can change and then save
 
m.update_attributes(hash)
 # this will change and save all at once
```

##### 12.9 Removing model objects

```ruby
m.destroy
```
#### 13. Rails Console
Rails gives a very strong command line interface to work with models directly. To do that, navigate to the root of your application and do:

```sh
$ rails console [environment_name (development is default)]
```

#### 14. Validation
Rails has some methods that adds validation to the models. The signature of almost all of these methods is:

```ruby
function_name(:attribute_to_check, {hash of options})
```
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

validates_associated(:association_name_to_check)

```
Global Options we can use on almost all of the above:

```ruby
:allow_blank
:allow_nil
:on => :create/:update/:save(default)
:if => :method_name 
	# a boolean returner function, indicating whether or not the object should be validated
```

There is another way to write validations called **Sexy Validation**: 

```ruby
validates(:attribute_to_check,
	:presence => {}, # or a boolean
	:numericality => {}, # or a boolean
	:length => {},
	:format => {},
	:inclusion => {},
	:exclusion => {},
 	:acceptance => {},
 	:uniqueness => {},
 	:confirmation => {})
```

Call ```.valid?``` on objects to check their validity. Call ```.errors``` on objects to see its errors. You can also add your own custom validation methods to the model:

```ruby
def :name_for_this_validation_method 
	# check validation criteria
	# finally do:
	errors.add(:attribute or :base, "msg") 
end
```

And use them on the model like:

```ruby
validate :method_name 
	# you can also add :on or :if options here
```

#### 15. Cookies and Sessions
To set a cookies and session variables:

```ruby
cookies[:username] = "john"
session[:username] => "john"
cookies[:username] = {:value => "", :expires => 1.week.from_now}
```

Session data can be stored in file, database, or we can use cookies to store them. Since we are sending information to the user's local machine we need a mechanism to check whether or not they are changed by anyone other than us. Rails use the secret key stored in ```config/initializers/secret_token.rb``` to validate the integrity of signed cookies. ```$ rake secret``` will produce new key for you which you can replace the old one with.

The configuration to make rails use cookies for storing sessions is stored in ```config/initializers/session_store.rb```

#### 16. RESTful Routes

To see all routes of your app, do:

```ruby
$ rake routes 
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
You can find routing configuration file in: ```config/routes.rb```

#### 17. Building a RESTful Rails API
First, you need to set permission for ajax calls from other domains. You need to get this [gem](http://github.com/cyu/rack-cors) installed: 

```sh
$ gem install rack-cors
```
Add this line to gemfile:

```ruby
gem 'rack-cors', :require => 'rack/cors'
```
Navigate to the root of your project and do:

```sh
$ bundle install
```

Add this code to ```config/application.rb```:

```ruby
config.middleware.insert_before 0, "Rack::Cors" do
	allow do
		origins '*'
		resource '*', :headers => :any, :methods => [:get, :post, :options] 
	end 
end
```

Then you need to add routes for your RESTful api:
Read [this blog](http://blog.ragnarson.com/2013/10/01/how-to-integrate-angularjs-with-rails-4.html) 

```ruby
namespace :api, :defaults => {:format => :json} do
	resources(:users, :only => [:create])
end
```

Then in controller actions you render json responses:

```ruby
render(:json => json_object, :status => 200)
# or
render(:nothing => true, :status => 200)
```
To customize the serialization of your models into json, include this in your gemfile:

```ruby
gem 'active_model_serializers'
```
Do:

```sh
$ bundle install
```

Now put the following code in ```config/initializers/active_model_serializers.rb```:

```ruby
ActiveSupport.on_load(:active_model_serializers) do
	# This prevents generating root nodes in json responses
	ActiveModel::Serializer.root = false 
	ActiveModel::ArraySerializer.root = false 
end
```

If you are working on a Rails-api, serializers are not loaded by default. Therefore, you need to put the following line in your application_controller:

```ruby
include ActionController::Serialization
```

Now generate and customize serializers for those models you need to serialize:

```sh
$ rails generate serializer User
```

Search for more details on the Internet for the things you can customize with serializers.

#### 18. Authentication
Install bcrypt gem. Add a column named ```password_digest``` on your users table. Then simply add ```has_secure_password``` in the User model. What it does, is it adds a virtual attribute named ```password``` to that model. It also adds validation to check if ```password``` and ```password_confirmation``` are present and then whether or not they match. So what you need to do is setting plain password on a new user object and call save. It will encrypt this password and save it in ```password_digest```.

Then to check whether or not a user can be authenticated with a given password, find the user and call ```.authenticate("given password")```. This will either return false or the user object itself.

If the authentication is successful, you need to mark the user as authenticated. You can do this by putting the logged in status in user's session.

If your application is only a rails api, you need to generate a Json Web Token instead of cookie session and send it back to user. To create this token, follow the instructions [here](https://github.com/jwt/ruby-jwt).

To check if user has logged in when they request for an action, first, add this method to ApplicationController:

```ruby
private

def confirm_logged_in 
	if <token is valid>
		return true
	else 
		render(:nothing => true, :status => 401)
		return false
	end
end
```

Now you have to add this line to all controllers to check if the user has logged in before an actions is actually run:

```ruby
before_action(:confirm_logged_in, {:except => [:action1, :action2])
# or
before_action(:confirm_logged_in, {:only => [:action3, :action4]})
# or the combination of both :only and :except
```


