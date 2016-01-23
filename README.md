## Definitions

**Homebrew** is for downloading and installing open source apps on mac. It is an open source package manager. 

**RVM** and **rbenv** are version managers for ruby. They make it possible for you to have projects which work with different versions of ruby. 

**RubyGems** is a package manager for installing plugins and libraries for use with ruby rails. 

A **RubyGem** or **Gem** is a ruby code packed for easy distribution. RubyGems.org is a public gem repository.

**Rails** is a gem which manages.

**Bundler** is a gem that helps your rails app to load the right ruby gems.

**Rake** is a gem which will make tasks.


## Setting Things up

### Environment 
install homebrew install rbenv via homebrew install ruby-build via homebrew put command eval “$(rbenv init -)” in ~/.bash_profile install latest version of ruby: find the latest version on ruby-lang.org and install it via this command: rbenv install 2.2.3 enter this command: rbenv rehash change global ruby version by this command: rbenv global 2.2.3 gem list gives the current locally installed gems, to update all gems do: gem update –system install bundler gem: gem install bundler and then: rbenv rehash install rails gem: gem install rails –no-ri –no-rdoc (these options forces gem not to download documentations which can take a lot of space) and then: rbenv rehash MYSQL brew install mysql at the end it will give you a command that make mysql launch at startup. you can always manually do: msyql.server start/stop/status login to mysql: mysql -u <user> -p set password for root: mysqladmin -u <user> password then it will ask you to enter password for this user. to make rails able to talk to mysql you need mysql2 gem: gem install mysql2

SUBLIME (for mac users) to make sublime open with subl command in terminal enter this command: ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/

Let us begin… Create New Project navigate to the directory you want to create the project inside it. Create a new rails web application: rails new <name> [-d mysql] Create a new rails api: rails-api new <name> [-d mysql] (rails-api is a gem, install it if you don’t already have it)

Bundler Bundler works with two files within our project: Gemfile and Gemfile.lock. Gemfile is for us to edit. Put whatever gem name your app would need and then for updating all gems navigate to the root of your app and do: bundle install if at some point some command did not work for your project you need to put bundle exec at front of it so that the command is executed in the context of the specific bundle of gems the project has.

DATABASE SETUP show databases; create database <name>; use <name>; queries … create new user for our database and grant privileges to it: grant all privileges on <dbname>.* to '<new_username>'@'localhost' identified by '<password>'

configure database by editing config/database.yml

Start the Webserver navigate to root of your app: rails server or rails s

Generate Entities for the Project navigate to root of your app: rails generate it will guide you through generating whatever type of entity you need

Structure app/controllers/concerns and app/models/concerns are for common code that can be shared throughout all controllers or models app/helpers contain ruby code that helps us with our views

Rendering Templates by default, each controller action renders a template in views/<controller_name>/<action_name>.html.erb to overwrite this default behaviour you can put render command in controller actions: render(:template => ‘path/to/the/view/template’) the template being rendered has access to all instance variables of the action which are those with @ at the beginning

Redirect redirect_to(:controller => ‘x’, :action => ‘y’) or redirect_to(“google.com”)

ERB in View Templates <% code %> <%= code %>

#{var} drop variables in strings <%= link_to(name, target) %> target could be rails hash: {:controller => ‘x’, :action => ‘y’, :page => ‘t’, …}

in the controller’s action we can access these params: params[:page]

For mass assigning attributes of an object put all attributes in an array with the name of object: params[:user][:username] params[:user][:email] params[:user][:password]

Rails can create a hash for us to pass to our model when we are instantiating the model: params.require(:user).permit(:username, :email, :password)

string.to_i to convert to integer <%= variable.inspect %> for debug

RAKE rake -T will list all available rake tasks. rake <taskname> will run the task. rake <taskname> RAILS_ENV=development run the task only within a particular environment

MIGRATIONS rails generate migration CamleCaseName will create migration in db/migrate in each migration ruby class put an up and a down method. these methods must be in a mirror order of each other.

in up method u can do: create_table :cards do |t| t.column(“name”, :type, options) t.type(“name”, options) t.references(:student) # this adds a column for foreign key with name “student_id” t.timestamps(:null => false) end

types: binary, boolean, date, datetime, decimal, float, integer, string, text, time

options: :limit => size :default => value :null => true/false (for decimal type only) :precision => number :scale => number

in down method u can do: drop_table :users to see schema and migration status: rake db:migrate:status to make all migrations up: rake db:migrate to make all migrations down: rake db:migrate VERSION=0 to go to a particular version of schema: rake db:migrate VERSION=number and there is also: rake db:migrate:up/down/redo VERSION=number

there are a lot of migration methods like create_table and drop_table out there… it is a good practice to add index on all foreign key columns and those columns which are used frequently to look up for a row of data add_index(:table_name, [‘column1_name’, ‘column2_name’]) for cross index add_index(:table_name, ‘column_name’) if you have a typo in your migration code it will cause the migration run to abort and you will get stuck in a state where you can not either go up or down. in these states just comment those executed lines of the broken method and try running the migration method again.

GENERATE MODELS rails generate model CamleCaseName

presistable models (entities) must inherit from ActiveRecord class by default we do not need to define attributes in our models, all table columns have corresponding attribute methods in the corresponding model ASSOCIATING MODELS guides.rubyonrails.org/association_basics.html

ONE-TO-ONE On the model class of the owner side (Student): has_one(:card) On the model class of the other side (Card): belongs_to(:student) You also need to add foreign key to the belongs_to side in the migration file When you set a student.card or card.student it automatically saves the relationship in the database. Also if you set any of these to nil you will break the relationship.

ONE-TO-MANY On the model class of the owner side (Course): has_many(:projects) On the model class of the other side (Project): belongs_to(:course) You also need to add foreign key to the belongs_to side in the migration file

course.projects course.projects << p course.projects = [p1, p2, p3] course.projects.destroy(p1) # destroys completely course.projects.delete(p1) # deletes from the list of photos course.projects.clear course.projects.empty? course.projects.size

If you perform any modification on course.projects, rails will instantly sync the database with those modifications.

MANY-TO-MANY On the model class of one side (Student): has_and_belongs_to_many(:courses) On the model class of the other side (Course): has_and_belongs_to_many(:students) has_and_belongs_to_many can also take additional parameters to configure the relationship: :join_table => ‘table_name’ :class_name => ‘ActualClassNameInCaseYouChangeTheRelationshipKey’ :foreign_key => ‘column_name_in_table_for_actual_class’ We have to create a migration to create join table for this relationship. Rails naming convention for the join table name is : first_table + _ + second_table in alphabetical order.

The up method for migration code looks like this: create_table :courses_students, :id => false do |t| t.references(:student) t.references(:course) end add_index(:courses_students, [‘student_id’, ‘course_id’])

Again, If you perform any modification on objects in either side of such relationship, rails will instantly sync the database with those modifications.

POLYMORPHIC ASSOCIATION Generate models for the base class and all of its subclasses. Put the following line in the migration file for the super class: t.references(:<super_ + name of superclass>, :polymorphic => true) add_index(:<name of table>, ['<super_ + name of superclass>_id', '<super_ + name of superclass>_type'], {:name => 'a name'}) This makes an id and a type column in the table of base class. In the model for superclass add: belongs_to(:<super_ + name of superclass>, :polymorphic => true) In the models for subclasses add: has_one(:<name of superclass>, :as => :<super_ + name of superclass>) or has_many(:<name of superclass>s, :as => :<super_ + name of superclass>)

WORKING WITH MODELS CREATING AND SAVING OBJECTS m = ModelName.new m = ModelName.new(hash to initialize attributes) m.new_record? # has it been saved in the database? m.save m = ModelName.create(hash to initialize attributes) # this will call save itself after instantiation

FINDING OBJECTS m = ModelName.find(id) # returns error if not found m = ModelName.find_by_<column_name>(value) # returns nil if not found or the first record matching the search ModelName.all, ModelName.first, ModelName.last ModelName.where(hash) ModelName.where([“where clause with ?s in the middle”, val1, val2, …]) where, order, offset, and limit are query methods available to ActiveRecord class.

named scopes are to make use of the above four methods but in a nicer way. For that, just add scopes to a Model: scope(:<name>, -> (params) {where(…)}) and then we will have ModelName.<scope_name>

UPDATING OBJECTS m = ModelName.find(id) # you can change and then save m.update_attributes(hash) # this will change and save all at once

REMOVING OBJECTS m.destroy

RAILS CONSOLE in the root of your application do: rails console [environment_name (development is default)]

LAYOUTS You can create as much html.erb layouts as you wish in views/layouts <%= yield %> this will then put html fragments of our templates. In the controller class you need to specify layout(“<name_without_html.erb>”) The default layout is called application.

PARTIALS You can exclude similar fragments from full templates and put them in a Partial file. Partials have “_” at the beginning of their name. The below code is used to yield a partial within a full template: <%= render(:partial => “name_or_path”, :locals => {:varname => value, …}) %>

HELPERS Rails provide a very strong set of text, number, date and more helpers. Just search for whatever you want to do first, it is likely that a function already exists for that. You can also create custom helper functions to use in the views. There are also sanitize helpers. Consider using them. They are absolutely necessary

ASSETS Put all asset files in app/assets for rails to be able to perform optimization processes for production environment. In development environment rails directly uses asset files in app/assets. In production however, it will optimize all asset files and put them in public/assets. Different kind of assets are kept in different folders under app/assets. In all of them there is a manifest file called application. The comments at the beginning of these files are the manifest and are used as input to the optimization process. If you wish to process asset files of a particular kind in a certain order, you must explicitly define this order. before //= require_tree . add: //= require <asset_name>

The right way to generate html tags for assets: <%= stylesheet_link_tag(‘application’, :media => ‘all’) %> <%= javascript_include_tag(‘application’) %> <%= image_tag(‘logo.png’) %> Search for more details about each.

VALIDATION Rails has some methods that adds validation to the models. The signature of almost all of these methods is: function_name(:attribute_to_check, {hash of options}) List of validation functions:

validates_presence_of options: :message

validates_length_of options: :is, :minimum, :maximum, :within, :in, :wrong_length, :too_short, :too_long

validates_numericality_of options: :equal_to, :greater_than, :less_than, :greater_than_or_equal_to, :less_than_or_equal_to, :odd, :even, :only_integer, :message

validates_inclusion_of options: :in, :message

validates_exclusion_of options: :in, :message

validates_format_of options: :with, :message

validates_uniqueness_of options: :case_sensitive, :scope, :message

validates_acceptance_of options: :accept, :message

validates_confirmation_of options: :message

validates_associated(:association_name_to_check)

Global Options we can use on almost all of the above: :allow_blank, :allow_nil, :on => :create/:update/:save(default) :if => :method_name (a boolean returner function, indicating whether or not the object should be validated)

there is another way to write validations called “sexy validation”: validates (:attribute_to_check, :presence => {} or boolean, :numericality => {} or boolean, :length => {}, :format => {}, :inclusion => {}, :exclusion => {}, :acceptance => {}, :uniqueness => {}, :confirmation => {})

Call .valid? on objects to check their validity. Call .errors on objects to see its errors. You can also add your own custom validation methods to the model: def :name_for_this_validation_method check validation criteria and finally do: errors.add(:attribute or :base, “msg”); end And then declare them to be validation methods on the model: validate :method_name (you can also add :on or :if options here)

COOKIES & SESSION Incredibly simple, to set a cookie: cookies[:username] = “john”, session[:username] => “john” or cookies[:username] = {:value => “”, :expires => 1.week.from_now} Session data can be stored in file, database, or we can use cookies to store them. Since we are sending information to the user’s local machine we need a mechanism to check whether or not they are changed by anyone other than us. Rails use the secret key stored in config/initializers/secret_token.rb to validate the integrity of signed cookies. rake secret will produce new key for you which you can replace the old one with it.

Now, the configuration to make rails use cookies for storing sessions is stored in config/initializers/session_store.rb

RESTFUL ROUTES

To see all routes of your app, do: rake routes Below is the standard list of restful routes, try to use these routes in as much cases as you can:

URL HTTP Method Controller Action Description /subjects GET index Show all items /subjects/new GET new Show new form /subjects POST create Create an item /subjects/:id GET show Show item with :id /subjects/:id/edit GET edit Show edit form for item with :id /subjects/:id PATCH update Update item with :id /subjects/:id/delete GET delete Show delete form for item with :id /subjects/:id DELETE destroy Delete item with :id

To configure routes go to: config/routes.rb

Building a RESTful Rails API First, you need to set permission for ajax calls from other domains. (github.com/cyu/rack-cors) To do this: Install rack-cors gem: gem install rack-cors Add this line to gemfile: gem 'rack-cors', :require => 'rack/cors' Do: bundle install Add this code to config/application.rb: config.middleware.insert_before 0, “Rack::Cors” do allow do origins '*' resource '*', :headers => :any, :methods => [:get, :post, :options] end end

Then you need to add routes for your RESTful api: (blog.ragnarson.com/2013/10/01/how-to-integrate-angularjs-with-rails-4.html) namespace :api, :defaults => {:format => :json} do resources(:users, :only => [:create]) end

Then in controller actions you render json responses: render(:json => json_object, :status => 200) or render(:nothing => true, :status => 200)

To customize the serialization of your models into json: Include this in your gemfile: gem 'active_model_serializers' Do: bundle install Put the following code in config/initializers/active_model_serializers.rb:

ActiveSupport.on_load(:active_model_serializers) do # This prevents generating root nodes in json responses ActiveModel::Serializer.root = false ActiveModel::ArraySerializer.root = false end

If you are working on a rails-api, serializers are not loaded by default. So you need to put the following line in your application_controller: include ActionController::Serialization

Now generate and customize serializers for those models you need to serialize: rails generate serializer User

Search for details of the things you can customize in the internet.

AUTHENTICATION include bcrypt gem file name in your gemfile and then navigate to the root of your app and do a: bundle install You need to have a column named password_digest on your users table. Then simply add has_secure_password in the User model. Done. What it does is it adds a virtual attribute named “password” to the that model. It also adds validation to check if password and password_confirmation are present and then whether or not they match. So what you need to do is: Set plain password on a new user object and call save. It will encrypt this password and save it in password_digest.

Then to check whether or not a user can be authenticated with a given password, find the user and call .authenticate(“given password”). This will either return false or the user object itself.

If the authentication is successful, you need to mark the user as authenticated. You can do this by setting a cookie.

If your application is only a rails api, you need to generate a Json Web Token instead of cookie and send it back to user. To create this token, follow the instructions here: github.com/jwt/ruby-jwt

How to check if user has logged in when they request for an action. First, add this method to ApplicationController:

private

def confirm_logged_in if <token is valid> return true else render(:nothing => true, :status => 401) return false end end

Now you have to add this line to all controllers to check if the user has logged in before its actions is actually run.

before_action(:confirm_logged_in, {:except => [:action1, :action2], :only => [:action3, :action4]})
