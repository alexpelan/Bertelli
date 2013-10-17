class LineItemsController < ApplicationController
  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @line_items }
    end
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/new
  # GET /line_items/new.json
  def new
    @line_item = LineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/1/edit
  def edit
    @line_item = LineItem.find(params[:id])
  end

  # POST /line_items
  # POST /line_items.json
  def create
    @bucket = current_bucket
    @performers = Array.new
    #get values from URL
    performer_id = params[:performer_id]
    name = params[:name]
    ticket_url = params[:ticket_url]
    image_url = params[:image_url]
    #look up performer by ID, if it doesn't already exist then create one
    begin
    	performer = Performer.find(performer_id)
	  rescue ActiveRecord::RecordNotFound
	 		performer = Performer.new
			performer.id = performer_id
		end
		
		performer.name = name
		performer.ticket_url = ticket_url
		performer.image_url = image_url
		performer.save
	
		
    @line_item = @bucket.line_items.build
    @line_item.performer_id = performer_id
    
    #load up performer data for display
   	@bucket.line_items.each do | line_item | 
   		@performers.push(Performer.find(line_item.performer_id))
   	end

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to search_path }
        format.js   {}
        format.json { render json: @bucket}
      else
        format.html { render action: "http://www.google.com" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /line_items/1
  # PUT /line_items/1.json
  def update
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      if @line_item.update_attributes(params[:line_item])
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to line_items_url }
      format.json { head :no_content }
    end
  end
end
