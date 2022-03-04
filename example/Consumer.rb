require 'aws-sdk-sqs'

class Consumer
  def initialize
    super
    @client = Aws::SQS::Client.new
  end

  def receive_message(queue_url, max_number_of_messages = 1, wait_time_seconds = 0)
    @client.receive_message(
      {
        queue_url: queue_url,
        max_number_of_messages: max_number_of_messages,
        wait_time_seconds: wait_time_seconds,
        message_attribute_names: ["All"]
      }
    )
  end

  def delete_message(queue_url, receipt_handle)
    @client.delete_message(
      queue_url: queue_url,
      receipt_handle: receipt_handle
    )
  end

end

consumer = Consumer.new
if ARGV.length > 0 and ARGV.length <= 3
  response = consumer.receive_message(*ARGV)
  response.messages.each do |message|
    puts message.message_id
    puts message.body
    puts message.message_attributes
    puts '----'
    resp = consumer.delete_message(ARGV[0], message.receipt_handle)
  end
else
  puts "USAGE: ruby Consumer.rb queue_url max_number_of_messages wait_time_seconds"
end