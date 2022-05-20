<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><!DOCTYPE html>
<html lang="ja">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Showcase ピザ</title>
    <img src="pizza.jpg" width="100%" height="auto" alt="pizza" />
<script>
  window.watsonAssistantChatOptions = {
      integrationID: "86994155-306e-4b1f-9d07-8fd2cd7b8387", // The ID of this integration.
      clientVersion: "6.2.0",
      region: "jp-tok", // The region your integration is hosted in.
      serviceInstanceID: "ab38750d-2e6a-4787-85dd-199a0688b489", // The ID of your service instance.
      onLoad: function(instance) { instance.render(); }
    };
  setTimeout(function(){
    const t=document.createElement('script');
    t.src="https://web-chat.global.assistant.watson.appdomain.cloud/versions/" + (window.watsonAssistantChatOptions.clientVersion || 'latest') + "/WatsonAssistantChatEntry.js"
    document.head.appendChild(t);
  });
</script></head>

<body>
<body style="background-color:#eeeeee">
<a href="ReadingComprehensionDemo.mov" target="_blank" >
<img src="./link.png" width="18" height="18"/>デモ動画
</a>
</body>

</html>
