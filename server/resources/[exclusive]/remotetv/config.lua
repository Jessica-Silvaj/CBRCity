Config = {}

Config.Command = 'tv'

Config.Keybind = 'F2'

Config.DistanceToTv = 10.0

-- YouTube - 'youtube.com/watch?v={videoId}'
-- Twitch - 'twitch.tv/{channelName}'
-- PENDENTE: canal/vídeo da CBR CITY (o vídeo antigo foi removido).
-- Exemplo: { name = "CBR CITY", url = "https://www.youtube.com/watch?v=ID_DO_VIDEO" },
Config.Channels = {
}

Config.Models = {
    [`des_tvsmash_start`] = {
        DefaultVolume = 0.5,
        Range = 20.0,
        Target = "tvscreen",
        Scale = 0.085,
        Offset = vector3(-1.02, -0.055, 1.04)
    },
    [`prop_flatscreen_overlay`] = {
        DefaultVolume = 0.5,
        Range = 20.0,
        Target = "tvscreen",
        Scale = 0.085,
        Offset = vector3(-1.02, -0.055, 1.04)
    },
    [`prop_laptop_lester2`] = {
        DefaultVolume = 0.5,
        Range = 20.0,
        Target = "tvscreen",
        Scale = 0.085,
        Offset = vector3(-1.02, -0.055, 1.04)
    },
    [`prop_monitor_02`] = {
        DefaultVolume = 0.5,
        Range = 20.0,
        Target = "tvscreen",
        Scale = 0.085,
        Offset = vector3(-1.02, -0.055, 1.04)
    },
    [`prop_trev_tv_01`] = {
        DefaultVolume = 0.5,
        Range = 20.0,
        Target = "tvscreen",
        Scale = 0.085,
        Offset = vector3(-1.02, -0.055, 1.04)
    },
    [`prop_tv_02`] = {
        DefaultVolume = 0.5,
        Range = 20.0,
        Target = "tvscreen",
        Scale = 0.085,
        Offset = vector3(-1.02, -0.055, 1.04)
    },
    [`prop_tv_03_overlay`] = {
        DefaultVolume = 0.5,
        Range = 20.0,
        Target = "tvscreen",
        Scale = 0.085,
        Offset = vector3(-1.02, -0.055, 1.04)
    },
    [`prop_tv_06`] = {
        DefaultVolume = 0.5,
        Range = 20.0,
        Target = "tvscreen",
        Scale = 0.085,
        Offset = vector3(-1.02, -0.055, 1.04)
    },
    [`prop_tv_flat_01`] = {
        DefaultVolume = 0.5,
        Range = 20.0,
        Target = "tvscreen",
        Scale = 0.085,
        Offset = vector3(-1.02, -0.055, 1.04)
    },
    [`prop_tv_flat_01_screen`] = {
        DefaultVolume = 0.5,
        Range = 20.0,
        Target = "tvscreen",
        Scale = 0.085,
        Offset = vector3(-1.02, -0.055, 1.04)
    },
    [`prop_tv_flat_02b`] = {
        DefaultVolume = 0.5,
        Range = 20.0,
        Target = "tvscreen",
        Scale = 0.085,
        Offset = vector3(-1.02, -0.055, 1.04)
    },
    [`prop_tv_flat_03`] = {
        DefaultVolume = 0.5,
        Range = 20.0,
        Target = "tvscreen",
        Scale = 0.085,
        Offset = vector3(-1.02, -0.055, 1.04)
    },
    [`prop_tv_flat_03b`] = {
        DefaultVolume = 0.5,
        Range = 20.0,
        Target = "tvscreen",
        Scale = 0.085,
        Offset = vector3(-1.02, -0.055, 1.04)
    },
    [`prop_tv_flat_michael`] = {
        DefaultVolume = 0.5,
        Range = 20.0,
        Target = "tvscreen",
        Scale = 0.085,
        Offset = vector3(-1.02, -0.055, 1.04)
    },
    [`prop_monitor_w_large`] = {
        DefaultVolume = 0.5,
        Range = 20.0,
        Target = "tvscreen",
        Scale = 0.085,
        Offset = vector3(-1.02, -0.055, 1.04)
    },
    [`prop_tv_03`] = {
        DefaultVolume = 0.5,
        Range = 20.0,
        Target = "tvscreen",
        Scale = 0.085,
        Offset = vector3(-1.02, -0.055, 1.04)
    },
    [`prop_tv_flat_02`] = {
        DefaultVolume = 0.5,
        Range = 20.0,
        Target = "tvscreen",
        Scale = 0.085,
        Offset = vector3(-1.02, -0.055, 1.04)
    },
    [`vw_prop_vw_cinema_tv_01`] = {
        DefaultVolume = 0.5,
        Range = 20.0,
        Target = "tvscreen",
        Scale = 0.085,
        Offset = vector3(-1.02, -0.055, 1.04)
    },
    [`v_ilev_cin_screen`] = {
       DefaultVolume = 0.20,
       Range = 45.0,
       Target = "cinscreen", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`hei_prop_hst_laptop`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "tvscreen", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`hei_bank_heist_laptop`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "tvscreen", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`hei_heist_str_avunitl_03`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "tvscreen", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`hei_heist_str_avunits_01`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "tvscreen", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`hei_heist_str_avunitl_01`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "tvscreen", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17dlc_monitor_wall_01a`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "xm_prop_x17dlc_monitor_wall_01a", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`prop_big_cin_screen`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "cinscreen", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_flat_01`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "tv_flat_01", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`sm_prop_smug_tv_flat_01`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "tv_flat_01", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_stand_01a`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "tvstand_screen", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_screens_02a_01`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_8scrn_01", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_screens_02a_02`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_8scrn_02", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_screens_02a_03`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_8scrn_03", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_screens_02a_04`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_8scrn_04", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_screens_02a_05`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_8scrn_05", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_screens_02a_06`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_8scrn_06", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_screens_02a_07`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_8scrn_07", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_screens_02a_08`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_8scrn_08", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_ceiling_scn_01`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_ceil_scn_01", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_ceiling_scn_02`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_ceil_scn_02", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_scrn_01`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_scrn_01", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_scrn_02`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_scrn_02", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_scrn_03`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_scrn_03", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_scrn_04`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_scrn_04", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_scrn_05`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_scrn_05", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_scrn_06`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_scrn_06", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_scrn_07`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_scrn_07", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_scrn_08`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_scrn_08", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_scrn_09`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_scrn_09", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_scrn_10`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_scrn_10", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_scrn_11`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_scrn_11", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_scrn_12`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_scrn_12", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_scrn_13`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_scrn_13", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_scrn_14`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_scrn_14", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_scrn_15`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_scrn_15", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_scrn_16`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_scrn_16", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_scrn_17`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_scrn_17", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_scrn_18`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_scrn_18", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_prop_x17_tv_scrn_19`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_scrn_19", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`xm_screen_1`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "prop_x17_tv_ceiling_01", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`ex_prop_ex_tv_flat_01`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "ex_tvscreen", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
   [`1522819744`] = {
       DefaultVolume = 0.3,
       Range = 30.0,
       Target = "cinscreen", 
       Scale = 0.085, 
       Offset = vector3(-1.02, -0.055, 1.04)
   },
}

Config.Locations = {
    {
        Model = `v_ilev_cin_screen`,
        Position = vector4(1475.91,-2272.49,94.68,158.75),
    }
}