# Requester

## What is Requester?

Requester coordinates json api requests and responses between the server test
suite and the client test suite in Rails-based web applications.

## How does it work?

Requester captures the api requests and responses generated by a Rails test
suite and writes them to a shared file. The client-side test suite (mocha,
ember-test, etc) uses that file as the source for mocking out those
same requests.

Requester can be used with Rails API and any front end framework.

## Why would you want this?

Many web applications with extensive front-end rendering test the front-end
 independently from the relied upon server-side api.  In these siutations, changes to the
server-side api may go unnoticed by the front-end test suite leading to
an a green test suite but a broken app.  Additionally, when an api change is
communicated to the front-end team, effort is needed to ensure that the
test suite api is mocked correctly.  Requester aims to save that effort
and provide more transparency to api changes.

## Usage

Pretend we have a Rails app with a `DecksController` with
 this set of tests:

```ruby
RSpec.describe DecksController, type: :request do
  prepend Requester::Requests

  before do
    %w[diamonds hearts spades clubs].each do |suit|
      Deck.create suit: suit, cards: "A 2 3 4 5 6 7 8 9 10 J Q K"
    end
  end

  describe "GET /decks" do
    it "works! (now write some real specs)" do
      get decks_path
      expect(response).to have_http_status(200)
    end

    it 'searches' do
      get decks_path, { search: 'clubs' }, log_as: 'with search'
      expect(response).to have_http_status(200)
    end
  end

  describe 'show' do
    it "works! (now write some real specs)" do
      get deck_path(1), headers
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT /decks" do
    it "works! (now write some real specs)" do
      headers = { 'ACCEPT' => 'application/json' }
      xhr :put, deck_path(1), { deck: {cards: '10 J Q K'} }, headers
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /decks" do
    it "works! (now write some real specs)" do
      headers = { 'ACCEPT' => 'application/json' }
      post decks_path, { deck: { cards: "1 2 3", suit: 'horseshoes'} },  headers
      expect(response).to have_http_status(201)
    end
  end
end
```

Requester will generate JSON where the top level keys are controllers, followed by
actions, then the response/request generated by testing that endpoint:

```javascript
//2017-07-11 13:34:11 UTC

export default {
  "decks": {
    "index": {
      "response": {
        "status": 200,
        "body": {
          "data": [
            {
              "id": "1",
              "type": "decks",
              "attributes": {
                "cards": "A 2 3 4 5 6 7 8 9 10 J Q K",
                "suit": "diamonds"
              }
            },
            {
              "id": "2",
              "type": "decks",
              "attributes": {
                "cards": "A 2 3 4 5 6 7 8 9 10 J Q K",
                "suit": "hearts"
              }
            },
            {
              "id": "3",
              "type": "decks",
              "attributes": {
                "cards": "A 2 3 4 5 6 7 8 9 10 J Q K",
                "suit": "spades"
              }
            },
            {
              "id": "4",
              "type": "decks",
              "attributes": {
                "cards": "A 2 3 4 5 6 7 8 9 10 J Q K",
                "suit": "clubs"
              }
            }
          ]
        },
        "message": "OK"
      },
      "request": {
        "path": "/decks",
        "method": "GET"
      },
      "with search": {
        "response": {
          "status": 200,
          "body": {
            "decks": {
              "id": 4,
              "suit": "clubs",
              "cards": "A 2 3 4 5 6 7 8 9 10 J Q K"
            }
          },
          "message": "OK"
        },
        "request": {
          "path": "/decks?search=clubs",
          "method": "GET",
          "query_string": "search=clubs"
        }
      }
    },
    "show": {
      "response": {
        "status": 200,
        "body": {
          "data": {
            "id": "1",
            "type": "decks",
            "attributes": {
              "cards": "A 2 3 4 5 6 7 8 9 10 J Q K",
              "suit": "diamonds"
            }
          }
        },
        "message": "OK"
      },
      "request": {
        "path": "/decks/1",
        "method": "GET"
      }
    },
    "update": {
      "response": {
        "status": 200,
        "body": {
          "data": {
            "id": "1",
            "type": "decks",
            "attributes": {
              "cards": "10 J Q K",
              "suit": "diamonds"
            }
          }
        },
        "message": "OK"
      },
      "request": {
        "path": "/decks/1",
        "method": "PUT",
        "request_parameters": {
          "deck": {
            "cards": "10 J Q K"
          }
        },
        "media_type": "application/x-www-form-urlencoded"
      }
    },
    "create": {
      "response": {
        "status": 201,
        "body": {
          "data": {
            "id": "5",
            "type": "decks",
            "attributes": {
              "cards": "1 2 3",
              "suit": "horseshoes"
            }
          }
        },
        "message": "Created"
      },
      "request": {
        "path": "/decks",
        "method": "POST",
        "request_parameters": {
          "deck": {
            "cards": "1 2 3",
            "suit": "horseshoes"
          }
        },
        "media_type": "application/x-www-form-urlencoded"
      }
    }
  }
}
```

Now in your front end app, using whatever fake API, you can use this data
to return responses you know work (assuming you ran requester with a green suite).
You also have access to the requests.

```javascript
// meanwhile, in some fake server config in some JS framework...
import responses from 'dummy-ui/tests/responses';

myFakeApi.get('/decks', () => {
  return data.decks.index.response.body;
})
```

## Usage

There is no magic involved in Requester. It simply prepends itself in your tests so it can log the request/response. Requester expects your tests to use a reasonable set of method calls to initiate a request (xhr, get, put, patch, post, delete, head).
Requester won't actually do anything when you run your test suite normally.
When you want to capture data, run `rake requester`.

## Setup

Install requester in your development and test groups

```ruby
gem 'requester'
```

The minimum required configuration is to tell Requester where you want the JSON
dump to be stored for your front end:

```ruby
# rails_helper.rb for RSpec
# test_helper.rb for rails default

Requester::Config.initialize do |config|
  config.front_end_path = '/Users/you/code/my_ui/tests'
end
```

#### Config options

* `file_name`: By default this is set to `'responses.js'`. If you want
to use something different, set it here.
* `additional_request_attributes`: By default the the following methods are called/logged on the request object:
 - `path`, `method`, `request_parameters`, `query_string`, `media_type`.
 You can add additional methods to be logged here.
* `additional_response_attributes`: By default the the following methods are called/logged on the request object:
 - `status`, `body`, `message`
 You can add additional methods to be logged here.

```ruby
# rails_helper.rb

Request::Config.initialize do |config|
  config.file_name = 'rails_responses.js'
  config.additional_request_attributes = [:ssl?]
  config.additional_response_attributes = [:headers, :cookies]
end
```

See below for other config options.

You can set up your tests in a few ways:

#### 1. Capture request/response for every test in the file

Prepend `Requester::Requests` and every test in this group
will have a log entry.

```ruby
RSpec.describe DecksController, type: :request do
  prepend Requester::Requests

  describe "GET /decks" do
    it "works! (now write some real specs)" do
      get decks_path
      expect(response).to have_http_status(200)
    end

    it 'searches' do
      get decks_path, { search: 'clubs' }, log_as: 'with search'
      expect(response).to have_http_status(200)
    end
  end

  describe 'show' do
    it "works! (now write some real specs)" do
      get deck_path(1), headers
      expect(response).to have_http_status(200)
    end
  end
```

#### 2. Capture request/response for a describe/context block

Prepend `Requester::Requests` and only the tests in this group
will have a log entry.

```ruby
RSpec.describe DecksController, type: :request do

  describe "GET /decks" do
    prepend Requester::Requests

    it "works! (now write some real specs)" do
      get decks_path
      expect(response).to have_http_status(200)
    end

    it 'searches' do
      get decks_path, { search: 'clubs' }, log_as: 'with search'
      expect(response).to have_http_status(200)
    end
  end

  describe 'show' do
    it "works! (now write some real specs)" do
      get deck_path(1), headers
      expect(response).to have_http_status(200)
    end
  end
```

#### 3. Capture request/response for individual tests

```ruby
  describe "GET /decks" do
    it "works! (now write some real specs)" do
      get decks_path

      Requester.log_data(
        request: request,
        response: response,
        controller: controller
      )
      expect(response).to have_http_status(200)
    end

    it 'searches' do
      get decks_path, { search: 'clubs' }, log_as: 'with search'
      expect(response).to have_http_status(200)
    end
  end
```

You will likely have tests hitting the same endpoint testing different things.
For example, a test for an index action, and index with optional search params.
Specify a `log_as` option when you have multiple tests hitting the same endpoint.
Requester won't override an endpoint entry once it exists.

```ruby
  describe "GET /decks" do
    it "works! (now write some real specs)" do
      get decks_path
      expect(response).to have_http_status(200)
    end

    it 'searches' do
      get decks_path, { search: 'clubs' }, log_as: 'with search'
      expect(response).to have_http_status(200)
    end
  end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Jason Cummings/requester.
I am not looking to increase the scope of this gem, but I'll consider any ideas.
