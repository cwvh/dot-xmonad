import Data.Map (fromList)
import Data.Monoid (mappend)
import System.IO (hPutStrLn)

import XMonad
import XMonad.Actions.Volume
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig
import XMonad.Util.Run (spawnPipe)
import qualified XMonad.StackSet as W

main = do
    xmobar <- spawnPipe "xmobar"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig
        , layoutHook = avoidStruts $ layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmobar
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
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
    , ("M-S-z"      , spawn "systemctl suspend")
    ]
