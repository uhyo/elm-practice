module Util exposing (styles)

import Html.Attributes exposing (style)


styles =
    List.map (\( k, v ) -> style k v)
