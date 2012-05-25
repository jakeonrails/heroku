require "heroku/command/base"

# clone a heroku app into your current working directory
#
class Heroku::Command::Clone < Heroku::Command::Base

  # clone NEWAPP
  #
  # create a new app instance on heroku, that is built the same as an existing
  # app
  #
  def index
    new_app = shift_argument

    validate_arguments!


    # create a new app
    app_data = api.get_app(app).body
    hputs app_data.inspect

    git_repo = app_data['git_url']
    hputs("git clone #{git_repo} #{new_app}")

    hputs("cd #{new_app}")

    # use the source app's stack
    stack = app_data["stack"]

    # use the source app's addons
    addons = api.get_addons(app).body.map {|addon| addon["name"]}.join(",")

    hputs("heroku create #{new_app} --stack #{stack} --addons #{addons}")

    # remove the origin that git created during cloning
    hputs("git remote rm origin")

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
