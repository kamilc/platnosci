require 'digest/md5'
require 'net/http'
require 'net/https'
require 'rexml/document'

class PlatnosciController < ApplicationController
  include REXML
  
  protect_from_forgery :except => [:error, :success, :report]
  layout 'application', :except => [:error, :success, :report]
  
  def error
    flash[:error] = "Wystąpil bląd podczas przeprowadzania transakcji w serwisie platności.pl"
    redirect_to '/'
  end

  def success
    flash[:notice] = "Twoje zamówienie zostalo dodane do realizacji"
    redirect_to '/'
  end

  # metoda wykorzystywana przez platnosci.pl 
  # po kazdorazowej zmianie statusu transakcji
  def report
    
    # jesli dane sa niepoprawne to zwracamy platnosciom ciag znakow 'BAD_SIG'
    logger.info "@@@@@@@ Sprawdzam sig"
    logger.info "params[:sig] = #{params[:sig]}"
    logger.info "md5(...) = #{md5( params[:pos_id] + params[:session_id] + params[:ts] + Spree::Config[:key2] )}"
    render 'bad_sig' unless sig_ok?(params)
    logger.info "@@@@@@@ sig OK = #{sig_ok?(params).to_s}"
    logger.info "@@@@@@@ ts = #{params[:ts]}"   
    
    begin
      
      # laczymy sie poprzez protokol SSL - port 443
      http = Net::HTTP.new('www.platnosci.pl', 443)
      http.use_ssl = true
      args = { :pos_id => params[:pos_id], :session_id => params[:session_id], :ts => Time.now.to_f.to_s.gsub(/[.]/,'')[0,13] }
      path = "/paygw/UTF/Payment/get?pos_id=#{params[:pos_id]}&session_id=#{params[:session_id]}&ts=#{Time.now.to_f.to_s.gsub(/[.]/,'')[0,13]}&sig=#{sig(args)}"
      
      # GET!
      response = http.get(path, nil)
      
      logger.info "@@@@@@@ path = #{path}"
      logger.info "@@@@@@@ response.body = #{response.body}"
      
      doc = REXML::Document.new(response.body)
      
      if get_first(doc, '//response/status') == "OK"
        session_id = get_first(doc, '//response/trans/session_id').to_i
        trans_status = get_first(doc, '//response/trans/status').to_i
        
        order = Order.id_equals(session_id).first
        
        logger.info "@@@@@@@ Status #{description_of_status(trans_status)}"
        
        order.platnosci_status = description_of_status(trans_status)
        order.save!
        
        if order.platnosci_status == description_of_status(99)
          order.complete!
          order.pay!
        end
      else
        raise get_first(doc, '//response/error/message')
      end
    rescue
      render 'bad_sig'
      logger.info "@@@@@@@ Rescue: #{$!} #{$!.backtrace}"
    end
    
  end
  
  private 
  
  # Pobiera dane z doca dla path np. '//costam/cos/tam'
  def get_first(doc, path)
    XPath.first( doc, path ).text
  end
  
  # sprawdza czy sig sie zgadza dla wiadomosci z platnosci.pl 
  # dla url_online
  def sig_ok?(params)
    params[:sig] == md5( params[:pos_id] + params[:session_id] + params[:ts] + Spree::Config[:key2] )
  end
  
  def sig(params)
    md5( params[:pos_id] + params[:session_id] + params[:ts] + Spree::Config[:key1] )
  end
  
  def md5(text)
    Digest::MD5.hexdigest(text)
  end
  
  # zwraca opis statusu transakcji dla zadanego kodu statusu
  def description_of_status(trans_status)
    case trans_status
    when 1
      "nowa"
    when 2
      "anulowana"
    when 3
      "odrzucona"
    when 4
      "rozpoczęta"
    when 5
      "oczekuje na odbiór"
    when 7
      "platność odrzucona"
    when 99
      "platność odebrana - zakończona"
    when 888
      "blędno status - prosimy o kontakt"
    end
  end

end
