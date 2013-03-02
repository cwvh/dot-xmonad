import Data.Map (fromList)
import Data.Monoid (mappend)

import XMonad
import XMonad.Actions.Volume
import XMonad.Util.EZConfig
import qualified XMonad.StackSet as W

main = do
    xmonad $ defaultConfig
        { manageHook = myManageHook
        }
        `additionalKeysP` myKeys

myManageHook = composeAll
    [ className =? "Vlc"        --> doFloat
    -- , className =? "Chromium"   --> doF (W.shift (myWorkspaces !! 2))
    ]

myKeys =
    [ ("M-w"        , spawn "chromium")
    , ("M-S-w"      , spawn "chromium --incognito")
    , ("<F5>"       , getMute >>= setMute . not >> return ())
    , ("<F6>"       , setMute False >> lowerVolume 8 >> return ())
    , ("<F7>"       , setMute False >> raiseVolume 8 >> return ())
    ]
