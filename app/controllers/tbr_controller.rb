class TbrController < ApplicationController
  
  def index
  end
  
  def select
  end

  def log
    @log = ParseLog.new('/tmp/tbr.log')
    @session = params[:session] || params[:id] || 1
  end
  
  def go
    respond_to do |format|
      in_file = params[:filename]
      if in_file
        Thread.new do
          begin
            Tbr.log = Logger.new('/tmp/tbr.log')
            Tbr.log.info('Telstra bill processing started')
            
            out_file = Tempfile.new(in_file.original_filename)
            out_file.write(in_file.read)
            out_file.close

            tbr = Tbr::Processor.new( 
              original: in_file.original_filename, 
              replace: true
            )
            tbr.process(out_file.path)
              
          rescue ArgumentError
            abort            
          rescue Encoding::UndefinedConversionError
            binding.pry
            Tbr.log.error("#{in_file.original_filename} is an invalid file type")
            abort
          rescue => e
            Tbr.log.error(e.msg)
            abort
          ensure
            out_file.unlink
            ActiveRecord::Base.connection.close
            Rails.logger.flush
          end
        end
        format.html { redirect_to(controller: 'tbr', action: 'log', id: 1) }
      else
        flash.now.alert = "File must be supplied"
        format.html { render :select }
      end
    end
  end
  
  private
  
  def abort
    Tbr.log.error('Telstra bill processing aborted')
  end
end
