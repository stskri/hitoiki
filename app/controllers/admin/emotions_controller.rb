class Admin::EmotionsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @emotions = Emotion.all
    @emotion = Emotion.new
  end

  def edit
    @emotion = Emotion.find(params[:id])
  end

  def create
    @emotion = Emotion.new(emotion_params)
    if @emotion.save
      redirect_to admin_emotions_path, notice: '感情タグを作成しました'
    else
      redirect_to new_admin_emotion_path, alert: '感情タグの作成に失敗しました'
    end
  end

  def update
    emotion = Emotion.find(params[:id])
    if emotion.update(emotion_params)
      redirect_to admin_emotions_path, notice: '編集しました'
    else
      redirect_to edit_admin_emotion_path(emotion), alert: '編集の保存に失敗しました'
    end
  end

  def destroy
    emotion = Emotion.find(params[:id])
    if emotion.destroy
      redirect_to admin_emotions_path, notice: '削除しました'
    else
      redirect_to admin_emotions_path, alert: '削除に失敗しました'
    end
  end


  private
  def emotion_params
    params.require(:emotion).permit(:name, :color)
  end

end
