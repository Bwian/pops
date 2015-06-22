class TbrController < ApplicationController
  
  def index
  end
  
  def select
  end

  def log
    logpath = ENV['tbr_log'] || '/tmp'
    @log = ParseLog.new("#{logpath}/tbr.log")
    @session = params[:session] || params[:id] || 1
  end
  
  def reports   
    Dir.chdir(ENV['tbr_root'])
    @months = Dir.glob('20*').sort.reverse
  
    user = User.find(session[:user_id])
    @types = []
    @types << 'Administrator' if user.tbr_admin
    @types << 'Manager' if user.tbr_manager

    @reports = build_reports(@months[0],@types[0])
  end
  
  def report_select
    @reports = build_reports(params[:months],params[:user_type])
    respond_to do |format|
      format.js
    end
  end
  
  def report
    send_file(params[:report], 
      filename: File.basename(params[:report]),
      type: "application/pdf", 
      disposition: "inline"
    )
  end
  
  def go
    respond_to do |format|
      in_file = params[:filename]
      if in_file
        begin
          logpath = ENV['tbr_log'] || '/tmp'
          logger = Logger.new("#{logpath}/tbr.log")
        rescue Errno::ENOENT
          flash.now.alert = "Warning! Logpath #{logpath} not found - log cannot be displayed."
          format.html { render :select }
        end
        
        Thread.new do
          begin           
            Tbr.log = logger
            Tbr.log.info('Telstra bill processing started')
            
            out_file = Tempfile.new(in_file.original_filename)
            out_file.write(in_file.read)
            out_file.close
            
            tbr = Tbr::Processor.new( 
              output:   ENV['tbr_root'],
              original: in_file.original_filename,
              services: TbrService.services,
              logo:     "#{Rails.root}/app/assets/images/logo.jpg",
              replace:  true
            )
            tbr.process(out_file.path)
              
          rescue ArgumentError
            abort            
          rescue Encoding::UndefinedConversionError
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
  
  def build_reports(month,type)
    reports = []
    Dir.chdir("#{ENV['tbr_root']}/#{month}")
    
    case type
      when 'Administrator'
        summary = Dir.glob("Service*.pdf").map(&File.method(:realpath))[0]
        reports << ['Summary',summary] if summary
        
        Dir.glob('Details/*.pdf').map(&File.method(:realpath)).each do |f|
          reports << [File.basename(f).split[0],f]
        end
      
      when 'Manager'
        user = User.find(session[:user_id])
        group = TbrService.group(user.id)
        
        summary = Dir.glob("summaries/#{user.code}*").map(&File.method(:realpath))[0]
        reports << ['Summary',summary] if summary
        
        Dir.glob("Details/*.pdf").map(&File.method(:realpath)).each do |f|
          service = File.basename(f).split[0]
          reports << [service,f] if group.include?(service)
        end
    end
    
    reports
  end
end
