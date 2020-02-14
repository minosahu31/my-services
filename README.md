# My Services SDK
Ruby SDK for myservices.com's API. 

## Usage
Install the gem.
```ruby
gem 'my-services'
```
Set the API Key.
```ruby
MyServices.api_key = API_KEY
```

## Load Category
**Post**
```ruby
worker = MyServices::Worker.load_category
```

## Load Billers
**Post**
```ruby
worker = MyServices::Worker.do_payment(id)
```

## Do payment
**Post**
```ruby
worker = MyServices::Worker.post({id: '879873', customerRef: '9725312313', billerId: 1244, narration: "airtime top up", accountNumber: "1231231233", paymentDate: "2019-01-01" })
```

## Error Handling
```ruby
begin
  # perform my services api requests
rescue AuthenticationError => e
  # API authentication issues
rescue ConnectionError => e
  # API connection Problems
rescue InvalidRequestError => e
  # Bad request/invalid request params
  # also if resource is not found
rescue MyServicesError => e
  # general error
end
