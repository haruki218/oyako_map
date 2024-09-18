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
      # ソートの適用
      if params[:latest]
        @records = @records.latest
      elsif params[:old]
        @records = @records.old
      elsif params[:highly_rated]
        @records = @records.highly_rated
      elsif params[:most_commented]
        @records = @records.most_commented
      else
        @records = @records.latest
      end
    end
  end
end
