class Admin::SearchController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @model = params[:model]
    @content = params[:content]
    
    if @model == "user"
      @records = User.search_for(@content)
    elsif @model == "post"
      @records = Post.search_for(@content)
    end
  end
end
