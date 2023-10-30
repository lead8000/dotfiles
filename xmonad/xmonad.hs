import XMonad
import XMonad.Util.EZConfig
import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageDocks (avoidStruts, manageDocks)
import XMonad.Layout.Spacing (spacing)
import XMonad.Hooks.EwmhDesktops (ewmh)

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

main = do
    xmonad $ ewmh def
        { terminal    = "alacritty"
        , modMask     = mod1Mask -- use Win key instead of Alt as MOD key
        , manageHook  = manageDocks <+> manageHook def
	, layoutHook  = avoidStruts $ spacing 10 $ layoutHook def
        -- , layoutHook  = avoidStruts $ spacing 10 $ layoutHook def  -- Ajuste aquí
        , workspaces  = myWorkspaces
        } `additionalKeys`
        ( [ ((mod1Mask, xK_t), spawn "alacritty")  -- terminal
          , ((mod1Mask, xK_f), spawn "rofi -show drun") -- rofi
          , ((mod1Mask .|. shiftMask, xK_c), kill) -- close
          , ((mod1Mask, xK_n), windows W.focusDown) --
          , ((mod1Mask, xK_p), windows W.focusUp) --
          ] ++
          [ ((m .|. mod1Mask, k), windows $ f i)
          | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
          , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
          ]
        )

