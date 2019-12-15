./ngrok http -host-header="0.0.0.0:3000" 3000
でlocalhostにアクセスできるようにする。

表示されたHTTPSのドメインを+callbackでWebhookに登録。

HTTPSのIPアドレスは毎回変わるので注意。
→変更されたらWebhookのIPを変更すること

デプロイ後はherokuのconfig　setを忘れずに

request

{"events":[{"type":"message","replyToken":"c81ebd92e3cd4bafaad58a921ebbd4c3","source":{"userId":"Uda91f87e1310e27649b2878c0f6b6658","type":"user"},"timestamp":1576377050894,"message":{"type":"text","id":"11086392092431","text":"なら"}}],"destination":"U2c01744eb8820c9ac00ccf4103b1263a"}


