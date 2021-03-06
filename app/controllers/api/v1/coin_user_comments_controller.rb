class Api::V1::CoinUserCommentsController < ApplicationController
skip_before_action :authorized, only: [:index, :show]

    def create
    response = []
      @current_user = User.find_by(user_name: params[:username])
        symbols = Coin.all.map { |e| e.symbol }

         if symbols.include?(params[:symbol])
        @coin = Coin.find_by(symbol: params[:symbol])
         else
        @coin = Coin.create(symbol: params[:symbol])
         end

        @comment = CoinUserComment.create(
          coin_id: @coin.id,
          user_id: @current_user.id,
          comment: params[:comment]
        )

        @current_user.coin_user_comments.push(@comment)
        @coin.coin_user_comments.push(@comment)

        response.push(@coin.coin_user_comments)
        response.push(@current_user.user_name)
        render json: response
    end


def show
    symbols = Coin.all.map { |e| e.symbol }
    response = []

   if symbols.include?(params[:id])

    @coin = Coin.find_by(symbol: params[:id])
    response.push(@coin.coin_user_comments)
    response.push("")
    render json: response
  else
    @coin = "coin not found"
    response.push(@coin)
    response.push("")
    render json: response
   end


end

    private

    def coin_user_comments_params
     params.require(:coin_user_comments).permit!
    end


  end
