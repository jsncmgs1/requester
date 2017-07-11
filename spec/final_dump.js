//2017-07-11 16:51:08 -0400

export default {
  "users": {
    "index": {
      "response": {
        "status": 200,
        "body": {
          "users": [
            {
              "id": 1,
              "name": "Bob"
            }
          ]
        },
        "message": "OK"
      },
      "with search params": {
        "response": {
          "status": 200,
          "body": {
            "users": [
              {
                "id": 2,
                "name": "John"
              }
            ]
          },
          "message": "OK"
        }
      }
    }
  }
}