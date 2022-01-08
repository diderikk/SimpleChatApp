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
* __Path:__ /api/chats/882
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
x-request-id: Fshm89OI9NDHYZAAAAaC
```
* __Response body:__
```json
{
  "users": [
    "some name"
  ],
  "messages": [],
  "id": 882
}
```

#### Gets a chat with message

##### Request
* __Method:__ GET
* __Path:__ /api/chats/880
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
x-request-id: Fshm8sRYUPzpNS8AAAcB
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
      "id": 83,
      "content": "some message",
      "at": "2022-01-08T20:54:17"
    }
  ],
  "id": 880
}
```

#### Gets a non-authorized chat

##### Request
* __Method:__ GET
* __Path:__ /api/chats/880
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
x-request-id: Fshm8jzad4omUE4AAAah
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
* __Path:__ /api/chats/881/1
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
x-request-id: Fshm80wUKAQ_LggAAAfh
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
  "email": "some.email@gmail1411.com"
}
```

##### Response
* __Status__: 200
* __Response headers:__
```
set-cookie: guardian_default_token=QTEyOEdDTQ.BRtOe4rPIrrwpC7KXV5l9xJHEYhFV9GPpVhzgLPljgUXehfS9NmV_5J08cM.atdFx4mN0Qtioa7k.UhCu2M2K2TwE68F0ml_1oYRHHnvH7vlvjR9VeaG5iEb67iw5McZoru6dOWlw6DMl35lu2gMu-Ma6R9Bslvwza5juhaPd8Bmykq4YKXZHw3bJLacX4hNOCcVX_8IBKuUxFVuOXYtnhORQD9GG45mX-QyqfrwkolGDTUe7lLx_wwx0cAZE_8LAiZr8QQL6nRHvcrl_sR2OxlcSraCkdvUkKBpVFeMdlozl2Hqi7mv3UXYCtP2QahZWzOeQujUK2iSc1--ZKGoLWMIWg-WrlNRu7EmPMK83jPeEiZ2IC-WdiXEVoNzS6cfo0PC9pPRyp8Z-7Ea9kpVtsIBie3nsiHFGp1cK0l-kOgNKAZPXXUo2F6TXiGDn97c9JS8opU8DGzB_owRkcSVHezLVNJkUCgIgoFD-QovhM7ZnjSApKM3qaqafkkd6ERNlO-9ZjuzTl0zDJlh1izqFGgX1lXcJcwI80g1H5Jav7cmVIdZ4JDATkdZjqN9joBwR_z2g6cRh.elRXz0g8xZPQV6gjjVuT8Q; path=/; HttpOnly
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: Fshm79ol1NkiGpQAAAWi
```
* __Response body:__
```json
{
  "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJCYWNrZW5kIiwiZXhwIjoxNjQxNjc1NDI1LCJpYXQiOjE2NDE2NzUyNDUsImlzcyI6IkJhY2tlbmQiLCJqdGkiOiI5YTM0YTIzMi1kMTllLTQ4NjctYTRhMi00MTllZjlkMTIyZDEiLCJuYmYiOjE2NDE2NzUyNDQsInN1YiI6IjMxOTAiLCJ0b2tlbl92ZXJzaW9uIjoxLCJ0eXAiOiJhY2Nlc3MifQ.FB_umJOGPnnnsHHQQ914Hkzp7C3ib8wNuQHMuYR-uP07cPMIr5MzVSp4fXL-_46ZoFxT82Zahby0RK7mMeLbQw"
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
  "email": "some.email@gmail1539.com"
}
```

##### Response
* __Status__: 401
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: Fshm8XCXalRVa3EAAAYi
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
x-request-id: Fshm75ZVsGSBkLkAAAVi
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
set-cookie: guardian_default_token=QTEyOEdDTQ.CyiQQ4ktCJP-JlTePUlHszBp8sg3a7EG6hhktJRNMPziDcD4jnB6FkXP4vM.LRDXKeqa9eg7SQ1h.MJ__vLj8dsiFCHEKqHBQiMtEdMx9ihnTee5CF93aCvtxrnH0XDUsZ3XguWWUSpCzo47KdvjvmrBimBCIzzC_50FxGxVLsLiaIkjXcq_TxPpmAvbop7NVrF6LQRMf52tubZ2OB9vMuGWyMCXmy1i5Pu2XnqT__EgICRazb7lXq6Qg3M2lOomJNECoCZwqHgX0E4ri1mbpr1aNyCVHTaiyBeZQwK9BG2Qjm7_oNfiC6JK7T8eF9tRiMPCLUmItlBg0KmwfKlQOFSkIophUDZwCKkoaPTWjHgrqIlXmQZiEGwhIu7Uetvyozb8GnsFiyt5iKjyWWRnaLe-HnC-NvCC9RfffdmlRYu7UXtbAHRDyy2L1Sk8PLHfZIWZE4-_d443bDc4ELW7vKtvz4PDdS86IpyE2IQ-YcF5C-jljXSh2E-9AqNlAsaovpNHiJ3wSIVBZXY5FhddVYF_kDQPtXCVWrZfhuZ0G4wtgfKHxoKyuNdspb5gLt35IhPIgzoHy.EJeO_TnyeVp4kFHN19lVkw; path=/; HttpOnly
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: Fshm8GIXnqQpykMAAAZB
```
* __Response body:__
```json
{
  "user": {
    "name": "some name",
    "id": 3192,
    "email": "test@test.com"
  },
  "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJCYWNrZW5kIiwiZXhwIjoxNjQxNjc1NDI5LCJpYXQiOjE2NDE2NzUyNDksImlzcyI6IkJhY2tlbmQiLCJqdGkiOiI5YWQ5OGU4Yy03ZmNlLTRjZmUtOGRiMi04OGE3YTg5MWYyNWQiLCJuYmYiOjE2NDE2NzUyNDgsInN1YiI6IjMxOTIiLCJ0b2tlbl92ZXJzaW9uIjoxLCJ0eXAiOiJhY2Nlc3MifQ.C9ZTizaP1bvncSWvlgSP69J1-R0_uKZM92nLuHRKr9IJLhAX9S_IS_v7uk2mz4vyrFMMpIdO3byVqBIUsV-USQ"
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
x-request-id: Fshm8SyYYIrXWvwAAAXi
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
    "email": "some.email@gmail1474.com"
  }
}
```

##### Response
* __Status__: 422
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: Fshm7srdbTKY1xAAAAXh
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
x-request-id: Fshm7oW2z9Jxu0AAAATC
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
* __Path:__ /api/chats/878/channel_token
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
x-request-id: Fshm71H4vyYXgCkAAAUi
```
* __Response body:__
```json
{
  "user_id": 3187,
  "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJCYWNrZW5kIiwiY2hhdF9pZCI6Ijg3OCIsImV4cCI6MTY0MTY3NTQyMiwiaWF0IjoxNjQxNjc1MjQyLCJpc3MiOiJCYWNrZW5kIiwianRpIjoiODQ2YzkyNjMtYWFjOC00YzQ2LWFhZmEtYzM5ZmY3YzJjM2IxIiwibmJmIjoxNjQxNjc1MjQxLCJzdWIiOiIzMTg3IiwidHlwIjoiY2hhbm5lbCJ9.Bj2hIZz525frrC6LS4X5zefubpuBCu1PC4KLp4GIYM_Liimbc5B5usrzYpTyOrL7QqPg8m4sU3BgLAyPX5Aclg"
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
x-request-id: Fshm7O1QXmhAiAEAAAPC
```
* __Response body:__
```json
{
  "invited_chats": [],
  "chats": [
    {
      "users": [
        "some name",
        "some name"
      ],
      "message": "",
      "id": 875
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
  "user_list": [
    "some.email@gmail1155.com"
  ]
}
```

##### Response
* __Status__: 201
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: Fshm7kGi23uPGq4AAAWh
```
* __Response body:__
```json
{
  "users": [
    "some name",
    "some name"
  ],
  "message": "",
  "id": 877
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
    "some.email@gmail1346.com"
  ]
}
```

##### Response
* __Status__: 201
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: Fshm7GZLtX3g5Y8AAAVh
```
* __Response body:__
```json
{
  "users": [
    "some name",
    "some name"
  ],
  "message": "",
  "id": 874
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
* __Status__: 400
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: Fshm7TFcYp1aYc4AAAPi
```
* __Response body:__
```json
{
  "reason": "Empty invite list"
}
```

### <a id=backendweb-usercontroller-accept_chat></a>accept_chat
#### Accept a chat invitation

##### Request
* __Method:__ PUT
* __Path:__ /api/users/invited_chats/876
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
x-request-id: Fshm7bmeflJDpzwAAARC
```
* __Response body:__
```json
""
```

#### Accept non-existing a chat invitation

##### Request
* __Method:__ PUT
* __Path:__ /api/users/invited_chats/873
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
x-request-id: Fshm61S0kGO_6ocAAATh
```
* __Response body:__
```json
""
```

### <a id=backendweb-usercontroller-decline_chat></a>decline_chat
#### Decline a chat invitation

##### Request
* __Method:__ DELETE
* __Path:__ /api/users/invited_chats/871
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
x-request-id: Fshm6sn4wFASPmoAAAJj
```
* __Response body:__
```json
""
```

#### Decline non-existing a chat invitation

##### Request
* __Method:__ DELETE
* __Path:__ /api/users/invited_chats/874
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
x-request-id: Fshm69zHfss45GkAAANC
```
* __Response body:__
```json
""
```

