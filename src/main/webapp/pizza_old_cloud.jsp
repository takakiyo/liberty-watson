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
      integrationID: "67722d23-64e4-4960-94cf-13d2afe44b67", // The ID of this integration.
      region: "jp-tok", // The region your integration is hosted in.
      serviceInstanceID: "ab38750d-2e6a-4787-85dd-199a0688b489", // The ID of your service instance.
      onLoad: function(instance) { instance.render(); }
    };
  setTimeout(function(){
    const t=document.createElement('script');
    t.src="https://web-chat.global.assistant.watson.appdomain.cloud/versions/" + (window.watsonAssistantChatOptions.clientVersion || 'latest') + "/WatsonAssistantChatEntry.js"
    document.head.appendChild(t);
  });
</script>
</head>

<body>
<body style="background-color:#eeeeee">
</body>

</html>
