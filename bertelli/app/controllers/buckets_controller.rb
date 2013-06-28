class BucketsController < ApplicationController
  # GET /buckets
  # GET /buckets.json
  def index
    @buckets = Bucket.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @buckets }
    end
  end

  # GET /buckets/1
  # GET /buckets/1.json
  def show
  		set_tab :search
    @bucket = Bucket.find(params[:id])
    	   	@performers = Array.new
    	   	
    	   	#load up performer data for display
    	   	@bucket.line_items.each do | line_item | 
    	   		@performers.push(Performer.find(line_item.performer_id))
    	   	end
    		

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bucket }
    end
  end

  # GET /buckets/new
  # GET /buckets/new.json
  def new
    @bucket = Bucket.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bucket }
    end
  end

  # GET /buckets/1/edit
  def edit
    @bucket = Bucket.find(params[:id])
  end

  # POST /buckets
  # POST /buckets.json
  def create
    @bucket = Bucket.new(params[:bucket])

    respond_to do |format|
      if @bucket.save
        format.html { redirect_to @bucket, notice: 'Bucket was successfully created.' }
        format.json { render json: @bucket, status: :created, location: @bucket }
      else
        format.html { render action: "new" }
        format.json { render json: @bucket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /buckets/1
  # PUT /buckets/1.json
  def update
    @bucket = Bucket.find(params[:id])

    respond_to do |format|
      if @bucket.update_attributes(params[:bucket])
        format.html { redirect_to @bucket, notice: 'Bucket was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bucket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buckets/1
  # DELETE /buckets/1.json
  def destroy
   @bucket = current_bucket
   performer_id = params[:performer_id]
   
   
   @bucket.line_items.each do |line_item|
   	logger.debug("line item = " + line_item.performer_id.to_s() + " perf = " + performer_id.to_s())
   	if line_item.performer_id.to_s() == performer_id.to_s()
   		logger.debug("FOUND MATCH")
   		line_item.delete
   	end
   end
   

    respond_to do |format|
      format.html { redirect_to @bucket }
      format.json { head :no_content }
    end
  end
end
