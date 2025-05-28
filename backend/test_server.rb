require 'webrick'

server = WEBrick::HTTPServer.new(Port: 3000)

server.mount_proc('/api/v1/jobs') do |req, res|
  res.content_type = 'application/json'
  res.body = '[{"id":"1","title":"測試職缺","company":{"name":"測試公司"},"min_salary":50000,"max_salary":80000}]'
end

trap('INT') { server.shutdown }
server.start
