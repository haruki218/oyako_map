class Public::HomesController < ApplicationController
  before_action :authenticate_user!, except: [:top]
  before_action :set_prefectures_by_region, only: [:main]
  
  def top
  end

  def main
    @posts = Post.where(facility_type: "play").order(created_at: :desc).limit(3)
    @commented_posts = Post.most_commented.limit(3)
  end
end
