import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Actions.Volume
import XMonad.Hooks.FadeInactive
import System.IO

myWorkspaces = ["1: shell", "2: web", "3: mail"] ++ map show [4 .. 9]

main = do
     --xmproc <- spawnPipe "/home/adam/.cabal/bin/xmobar /home/adam/.xmobarrc"
     xmproc <- spawnPipe "xmobar -x 0"
     xmproc2 <- spawnPipe "xmobar -x 1"
     spawn "display -window root ~/Pictures/futurama.jpg"
     spawn "setxkbmap -option ctrl:nocaps"
     xmonad $ defaultConfig {
     	    manageHook = manageDocks <+> manageHook defaultConfig,
	    layoutHook = avoidStruts $ layoutHook defaultConfig,
	    logHook = dynamicLogWithPP xmobarPP {
	    	      ppOutput = hPutStrLn xmproc,
		      ppTitle = xmobarColor "green" "" . shorten 50
		      } 
                      >> dynamicLogWithPP xmobarPP { 
                      ppOutput = hPutStrLn xmproc2,
                      ppTitle = xmobarColor "green" "" . shorten 50
                      },
	    modMask = mod4Mask,
            borderWidth = 1,
            workspaces = myWorkspaces
	    } `additionalKeys`
            [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
	    , ((0, xK_F4), spawn "suspend-comp 0")
	    , ((mod4Mask, xK_c), spawn "chromium-browser")
            , ((mod4Mask, xK_f), spawn "firefox")
	    , ((0, xK_F9), spawn "thunderbird")
	    , ((0, 0x1008FF11), lowerVolume 4 >> return ())
	    , ((0, 0x1008FF13), raiseVolume 4 >> return ())
	    , ((0, 0x1008FF12), toggleMute >> return())
	    , ((mod4Mask, xK_s), spawn "spotify")
            , ((mod4Mask, xK_b), sendMessage ToggleStruts)
            ]