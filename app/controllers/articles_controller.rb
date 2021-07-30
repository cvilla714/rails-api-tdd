class ArticlesController < ApplicationController
  skip_before_action :authorize!, only: %i[index show]
  include Paginable

  def index
    paginated = paginate(Article.recent)
    render_collection(paginated)
  end

  def show
    article = Article.find(params[:id])
    render json: serializer.new(article)
  end

  def serializer
    ArticleSerializer
  end

  def create
    # article = Article.new(article_params)
    article = current_user.articles.build(article_params)
    # if article.valid?
    # we will figure that out
    article.save!
    # article.save
    render json: article, status: :created
  rescue StandardError
    render json: article, adapter: :json_api,
           #  serializer: ActiveModel::Serializers,
           #  serializer: ActiveModel::Serializer::ErrorSerializer,
           serializer: ErrorSerializer,
           status: :unprocessable_entity
  end
  # end

  def update
    article = current_user.articles.find(params[:id])
    # article = Article.find(params[:id])
    article.update!(article_params)
    render json: article, status: :ok
  rescue ActiveRecord::RecordNotFound
    authorization_error
  rescue StandardError
    render json: article, adapter: :json_api,
           serializer: ErrorSerializer,
           status: :unprocessable_entity
  end

  def destroy
    article = current_user.articles.find(params[:id])
    article.destroy
    head :no_content
  rescue StandardError
    authorization_error
  end

  private

  def article_params
    params.require(:data).require(:attributes)
          .permit(:title, :content, :slug) ||
      ActionController::Parameters.new
  end
end
