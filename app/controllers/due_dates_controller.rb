class DueDatesController < ApplicationController
  before_action :set_due_date, only: [:show, :edit, :update, :destroy]

  def generate
    project_id = params[:project_id]
    project = project_id == '-1' ? Project.new : Project.find(project_id)
    data = params[:data].values.sort_by { |v| v['progress'].to_f }
    due_dates = data.map do |d|
      due_date = DateTime.parse(d['due_date'])
      progress = d['progress'].to_f

      name = "Week #{data.index(d)}"
      case progress
      when 0
        name = 'Start date'
      when 100
        name = 'End date'
      end

      DueDate.new(
        name: name,
        progress: progress,
        date: due_date,
        description: '',
        project_id: project.id
      )
    end

    project.due_dates = due_dates
    @project = project
    render partial: 'generate'
  end

  # GET /due_dates
  # GET /due_dates.json
  def index
    @due_dates = DueDate.all
  end

  # GET /due_dates/1
  # GET /due_dates/1.json
  def show
  end

  # GET /due_dates/new
  def new
    @due_date = DueDate.new
  end

  # GET /due_dates/1/edit
  def edit
  end

  # POST /due_dates
  # POST /due_dates.json
  def create
    @due_date = DueDate.new(due_date_params)

    respond_to do |format|
      if @due_date.save
        format.html { redirect_to @due_date, notice: 'Due date was successfully created.' }
        format.json { render :show, status: :created, location: @due_date }
      else
        format.html { render :new }
        format.json { render json: @due_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /due_dates/1
  # PATCH/PUT /due_dates/1.json
  def update
    respond_to do |format|
      if @due_date.update(due_date_params)
        format.html { redirect_to @due_date, notice: 'Due date was successfully updated.' }
        format.json { render :show, status: :ok, location: @due_date }
      else
        format.html { render :edit }
        format.json { render json: @due_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /due_dates/1
  # DELETE /due_dates/1.json
  def destroy
    @due_date.destroy
    respond_to do |format|
      format.html { redirect_to due_dates_url, notice: 'Due date was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_due_date
      @due_date = DueDate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def due_date_params
      params.require(:due_date).permit(:name, :description, :date, :progress, :project_id)
    end
end
