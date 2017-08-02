class HomeController < ApplicationController

  before_action :default_values

  def index
    @social = {"twitter": "Tweet", "facebook": "Share", "mail": "E-mail"}
    @articles = Article.all
  end

  def show
    @article = Article.friendly.find(params[:id])
    @comments = @article.comments.with_state([:draft, :published])
  end



  def create_email
    @new_user = User.new(user_params)

    if @new_user.valid?
       HardWorker.perform_async([@new_user.name, @new_user.email])
    end
  	respond_to do |f|
  		f.js { render layout: false }
  	end

  end


  def search
    @tag = params[:tag]
    @articles = Article.tagged_with(@tag)

  end

  def default_values
    @read_more = false
    if self.action_name == "index"
      @read_more = true

    end

  end


  private
  	def user_params
  		params.require(:user).permit(:name, :email)
  	end
end
