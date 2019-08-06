require 'nokogiri'

def news
  %x(curl -O https://cedec.cesa.or.jp/2019/session)
  doc = Nokogiri::HTML(File.read('session'))
  doc.xpath('//div[@class="col-sm-12 col-md-10 session-right"]').map do |node|
    meta = node.xpath('.//div[@class="col-12 col-sm-5 col-md-7 meta"]').inner_text.gsub(/[\r ,]/, "").gsub(/\n+/, "/").split('/')
    meta_info = meta[1..-2].join('/')

    {
      title: node.xpath('./div[@class="session-title"]').inner_text.gsub(/[\r\n ,]/, ""),
      speaker: node.xpath('.//div[@class="media-body"]/div[@class="name"]').inner_text.gsub(/[\r ,]/, "").gsub(/\n+/, "/"),
      meta: meta_info,
      url: node.xpath('.//a[@class="d-inline-block btn-elinvar-detail"]').attribute("href").text
    }
  end
end

news.each do |n|
  puts "#{n[:title]},#{n[:speaker]},#{n[:meta]},#{n[:url]}"
end
