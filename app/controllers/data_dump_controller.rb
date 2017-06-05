class DataDumpController < ApplicationController
  def index
    @tgp_dump = TerminalGatePrice.order(:date)
    
    respond_to do |format|
      format.csv { render text: @tgp_dump.to_csv }
    end
  end
end
