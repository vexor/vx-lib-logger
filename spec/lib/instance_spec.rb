require 'spec_helper'

require 'stringio'

describe Vx::Lib::Logger::Instance do

   before do
     @out = StringIO.new
     @log = Vx::Lib::Logger.get(@out)
     assert @log
   end

   [:fatal, :warn, :debug, :error, :info].each do |m|
     it "should write #{m} message" do
       @log.public_send(m, "send #{m}")
       text = "[#{m.upcase}] send #{m} :--: {\"thread_id\":#{tid},\"process_id\":#{pid}}\n"
       assert_equal get_out, text
     end
   end

   it "should write message with params" do
     @log.info "text message", param: :value
     text = "[INFO] text message :--: {\"thread_id\":#{tid},\"process_id\":#{pid},\"fields\":{\"param\":\"value\"}}\n"
     assert_equal get_out, text
   end

   it "should write message with object in params" do
     @log.info "text message", param: self
     assert get_out
   end

   it "should write message with exception in params" do
     @log.info "text message", exception: Exception.new("got!")
     text = "[INFO] text message :--: {\"thread_id\":#{tid},\"process_id\":#{pid},\"fields\":{\"exception\":[\"Exception\",\"got!\"],\"backtrace\":\"\"}}\n"
     assert_equal get_out, text
   end

   it "should handle block" do
     @log.handle "text message" do
       sleep 0.1
     end
     assert_match(/duration/, get_out)

     begin
       @log.handle "text message", key: :value do
         raise 'got!'
       end
     rescue Exception
     end

     body = get_out
     assert_match(/duration/, body)
     assert_match(/key/, body)
     assert_match(/value/, body)
     assert_match(/got\!/, body)
     assert_match(/backtrace/, body)
   end

   it "should dump invalid unicode key" do
     @log.info "Le Caf\xc3\xa9 \xa9", key: "Le Caf\xc3\xa9 \xa9"
     text = "[INFO] Le Café \xA9 :--: {\"thread_id\":#{tid},\"process_id\":#{pid},\"fields\":{\"key\":\"Le Café \xA9\"}}\n"
     assert_equal get_out, text
   end

   def get_out
     @out.rewind
     body = @out.read
     @out.rewind
     body
   end

   def tid
     Thread.current.object_id
   end

   def pid
     Process.pid
   end

end
