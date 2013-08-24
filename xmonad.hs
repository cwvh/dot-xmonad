import Data.Map (fromList)
import Data.Monoid (mappend)
import System.IO (hPutStrLn)

import XMonad
--import XMonad.Actions.Volume
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig
import XMonad.Util.Run (spawnPipe)
import qualified XMonad.StackSet as W

winKey = mod4Mask
altKey = mod1Mask
volumeStep = 4

main = do
    xmobar <- spawnPipe "xmobar"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig
        , layoutHook = avoidStruts $ layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmobar
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , terminal = "urxvt"
        }
        `additionalKeys` myKeys

myKeys =
    [ ((winKey, xK_s), spawn "systemctl suspend")

    -- applications
    --, ((winKey, xK_c), spawn "chromium")
    --, ((winKey .|. shiftMask, xK_c), spawn "chromium --incognito")
    , ((winKey, xK_f), spawn "firefox")

    -- audio management
    --, ((winKey, xK_F5), getMute >>= setMute . not >> return ())
    --, ((winKey, xK_F6), setMute False >> lowerVolume volumeStep >> return ())
    --, ((winKey, xK_F7), setMute False >> raiseVolume volumeStep >> return ())
    ]

myManageHook = composeAll
    [ className =? "Vlc"        --> doFloat
    -- , className =? "Chromium"   --> doF (W.shift (myWorkspaces !! 2))
    ]
