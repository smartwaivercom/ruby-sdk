dir = File.dirname(__FILE__)

require 'rubygems'
require 'fakeweb'
require 'rr'
require 'json'

$LOAD_PATH << "#{dir}/../lib/smartwaiver-sdk"
require 'smartwaiver_base'
require 'smartwaiver_errors'

API_URL = 'https://api.smartwaiver.com'

def json_parse(data)
  JSON.parse(data, :symbolize_names => true)
end

def json_api_version_results
  json = <<JAVASCRIPT
{"version": "4.0.0"}
JAVASCRIPT
  json
end

def json_base_results
  json = <<JAVASCRIPT
{"version":4, "id":"8e82fa534da14b76a05013644ee735d2", "ts":"2017-01-17T15:46:58+00:00", "type":""}
JAVASCRIPT
end

def json_webhook_configuration_results
  json = <<JAVASCRIPT
{"version":4, "id":"8e82fa534da14b76a05013644ee735d2", "ts":"2017-01-17T15:46:58+00:00", "type":"webhooks", "webhooks":{"endpoint":"http://requestb.in/1ajthro1", "emailValidationRequired":"yes"}}
JAVASCRIPT
end

def json_webhook_configure_results
  json = <<JAVASCRIPT
{"version":4, "id":"8e82fa534da14b76a05013644ee735d2", "ts":"2017-01-17T15:46:58+00:00", "type":"webhooks", "webhooks":{"endpoint":"http://requestb.in/1ajthro2", "emailValidationRequired":"yes"}}
JAVASCRIPT
end


def json_template_list_results
  json = <<JAVASCRIPT
{"version":4,"id":"05928f4b1b3849c9a73aca257808f1d5","ts":"2017-01-17T22:33:56+00:00","type":"templates","templates":
  [{"templateId":"586ffe15134bc","title":"Template 1","publishedVersion":1,"publishedOn":"2017-01-06 20:33:35","webUrl":"https:\/\/www.smartwaiver.com\/w\/586ffe15134bc\/web\/","kioskUrl":"https:\/\/www.smartwaiver.com\/w\/586ffe15134bc\/kiosk\/"},
   {"templateId":"5845e3a0add4d","title":"Template 2","publishedVersion":3,"publishedOn":"2017-01-05 20:33:35","webUrl":"https:\/\/www.smartwaiver.com\/w\/5845e3a0add4d\/web\/","kioskUrl":"https:\/\/www.smartwaiver.com\/w\/5845e3a0add4d\/kiosk\/"},
   {"templateId":"56ce3bb69c748","title":"Template 3","publishedVersion":4,"publishedOn":"2016-02-24 23:34:37","webUrl":"https:\/\/www.smartwaiver.com\/w\/56ce3bb69c748\/web\/","kioskUrl":"https:\/\/www.smartwaiver.com\/w\/56ce3bb69c748\/kiosk\/"}
  ]
}
JAVASCRIPT
end

def json_template_single_results
  json = <<JAVASCRIPT
{"version":4,"id":"81b24d6b6c364ead9af037c5652b897e","ts":"2017-01-19T01:02:36+00:00","type":"template","template":{"templateId":"586ffe15134bc","title":"Template 1","publishedVersion":1,"publishedOn":"2017-01-06 20:33:35","webUrl":"https:\/\/www.smartwaiver.com\/w\/586ffe15134bc\/web\/","kioskUrl":"https:\/\/www.smartwaiver.com\/w\/586ffe15134bc\/kiosk\/"}}
JAVASCRIPT
end

def json_waiver_list_results
  json = <<JAVASCRIPT
{"version":4,"id":"f73838873a6b470d804ff2cfe002e0de","ts":"2017-01-19T01:18:42+00:00","type":"waivers","waivers":
  [{"waiverId":"Vzy8f6gnCWVcQBURdydwPT","templateId":"586ffe15134bc","title":"Template 1","createdOn":"2017-01-06 21:28:13","expirationDate":"","expired":false,"verified":true,"kiosk":true,"firstName":"John","middleName":"","lastName":"Doe","dob":"1987-06-09","isMinor":false,"tags":[]},
   {"waiverId":"ko4C4rcUvHe3VnfKJ2Cmr6","templateId":"586ffe15134bc","title":"Template 1","createdOn":"2017-01-06 21:25:26","expirationDate":"","expired":false,"verified":true,"kiosk":true,"firstName":"Jane","middleName":"","lastName":"Doe","dob":"1983-07-01","isMinor":false,"tags":[]},
   {"waiverId":"VUey8JHxC4ED2r7jiWszNE","templateId":"586ffe15134bc","title":"Template 1","createdOn":"2017-01-06 20:39:03","expirationDate":"","expired":false,"verified":true,"kiosk":true,"firstName":"Jimmy","middleName":"","lastName":"Smith","dob":"1980-03-07","isMinor":false,"tags":[]}
  ]}
JAVASCRIPT
end

def json_waiver_single_results
  json = <<JAVASCRIPT
{"version":4,"id":"7730a96154874baca44ec7ac3444ebee","ts":"2017-01-19T01:22:50+00:00","type":"waiver","waiver":
    {"waiverId":"Vzy8f6gnCWVcQBURdydwPT",
     "templateId":"586ffe15134bc",
     "title":"Template 1",
     "createdOn":"2016-12-05 19:58:42",
     "expirationDate":"",
     "expired":false,
     "verified":true,
     "kiosk":false,
     "firstName":"Jane",
     "middleName":"L",
     "lastName":"Smith",
     "dob":"2004-07-01",
     "isMinor":true,
     "tags":[],
     "participants":[
       {"firstName":"Jane",
        "middleName":"L",
        "lastName":"Smith",
        "dob":"2004-07-01",
        "isMinor":true,
        "gender":"Female",
        "phone":"888-555-1214",
        "tags":[],
        "customParticipantFields":{"58458713a384a":{"value":"Short","displayText":"Custom text for minor"}}
       },
       {"firstName":"Joe",
        "middleName":"",
        "lastName":"Smith",
        "dob":"1969-02-02",
        "isMinor":false,
        "gender":"Male",
        "phone":"888-555-1213",
        "tags":[],
        "customParticipantFields":{"58458713a384a":{"value":"Hello World","displayText":"Custom text for minor"}}}
     ],
     "customWaiverFields":{"58458759da897":{"value":"Testing","displayText":"Question at waiver fields"}},
     "guardian":null,
     "email":"cs@smartwaiver.com",
     "marketingAllowed":true,
     "addressLineOne":"123 Main St",
     "addressLineTwo":"",
     "addressCity":"Bend",
     "addressState":"OR",
     "addressZip":"97703",
     "addressCountry":"US",
     "emergencyContactName":"John Doe",
     "emergencyContactPhone":"888-555-1212",
     "insuranceCarrier":"BlueCross",
     "insurancePolicyNumber":"X001234",
     "driversLicenseNumber":"C1234324",
     "driversLicenseState":"CA",
     "clientIP":"127.0.0.1",
     "pdf":""}
}
JAVASCRIPT
end
