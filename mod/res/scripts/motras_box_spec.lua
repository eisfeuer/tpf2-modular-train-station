local Box = require('motras_box')

describe("box", function ()
    local box = Box:new({ -11, -17, 0 },  { 11, 0, 4 })

    describe("getCenterPoint", function ()
        it ("returns center point of the box", function ()
            assert.are.same({0, -8.5, 2}, box:getCenterPoint())
        end)
    end)

    describe("getCenterPointAsVec3", function ()
        it ("returns center point of the box", function ()
            assert.are.same({x = 0, y = -8.5, z = 2}, box:getCenterPointAsVec3())
        end)
    end)

    describe("getHalfExtends", function ()
        it ("returns half extends", function ()
            assert.are.same({11, 8.5, 2}, box:getHalfExtends())
        end)
    end)

    describe("getGroundFace", function ()
        it ("returns ground face of the box", function ()
            assert.are.same({
                { 11, 0, 0.0, 1.0 },
                { 11, -17, 0.0, 1.0 },
                { -11, -17, 0.0, 1.0 },
                { -11, 0, 0.0, 1.0 },
            }, box:getGroundFace())
        end)
    end)
end)