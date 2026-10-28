Settings = {}

-- Contract status values
Settings.status = {
    WAITING     = "waiting",
    READY       = "ready",
    IN_PROGRESS = "in_progress",
    COMPLETED   = "completed",
    CANCELLED   = "cancelled",
}

-- Task status values
Settings.taskStatus = {
    WAITING   = "waiting",
    ACTIVE    = "active",
    COMPLETED = "completed",
}

-- Security / validation settings
Settings.security = {
    maxInteractionDistance   = 5.0,
    maxSimultaneousContracts = 1,
}

-- Per-action server-side rate limits (milliseconds)
Settings.rateLimits = {
    join     = 1000,
    leave    = 1000,
    start    = 1000,
    kick     = 1000,
    transfer = 1000,
    finish   = 500,
    setVar   = 300,
}

-- State sync debounce
Settings.sync = {
    debounceTime = 200,
}

-- Task tick defaults
Settings.taskTick = {
    defaultDelay = 0,
}