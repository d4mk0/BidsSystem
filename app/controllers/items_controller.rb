class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :place_stake]

  # GET /items
  # GET /items.json
  def index
    @items = if params[:sort] == 'by_current_sum'
      Item.by_current_sum
    else
      Item.all
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
    @item.ends_at = Time.now + 10.minutes
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
    @item.user = current_user

    respond_to do |format|
      if @item.save
        format.html { redirect_to items_path, notice: 'Товар успешно создан' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to items_path, notice: 'Товар успешно изменен' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Товар успешно удален' }
      format.json { head :no_content }
    end
  end

  def place_stake
    stake = @item.create_stake(params[:stake][:sum].to_i, current_user)

    if stake.class == Stake
      flash[:notice] = "Ставка в размере #{stake.sum} на товар #{@item.name} успешно принята"
    else
      flash[:error] = stake
    end

    redirect_to items_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:start_sum, :name, :min_step, :ends_at, :image)
    end
end
