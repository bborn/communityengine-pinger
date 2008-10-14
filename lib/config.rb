# PostPingObserver::SERVICES << { :url => "http://rpc.pingomatic.com/", :type => :xmlrpc }
# PostPingObserver::SERVICES << { :url => "http://rpc.weblogs.com/pingSiteForm", :type => :rest }
# PostPingObserver::SERVICES << { :url => "http://pingomatic.com/ping/", :type => :weblogs_get, :extras => [ "chk_weblogscom=on&chk_blogs=on&chk_technorati=on&chk_feedburner=on&chk_syndic8=on&chk_newsgator=on&chk_feedster=on&chk_myyahoo=on&chk_pubsubcom=on&chk_blogdigger=on&chk_blogrolling=on&chk_blogstreet=on&chk_moreover=on&chk_weblogalot=on&chk_icerocket=on&chk_newsisfree=on&chk_topicexchange=on" ] }
#PostPingObserver::SERVICES << { :url => "http://localhost:3000/", :type => :xmlrpc }
#PostPingObserver::SERVICES << { :url => "http://rpc.technorati.com/rpc/ping", :type => :xmlrpc }
# PostPingObserver::SERVICES << { :url => "http://ping.syndic8.com/xmlrpc.php", :type => :xmlrpc }
# tag based ping example:
# PostPingObserver::SERVICES << { :url => 'http://a.ruby.tags.only.site', :type => :xmlrpc, :tag => 'ruby' } # this will only be hit when the article is tagged 'ruby'

# section based ping example:
# PostPingObserver::SERVICES << { :url => 'http://a.code.section.only.site', :type => :xmlrpc, :category => 'code' } # only sent if article in category named 'code' 
