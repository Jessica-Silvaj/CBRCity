Scriptname = "Night_NailShop"

Config = Config or {
    Debug = false,
    AutoRunSQL = true,
    Locale = "br",
    Target = false,
    Notify = "vrp",

    Commands = {
        ["reload_nails"] = {
            name = "reload_nails",
            help = "Reload your nail design from the database."
        }
    },

    NailStudios = {
        {
            name = "Harem",
            coords = vec3(217.09, -1544.95, 28.29),
            job = false,
            tables = {
                {
                    customer = {
                        coords = vec4(220.95503234863, -1545.1121826172, 28.290630340576, -53.0),
                        cameraOffset = vec3(0.0, -0.45, 1.5),
                        chairOffset = vec3(0.0, -0.8, 0.2)
                    },
                    employee = {
                        coords = vec4(219.01142883301, -1546.6011962891, 28.290410995483, 127.0),
                        chairOffset = vec3(0.0, -0.4, -0.3)
                    }
                },
                {
                    customer = {
                        coords = vec4(215.93556213379, -1548.935546875, 28.290410995483, -127.0),
                        cameraOffset = vec3(0.0, -0.45, 1.5),
                        chairOffset = vec3(0.0, -0.8, 0.2)
                    },
                    employee = {
                        coords = vec4(217.88572692871, -1547.4417724609, 28.290630340576, -53.0),
                        chairOffset = vec3(0.0, -0.4, -0.3)
                    }
                },
                {
                    customer = {
                        coords = vec4(213.08038330078, -1545.2966308594, 28.290410995483, -127.0),
                        cameraOffset = vec3(0.0, -0.45, 1.5),
                        chairOffset = vec3(0.0, -0.8, 0.2)
                    },
                    employee = {
                        coords = vec4(215.02543640137, -1543.806640625, 28.290630340576, -53.0),
                        chairOffset = vec3(0.0, -0.4, -0.3)
                    }
                },
                {
                    customer = {
                        coords = vec4(217.96156311035, -1541.3356933594, 28.290508270264, -53.0),
                        cameraOffset = vec3(0.0, -0.45, 1.5),
                        chairOffset = vec3(0.0, -0.8, 0.2)
                    },
                    employee = {
                        coords = vec4(216.04086303711, -1542.8074951172, 28.290288925171, -127.0),
                        chairOffset = vec3(0.0, -0.4, -0.3)
                    }
                }
            }
        }
    },

    BlipSettings = {
        show = false,
        sprite = 279,
        color = 8,
        scale = 0.7,
        name = "Nail Studio"
    },

    FingerBones = {
        ["left_hand_1"] = 45,
        ["left_hand_2"] = 50,
        ["left_hand_3"] = 54,
        ["left_hand_4"] = 57,
        ["left_hand_5"] = 60,
        ["right_hand_1"] = 74,
        ["right_hand_2"] = 79,
        ["right_hand_3"] = 83,
        ["right_hand_4"] = 86,
        ["right_hand_5"] = 89
    }
}

function LoadNailConfig()
    return Config
end
