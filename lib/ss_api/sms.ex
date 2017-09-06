defmodule SsApi.SMS do
  require Logger
  @template_xml """
  <?xml version="1.0" encoding="utf-8"?>
  <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
    <soap12:Body>
      <SingleSMSEngine xmlns="MessagingWS">
        <PortalCode>2735</PortalCode>
        <UserName>admin273511</UserName>
        <PassWord>1267137</PassWord>
        <Mobile>mobile_number</Mobile>
        <Message>text_msg</Message>
        <FlashSMS>true</FlashSMS>
        <ServerType>1</ServerType>
      </SingleSMSEngine>
    </soap12:Body>
  </soap12:Envelope>
  """
  @msg_template "سلام name\n" <> "لطفا کد زیر را وارد کنید\n"
  def send_sms(name, phone_number, token) do
    post_url = "http://messagingws.payamservice.ir/sendSMS.asmx"
    final_msg = String.replace(@msg_template, "name", name)
    token_text = final_msg <> token
    IO.puts(token_text)
    IO.puts(phone_number)
    msg = String.replace(@template_xml, "mobile_number", phone_number)
    msg = String.replace(msg, "text_msg", token_text)
    Logger.info(msg)
    res = HTTPoison.post(post_url, msg, "Content-Type": "application/soap+xml; charset=utf-8")
    IO.inspect(res)
  end
end
