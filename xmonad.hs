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
        `additionalKeys` myKeys

winKey = mod4Mask
altKey = mod1Mask
volumeStep = 8

myKeys =
    [ ((altKey .|. controlMask, xK_l), spawn "systemctl suspend")

    -- applications
    , ((winKey, xK_c), spawn "chromium")
    , ((winKey .|. shiftMask, xK_c), spawn "chromium --incognito")

    -- function keys
    , ((0, xK_F5), getMute >>= setMute . not >> return ())
    , ((0, xK_F6), setMute False >> lowerVolume volumeStep >> return ())
    , ((0, xK_F7), setMute False >> raiseVolume volumeStep >> return ())
    ]

myManageHook = composeAll
    [ className =? "Vlc"        --> doFloat
    -- , className =? "Chromium"   --> doF (W.shift (myWorkspaces !! 2))
    ]
