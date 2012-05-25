require "heroku/command/base"

# clone a heroku app into your current working directory
#
class Heroku::Command::Clone < Heroku::Command::Base

  # clone PATH
  #
  # create a new app instance on heroku, that is built the same as an existing
  # app
  #
  # -d, --dest DEST # output info as raw key/value pairs
  #
  def index
    validate_arguments!

    dest = options[:dest]
    path = shift_argument

    #dest = extract_option('--dest')
    #path = extract_option('--path')

    # create a new app
    app_data = api.get_app(app).body
    hputs app_data.inspect

    git_repo = app_data['git_url']
    hputs git_repo

    hputs("git clone #{git_repo} #{path}/#{dest}")

    # clone the addons (databases, 3rd party services)
    addons_data = api.get_addons(app).body.map {|addon| addon["description"]}
    hputs addons_data.inspect

    # clone collaborators
    collaborators_data = api.get_collaborators(app).body.map {|collaborator| collaborator["email"]}
    hputs collaborators_data.inspect

    # clone custom configs
    # prompt for new domain names
    # pull git repo
    # deploy app

    vars = api.get_config_vars(app).body

  end

end
