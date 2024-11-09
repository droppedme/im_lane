gg.setVisible(false)

function check()
  if gg.getTargetInfo() and gg.getTargetInfo().packageName == "org.pronyaroslav.libretorrent" and gg.getVersion() == "1.2.2" then
    hello()
  else
    gg.alert([[
⚠️ Простите, но скачайте наш Gameguardian чтобы запустить скрипт, спасибо за понимание

⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

🕊️  Наш телеграмм: @fimozroot

⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

📄 Версия скрипта: 0.1
]])
    os.exit()
  end
end

function hello()
    gg.alert([[
🎠  Скрипт для игры Hide Online

⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

🔧  Версия игры: 4.9.13
📄  Версия скрипта: 0.1

⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

🎉  Удачной игры!
]])
    main()
end

function dev()
    gg.alert([[
💻  Создатель: @bycmd

⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

💌  Помогали: @eclipseofficall, @ceed3
]])
    main()
end

local n, startAddress, endAddress, active = nil, 0, 0, 1

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


function autowin()
    local choice = gg.alert("Выберите действие (для автовина)", "Включить", "Отключить")
    if choice == 1 then
        patch("libil2cpp.so", 0xA65208, "20 00 80 D2 C0 03 5F D6")
        patch("libil2cpp.so", 0x9CF180, "20 00 80 D2 C0 03 5F D6")
        gg.toast("✅")
    elseif choice == 2 then
        patch("libil2cpp.so", 0xA65208, "00 00 80 D2 C0 03 5F D6")
        patch("libil2cpp.so", 0x9CF180, "00 00 80 D2 C0 03 5F D6")
        gg.toast("✅")
    end
end

function bypass()
    patch("libil2cpp.so", 0xA65208, "20 00 80 D2 C0 03 5F D6")
    patch("libil2cpp.so", 0xA0B3DC, "00 00 80 D2 C0 03 5F D6")
end
function unlockall()
    patch("libil2cpp.so", 0xA03E94, "20 00 80 D2 C0 03 5F D6")
    patch("libil2cpp.so", 0x9FD280, "20 00 80 D2 C0 03 5F D6")
    gg.toast("✅")
end
function disablehae()
    patch("libil2cpp.so", 0x99418C, "00 00 80 D2 C0 03 5F D6")
    gg.toast("✅")
end
function ability()
    patch("libil2cpp.so", 0xA0361C, "E0 7B 40 B2 C0 03 5F D6")
    patch("libil2cpp.so", 0xA0360C, "E0 7B 40 B2 C0 03 5F D6")
    patch("libil2cpp.so", 0x9EFD2C, "00 00 80 D2 C0 03 5F D6")
    gg.toast("✅")
end
function nocd()
    patch("libil2cpp.so", 0x983F60, "00 00 80 D2 C0 03 5F D6")
    patch("libil2cpp.so", 0x9852C0, "00 00 80 D2 C0 03 5F D6")
    gg.toast("✅")
end
function godmode()
    patch("libil2cpp.so", 0x990C4C, "00 00 80 D2 C0 03 5F D6")
    patch("libil2cpp.so", 0x987CE4, "00 00 80 D2 C0 03 5F D6")
    gg.toast("✅")
end
function airjump()
    patch("libil2cpp.so", 0x1E3EA3C, "20 00 80 D2 C0 03 5F D6")
    gg.toast("✅")
end
function hahaha()
    patch("libil2cpp.so", 0x98F9D4, "00 00 80 D2 C0 03 5F D6")
    gg.toast("✅")
end
function animhae()
    patch("libil2cpp.so", 0x98A18C, "00 00 80 D2 C0 03 5F D6")
    gg.toast("✅")
end

function ammo()
    find({{"1908760776198172", 0}}, {{"9901469729391030", 0, false}}, gg.TYPE_QWORD)
end
function firerate()
    find({{"4474920502942729703", 0}}, {{"1500000", 0, false}}, gg.TYPE_QWORD)
end
function damagehack()
    find({{"1908859560445980", 0}}, {{"16000000000000000", 0, false}}, gg.TYPE_QWORD)
end
function nocdstickers()
    find({{"4665729215014476186", 0}}, {{"0", 0, true}}, gg.TYPE_QWORD)
end
function speedhack()
    find({{"5.11009550095F;8.22019100189F", 0}}, {{"17", 0, true}}, gg.TYPE_FLOAT)
end 
function esp()
    find({{"4590068740410625229", 0}}, {{"4590068740424625229", 0, false}}, gg.TYPE_QWORD)
    find({{"4692750811720057088", 0}}, {{"0", 0, true}}, gg.TYPE_QWORD)
end

function choose()
    local menu =
        gg.multiChoice(
        {
            "🔸  Открыть все скины",
            "🔸  Бесконечные способности",
            "🔸  Выключить гранаты",
            "🔸  Выключить анимации гранат",
            "🔸  Способности без задержки",
            "🔸  Выключить насмешку",
            "🔸  Режим бессмертия",
            "🔸  Большой урон",
            "🔸  Увеличить бег и прыжок",
            "🔸  Бесконечные патроны",
            "🔸  Быстрая стрельба",
            "🔸  Бесконечный прыжок",
            "🔸  Авто победа",
            "Включать только в раунде:",
            "🔸  Стикеры без задержки",
            "🔸  Видить через стены",
            "↩️  Назад"
        },
        nil,
        [[
Мой телеграмм: @bycmd
⏳  Время: ]] .. os.date("%H:%M:%S") .. [[]]
    )
    if menu == nil then
        return
    end
    if menu[1] then
        unlockall()
    end
    if menu[2] then
        ability()
    end
    if menu[3] then
        disablehae()
    end
    if menu[4] then
        animhae()
    end
    if menu[5] then
        nocd()
    end
    if menu[6] then
        hahaha()
    end
    if menu[7] then
        godmode()
    end
    if menu[8] then
        damagehack()
    end
    if menu[9] then
        speedhack()
    end
    if menu[10] then
        ammo()
    end
    if menu[11] then
        firerate()
    end
    if menu[12] then
        airjump()
    end
    if menu[13] then
        autowin()
    end
    if menu[14] then
        choose()
    end
    if menu[15] then
        nocdstickers()
    end
    if menu[16] then
        esp()
    end
    if menu[17] then
        main()
    end
end

function main()
    bypass()
    active = 0
    local menu =
        gg.choice(
        {
            "🏆  Функции",
            "💻  Создатели",
            "⛔  Закрыть"
        },
        nil,
        [[
Мой телеграмм: @bycmd
⏳  Время: ]] .. os.date("%H:%M:%S") .. [[]]
    )
    if menu == nil then
        return
    end
    if menu == 1 then
        choose()
    end
    if menu == 2 then
        dev()
    end
    if menu == 3 then
        os.exit()
    end
end

check()

while true do
    if gg.isVisible(true) then
        active = 1
        gg.setVisible(false)
    end
    if active == 1 then
        main()
        active = 0
    end
end
