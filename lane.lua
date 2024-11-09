n, startAddress, endAddress = nil, 0, 0
function name(lib)
    if n == lib then
        return startAddress, endAddress
    end
    local ranges = gg.getRangesList(lib or "libil2cpp.so")
    for i, v in ipairs(ranges) do
        if v.state == "Xa" then
            startAddress = v.start
            endAddress = ranges[#ranges]["end"]
            break
        end
    end
    return startAddress, endAddress
end

function patch(libname, offset, hex)
    name(libname)
    local t, total = {}, 0
    for h in string.gmatch(hex, "%S%S") do
        table.insert(
            t,
            {
                address = startAddress + offset + total,
                flags = gg.TYPE_BYTE,
                value = h .. "r"
            }
        )
        total = total + 1
    end
    local res = gg.setValues(t)
    if type(res) ~= "string" then
        return true
    else
        gg.alert(res)
        return false
    end
end

function find(Search, Write, Type)
    gg.clearResults()
    gg.setVisible(false)
    gg.searchNumber(Search[1][1], Type)
    local count = gg.getResultCount()
    local result = gg.getResults(count)
    gg.clearResults()
    local data = {}
    local base = Search[1][2]
    if (count > 0) then
        for i, v in ipairs(result) do
            v.isUseful = true 
        end        
        for k=2, #Search do
            local tmp = {}
            local offset = Search[k][2] - base 
            local num = Search[k][1]
            for i, v in ipairs(result) do
                tmp[#tmp+1] = {} 
                tmp[#tmp].address = v.address + offset
                tmp[#tmp].flags = v.flags
            end
            tmp = gg.getValues(tmp)
            for i, v in ipairs(tmp) do
                if ( tostring(v.value) ~= tostring(num) ) then 
                    result[i].isUseful = false 
                end
            end
        end
        for i, v in ipairs(result) do
            if (v.isUseful) then 
                data[#data+1] = v.address
            end
        end
        if (#data > 0) then
            local t = {}
            local base = Search[1][2]
            for i=1, #data do
                for k, w in ipairs(Write) do
                    local offset = w[2] - base
                    t[#t+1] = {
                        address = data[i] + offset,
                        flags = Type,
                        value = w[1]
                    }
                    if (w[3] == true) then
                        local item = { t[#t] }
                        item[#item].freeze = true
                        gg.addListItems(item)
                    end
                end
            end
            gg.setValues(t)
            gg.toast("✅")
        end
    end
end
