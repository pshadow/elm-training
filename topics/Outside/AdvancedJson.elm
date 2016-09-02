module Outside.AdvancedJson exposing (..)

{-

* Handling errors
* Combining decoders
* Decoding union types with `andThen`
* Using elm-json-extra
* Handling optional fields with `maybe`
* Handling polymorphic values with `oneOf`
* Handling null with `null`

* Jsone Encoding for POST bodies etc

encodeSection : PostedSection -> Value
encodeSection section =
  Encode.object
    [ ( "title", Encode.string section.title )
    , ( "offeringId", Encode.string section.offeringId )
    , ( "sectionId", Encode.string section.sectionId )
    ]

-}