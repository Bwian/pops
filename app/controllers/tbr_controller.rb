class TbrController < ApplicationController
  
  def index
  end
  
  def select
  end

  def doit
    respond_to do |format|
      in_file = params[:filename]
      if in_file
        Thread.new do
          out_file = Tempfile.new('tbr')
          out_file.write(in_file.read)
          out_file.close

          Tbr.process(out_file.path, log: '/tmp/tbr.log')
          out_file.unlink
          ActiveRecord::Base.connection.close
        end
        flash.notice = "Processing started in background"
        format.html { render :select }
      else
        flash.now.alert = "File must be supplied"
        format.html { render :select }
      end
    end
  end
  
end
