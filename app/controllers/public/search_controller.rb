class Public::SearchController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @model = params[:model]
    @content = params[:content]
    @facility_type = params[:facility_type] # 絞り込み用のfacility_type
    
    if @model == "user"
      @records = User.search_for(@content)
    elsif @model == "post"
      @records = Post.search_for(@content)
      # 検索結果に対して絞り込み
      if @facility_type.present?
        @records = @records.where(facility_type: @facility_type)
      end
    end
  end
end
