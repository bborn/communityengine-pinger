# $Id$
# CommunityEngine Post Pinger plugin
require 'thread'
require 'net/http'
require 'uri'
require 'xmlrpc/client'


class PostPingObserver < ActiveRecord::Observer
  observe :post
  VERSION = "$Rev$"
  SERVICES = [] 

  def after_create( post )  
    return unless post.is_live?

    SERVICES.each do |sinfo|
      next if sinfo[:category] && post.category && (post.category != sinfo[:section].to_s)
      next if sinfo[:tag] && post.tags && !post.tags.map{|t| t.name }.include?(sinfo[:tag].to_s)

      x = Thread.new(sinfo, post) do |info, post|
        case info[:type]
          when :rest
            rest_ping( info[:url], post )
          when :pom_get # ping-o-matic get
            pom_get_ping( info[:url], post, info[:extras] )
          else # :xmlrpc or default
            xmlrpc_ping( info[:url], post )
        end
      end
      x.join
    end
  end


  private
  def logger
    RAILS_DEFAULT_LOGGER
  end

  def pom_get_ping(url, post, extra_fields=[])
    logger.info "sending http get ping-o-matic ping -> #{url}"

    blog_url = APP_URL
    rss_url = "#{APP_URL}/site_index.rss"

    get_url = "%s?title=%s&blogurl=%s&rssurl=%s" % [ url, AppConfig.community_name, blog_url, rss_url ]
    extra_fields.each { |extra_url| get_url << "&" + extra_url }

    res = Net::HTTP.get( URI.parse( URI.escape( get_url ) ) )

    logger.info "http get ping result => '#{res}'"
  rescue
    logger.error "unable to send http get ping-o-matic ping -> #{url}"
  end


  def rest_ping(url, post)
    # see the weblogs rest ping spec @ http://www.weblogs.com/api.html
    logger.info "sending rest weblog ping -> #{url}"

    uri = URI.parse( url )
    post_info = { "name" => AppConfig.community_name,
                  "url" => APP_URL }

    raw_res = Net::HTTP.post_form( uri, post_info )

    raise Exception.new("http error") unless raw_res.kind_of? Net::HTTPSuccess
    res = raw_res.body

    logger.info "rest ping result => '#{res}'"
  rescue
    logger.error "unable to send rest weblog ping -> #{url}"
  end


  def xmlrpc_ping(url, post)
    # see the weblogs xmlrpc ping spec @ http://www.weblogs.com/api.html
    logger.info "sending xmlrpc weblog ping -> #{url}"

    cli = XMLRPC::Client.new2(url)
    title = AppConfig.community_name
    url = APP_URL
    
    feed_url = "#{APP_URL}/site_index.rss"
    tags = post.tags.join('|') # spec want's tags pipe delimeted

    res = cli.call2( 'weblogUpdates.extendedPing', title, url, feed_url, tags )

    logger.info "xmlrpc ping result => '#{res.inspect}'"
    # not sure if we care about the result...?
  rescue
    logger.error "unable to send xmlrpc weblog ping -> #{url}"
    # ignore ?
  end

end

require 'config'
