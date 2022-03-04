require 'aws-sdk-sqs'

class Producer

  def initialize
    super
    @client = Aws::SQS::Client.new
  end

  def send_message(queue_url, body, attributes)
    @client.send_message(
      {
        queue_url: queue_url,
        message_body: body,
        message_attributes: attributes
      }
    )
  end

  def send_messages(queue_url, body, count)
    count.to_i.times do |idx|
      attributes = {
        "Seq" => { string_value: idx.to_s, data_type: "String" }
      }
      send_message(queue_url, body, attributes)
    end
  end

end

producer = Producer.new
if ARGV.length == 3
  producer.send_messages(*ARGV)
else
  puts "USAGE: ruby Producer.rb queue_url message_body count"
end