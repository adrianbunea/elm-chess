port module Store exposing (Store, save)

import Json.Encode as Encode


type alias Store =
    { playerName : String
    }


save : Store -> Cmd msg
save store =
    Encode.object
        [ ( "playerName", Encode.string store.playerName )
        ]
        |> saveStore



-- PORTS


port saveStore : Encode.Value -> Cmd msg
