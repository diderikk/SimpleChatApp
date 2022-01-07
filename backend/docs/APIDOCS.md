# API Documentation

  * [BackendWeb.ChatController](#backendweb-chatcontroller)
    * [show](#backendweb-chatcontroller-show)
    * [page](#backendweb-chatcontroller-page)
  * [BackendWeb.SessionController](#backendweb-sessioncontroller)
    * [signin](#backendweb-sessioncontroller-signin)
    * [signup](#backendweb-sessioncontroller-signup)
    * [channel_token](#backendweb-sessioncontroller-channel_token)
  * [BackendWeb.UserController](#backendweb-usercontroller)
    * [chat_list](#backendweb-usercontroller-chat_list)
    * [create_chat](#backendweb-usercontroller-create_chat)
    * [accept_chat](#backendweb-usercontroller-accept_chat)
    * [decline_chat](#backendweb-usercontroller-decline_chat)

## BackendWeb.ChatController
### <a id=backendweb-chatcontroller-show></a>show
#### Gets chat when it exists

##### Request
* __Method:__ GET
* __Path:__ /api/chats/749
* __Request headers:__
```
accept: application/json
```

##### Response
* __Status__: 200
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLWOVW-TzpNS8AAAdB
```
* __Response body:__
```json
{
  "users": [
    "some name"
  ],
  "messages": [],
  "id": 749
}
```

#### Gets a chat with message

##### Request
* __Method:__ GET
* __Path:__ /api/chats/750
* __Request headers:__
```
accept: application/json
```

##### Response
* __Status__: 200
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLWTfC3BA_LggAAALi
```
* __Response body:__
```json
{
  "users": [
    "some name"
  ],
  "messages": [
    {
      "user": "some name",
      "isMe": true,
      "id": 62,
      "content": "some message",
      "at": "2022-01-07T16:55:41"
    }
  ],
  "id": 750
}
```

#### Gets a non-authorized chat

##### Request
* __Method:__ GET
* __Path:__ /api/chats/749
* __Request headers:__
```
accept: application/json
```

##### Response
* __Status__: 403
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLWJJIviwmUE4AAAcB
```
* __Response body:__
```json
{
  "error": "Forbidden"
}
```

### <a id=backendweb-chatcontroller-page></a>page
#### Gets next page from chat

##### Request
* __Method:__ GET
* __Path:__ /api/chats/751/1
* __Request headers:__
```
accept: application/json
```

##### Response
* __Status__: 200
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLWYu_sle4wVwAAAfh
```
* __Response body:__
```json
[]
```

## BackendWeb.SessionController
### <a id=backendweb-sessioncontroller-signin></a>signin
#### Signs in user with correct credentials

##### Request
* __Method:__ POST
* __Path:__ /api/signin
* __Request headers:__
```
accept: application/json
content-type: multipart/mixed; boundary=plug_conn_test
```
* __Request body:__
```json
{
  "password": "Password123",
  "email": "some.email@gmail1666.com"
}
```

##### Response
* __Status__: 200
* __Response headers:__
```
set-cookie: guardian_default_token=QTEyOEdDTQ.kQaqnQ7rq-jxt0-JHN-BiEPohminAQstWYEOzpJQ22cayKPN8y2QiJccnq4.OrUo-IpbPGygYIU-.FCMnXTfddEsrrM7QUfI9lgqTghzC_wk8wDCr5WWQAyxwQ9w71Hex2c117k0NLkuUL8hAgfgd64AvwEcJrVXhQQxRv_IhQTJqVhz53PMCXasd0o3X0NpV4x2WU7-FuAsYoAptj-KqkJNu1ut16NuK71tpf6mlgfKnCztQCLQLgn9PE7C4o5WABnFX4eqXtSxPorlHERnBNNj9joK_Y4h5V00JMHcpSP0-_27lXEnZLwysN4L4q2WOKeFqx3wTq5RGqAQG7SdmpU1baKMWZFI2yCwHzhP7KLKO-cUAqSYCtlwn_k6zVrmU6bDxW0tLOT4V2D06n2hpJvnzzDohK0CBHJOSbZFqEyK2S4uspMFa8vFX3_W82orZn84XDI-OpP1gDv2z2_hiGHtKVxIs5GUjgntGwJblMFM80F0-2qfL669ix-V9WhHb82VDHygU5GEZ-TwDCTAFF9XLzlCKkXsD9XmOtvBYtAvgDOcw1-F02iQxmiYfJg0k5Xjs3fM9.bmfnlLRS0VTrQxGd_o1ZAg; path=/; HttpOnly
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLV6B8yR7XWvwAAAKC
```
* __Response body:__
```json
{
  "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJCYWNrZW5kIiwiZXhwIjoxNjQxNTc0NzE2LCJpYXQiOjE2NDE1NzQ1MzYsImlzcyI6IkJhY2tlbmQiLCJqdGkiOiJlM2IwYTNmMy0xOGViLTQ4ZDEtYWMxNi1mMDg0NGM2MTc5MTYiLCJuYmYiOjE2NDE1NzQ1MzUsInN1YiI6IjI3OTEiLCJ0b2tlbl92ZXJzaW9uIjoxLCJ0eXAiOiJhY2Nlc3MifQ.0g2cs5JQ4RGYxc_vMyOpAXll-s-4Gf7eeYzmPnpL8y5RzhI92VJ0EMjkw_L-fItGrbUkigqqnz_XwH43fVsurA"
}
```

#### Sign in with wrong password

##### Request
* __Method:__ POST
* __Path:__ /api/signin
* __Request headers:__
```
accept: application/json
content-type: multipart/mixed; boundary=plug_conn_test
```
* __Request body:__
```json
{
  "password": "Password",
  "email": "some.email@gmail1538.com"
}
```

##### Response
* __Status__: 401
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLVSMzmjGY1xAAAAYh
```
* __Response body:__
```json
{
  "errors": {
    "detail": "Unauthorized"
  }
}
```

#### Signs in user when email does not exist

##### Request
* __Method:__ POST
* __Path:__ /api/signin
* __Request headers:__
```
accept: application/json
content-type: multipart/mixed; boundary=plug_conn_test
```
* __Request body:__
```json
{
  "password": "Password",
  "email": "wrong email"
}
```

##### Response
* __Status__: 401
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLV08MawApykMAAAJi
```
* __Response body:__
```json
{
  "errors": {
    "detail": "Unauthorized"
  }
}
```

### <a id=backendweb-sessioncontroller-signup></a>signup
#### Signs up user

##### Request
* __Method:__ POST
* __Path:__ /api/signup
* __Request headers:__
```
accept: application/json
content-type: multipart/mixed; boundary=plug_conn_test
```
* __Request body:__
```json
{
  "user": {
    "password": "Password123",
    "name": "some name",
    "email": "test@test.com"
  }
}
```

##### Response
* __Status__: 201
* __Response headers:__
```
set-cookie: guardian_default_token=QTEyOEdDTQ.cz3afF-szPpq852kOFVf28dRbPeme0Lt8A7IPaqwQa8ElK2IbSqw11RuvcM.05zBVPbkz8ONMmR3.9LSUPC0_xUii8sJqRCcUePHVpcAXnEaOqHqj-ac6SHBW-VkTUAbKvfgRwRuNHDj6FHJ5aCf0ynsa5a-BYN-zUDrQPc4tdVU-_esziSlLyV4OGPk3e1knihmDGRIIbGythX3pNPcXSXbAfSEwXlqKP11bnz1O7kHWkIfFG0pOZpw7ixaiQwjQOD4betPZfpd9rIz0C1YOq4MxT-p8pNZ3kNPjtK7BOMVeKoY4hRAbdQ98GwgoUv0sQ9sMhy2CRAYzQEbpf8N1BFx7X_juwApmewxELMxCiaAuD0IaK2D8M5wJM1NFGLgIo_sAKPzahJOE4xzdtwetINtqw6CnPLhvSzLd7xTbSN2X_MHyD4CpSS5pQIbH9RSeO_V3cxT1-ARI3E1JxCu4SOwnG7EPtDLaxYfp4UlfsP2NTkA-hHN04PEv54j-C1xM2Ojfle1Sh1Vay0Ccxg8Kl85v6IYg3zDLeb_yXV2Uzp0xGFZhRyn6bjF7m_iDK3ZChLTwt5w_.-snI6jJ2ZnN3NdzjEnS0YQ; path=/; HttpOnly
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLVcMWyM8XgCkAAAHi
```
* __Response body:__
```json
{
  "user": {
    "name": "some name",
    "id": 2787,
    "email": "test@test.com"
  },
  "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJCYWNrZW5kIiwiZXhwIjoxNjQxNTc0NzA5LCJpYXQiOjE2NDE1NzQ1MjksImlzcyI6IkJhY2tlbmQiLCJqdGkiOiIwMjAwOTVhMS0wZDFlLTQxZWItYWU0YS1mYWVlYWM2MTRjNzciLCJuYmYiOjE2NDE1NzQ1MjgsInN1YiI6IjI3ODciLCJ0b2tlbl92ZXJzaW9uIjoxLCJ0eXAiOiJhY2Nlc3MifQ.i6Sit5ygEb2WWnvTqJ2rvIr4IdmN-uKV-RmghtsdJJX6L3JkyEQ-pnBs22iHpuNAgb63xd0i_1e6YcqQQt_O6g"
}
```

#### Signs up user with invalid attributes

##### Request
* __Method:__ POST
* __Path:__ /api/signup
* __Request headers:__
```
accept: application/json
content-type: multipart/mixed; boundary=plug_conn_test
```
* __Request body:__
```json
{
  "user": {
    "password": null,
    "name": null,
    "email": null
  }
}
```

##### Response
* __Status__: 422
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLVrFg6d6BkLkAAAIi
```
* __Response body:__
```json
{
  "errors": {
    "password": [
      "can't be blank"
    ],
    "name": [
      "can't be blank"
    ],
    "email": [
      "can't be blank"
    ]
  }
}
```

#### Signs up user with a taken email

##### Request
* __Method:__ POST
* __Path:__ /api/signup
* __Request headers:__
```
accept: application/json
content-type: multipart/mixed; boundary=plug_conn_test
```
* __Request body:__
```json
{
  "user": {
    "password": "Password123",
    "name": "some name",
    "email": "some.email@gmail1602.com"
  }
}
```

##### Response
* __Status__: 422
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLVwBH5NUiGpQAAAZh
```
* __Response body:__
```json
{
  "errors": {
    "email": [
      "has already been taken"
    ]
  }
}
```

#### Signs up user with a bad password

##### Request
* __Method:__ POST
* __Path:__ /api/signup
* __Request headers:__
```
accept: application/json
content-type: multipart/mixed; boundary=plug_conn_test
```
* __Request body:__
```json
{
  "user": {
    "password": "pass",
    "name": "some name",
    "email": "test@test.com"
  }
}
```

##### Response
* __Status__: 422
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLVNAk0U9xu0AAAAXh
```
* __Response body:__
```json
{
  "errors": {
    "password": [
      "at least one digit or punctuation character",
      "at least one upper case character",
      "should be at least 8 character(s)"
    ]
  }
}
```

### <a id=backendweb-sessioncontroller-channel_token></a>channel_token
#### Gets a channel token

##### Request
* __Method:__ GET
* __Path:__ /api/chats/747/channel_token
* __Request headers:__
```
accept: application/json
```

##### Response
* __Status__: 200
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLWD-eAYxVa3EAAAah
```
* __Response body:__
```json
{
  "user_id": 2792,
  "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJCYWNrZW5kIiwiY2hhdF9pZCI6Ijc0NyIsImV4cCI6MTY0MTU3NDcxNywiaWF0IjoxNjQxNTc0NTM3LCJpc3MiOiJCYWNrZW5kIiwianRpIjoiN2RlODkyM2ItOTRjNy00MTdiLThmNzktZWI1MmYzYWQwOTljIiwibmJmIjoxNjQxNTc0NTM2LCJzdWIiOiIyNzkyIiwidHlwIjoiY2hhbm5lbCJ9.tY0ZEFsMHKc4RhHBZQVhpHgHnFpLj4wEtwVLSWQNwgVaermAtemkS5T0p6JjCP25wRPvHxi0vEhJmkFl6QhAmw"
}
```

## BackendWeb.UserController
### <a id=backendweb-usercontroller-chat_list></a>chat_list
#### Gets a users chats

##### Request
* __Method:__ GET
* __Path:__ /api/users/chats
* __Request headers:__
```
accept: application/json
```

##### Response
* __Status__: 200
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLU-EuWiCWR_EAAAVh
```
* __Response body:__
```json
{
  "invited_chats": [],
  "chats": [
    {
      "users": [
        "some name"
      ],
      "message": "",
      "id": 745
    }
  ]
}
```

### <a id=backendweb-usercontroller-create_chat></a>create_chat
#### Creates a new chat

##### Request
* __Method:__ POST
* __Path:__ /api/users/chats
* __Request headers:__
```
accept: application/json
content-type: multipart/mixed; boundary=plug_conn_test
```
* __Request body:__
```json
{
  "user_list": []
}
```

##### Response
* __Status__: 201
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLUWG0LkS_6ocAAAQB
```
* __Response body:__
```json
{
  "users": [
    "some name"
  ],
  "message": "",
  "id": 740
}
```

#### Creates a new chat with another user

##### Request
* __Method:__ POST
* __Path:__ /api/users/chats
* __Request headers:__
```
accept: application/json
content-type: multipart/mixed; boundary=plug_conn_test
```
* __Request body:__
```json
{
  "user_list": [
    "some.email@gmail1282.com"
  ]
}
```

##### Response
* __Status__: 201
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLU5Ej1H84DzYAAAUh
```
* __Response body:__
```json
{
  "users": [
    "some name",
    "some name"
  ],
  "message": "",
  "id": 744
}
```

#### Creates a new chat with a non-existing user

##### Request
* __Method:__ POST
* __Path:__ /api/users/chats
* __Request headers:__
```
accept: application/json
content-type: multipart/mixed; boundary=plug_conn_test
```
* __Request body:__
```json
{
  "user_list": [
    "not_a_user@gmail.com"
  ]
}
```

##### Response
* __Status__: 201
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLUbJHZeMKUUMAAARB
```
* __Response body:__
```json
{
  "users": [
    "some name"
  ],
  "message": "",
  "id": 741
}
```

### <a id=backendweb-usercontroller-accept_chat></a>accept_chat
#### Accept a chat invitation

##### Request
* __Method:__ PUT
* __Path:__ /api/users/invited_chats/742
* __Request headers:__
```
accept: application/json
```

##### Response
* __Status__: 200
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLUlJbAm5ldpsAAASh
```
* __Response body:__
```json
""
```

#### Accept non-existing a chat invitation

##### Request
* __Method:__ PUT
* __Path:__ /api/users/invited_chats/744
* __Request headers:__
```
accept: application/json
```

##### Response
* __Status__: 404
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLUvE0qlpDfjkAAATh
```
* __Response body:__
```json
""
```

### <a id=backendweb-usercontroller-decline_chat></a>decline_chat
#### Decline a chat invitation

##### Request
* __Method:__ DELETE
* __Path:__ /api/users/invited_chats/739
* __Request headers:__
```
accept: application/json
```

##### Response
* __Status__: 200
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLUQyiP7wSPmoAAAPB
```
* __Response body:__
```json
""
```

#### Decline non-existing a chat invitation

##### Request
* __Method:__ DELETE
* __Path:__ /api/users/invited_chats/747
* __Request headers:__
```
accept: application/json
```

##### Response
* __Status__: 404
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: FsgLVIActD4sEh0AAAXB
```
* __Response body:__
```json
""
```

