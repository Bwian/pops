class TbrController < ApplicationController
  
  def index
  end
  
  def select
  end

  def log
    @log = ParseLog.new('/tmp/tbr.log')
  end
  
  def doit
    respond_to do |format|
      in_file = params[:filename]
      if in_file
        Thread.new do
          begin
            out_file = Tempfile.new('tbr')
            out_file.write(in_file.read)
            out_file.close

            Tbr.process(out_file.path, log: '/tmp/tbr.log', original: in_file.original_filename, replace: true)
            out_file.unlink
          ensure
            ActiveRecord::Base.connection.close
            Rails.logger.flush
          end
        end
        format.html { redirect_to(controller: 'tbr', action: 'log') }
      else
        flash.now.alert = "File must be supplied"
        format.html { render :select }
      end
    end
  end
  
end
