module Public::PostsHelper
  # タグによる投稿ごとの色分けのため
  def gradient_style(post)
    colors = post.post_emotions.map(&:color)
    return "" if colors.empty?

    # 複数の色を均等に分けるための計算
    percentage = 100.0 / colors.size
    gradient_colors = colors.each_with_index.map do |color, index|
      "#{color} #{(index * percentage).round}%, #{color} #{((index + 1) * percentage).round}%"
    end.join(", ")

    "border-top: 3px solid transparent; background: linear-gradient(to right, #{gradient_colors}); background-clip: border-box;"
  end
end
