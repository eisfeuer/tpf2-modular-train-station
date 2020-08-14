function data()
    return {
        numLanes = 2,
        streetWidth = 0.1,
        sidewalkWidth = 0.1,
        sidewalkHeight = .00,
        yearFrom = 1925,
        yearTo = 0,
        upgrade = false,
        country = false,
        speed = 30.0,
        type = "new small",
        name = _("Small street"),
        desc = _("Two-lane street with a speed limit of %2%."),
        categories = { "urban" },
        borderGroundTex = "street_border.lua",
        materials = {
            streetPaving = {},		
            --streetBorder = {
                --name = "street/new_small_border.mtl",
                --size = { 1.5, 0.625 }
            
            --},			
            streetLane = {},
            streetStripe = {},
            streetStripeMedian = {},
            streetBus = {},
            streetTram = {},
            streetTramTrack = {},
            crossingLane = {},
            crossingBus = {},
            crossingTram = {},
            crossingTramTrack = {},
            crossingCrosswalk = {},
            sidewalkPaving = {},
            sidewalkLane = {},
            sidewalkBorderOuter = {},
            sidewalkCurb = {},
            sidewalkWall = {},
            catenary = {}
        },
        assets = {
        },
        catenary = {
        },
        signalAssetName = "asset/ampel.mdl",
        cost = 20.0,
    }
    end
    