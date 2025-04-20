RegisterNetEvent('zcmg_ckplayer:client:menu')
AddEventHandler('zcmg_ckplayer:client:menu', function(type)
    local players = {}
    local players_list = {}

    if type == 'menu' then
        players_list = lib.callback.await('zcmg_ckplayer:server:list', false, 'menu')
        table.insert(players, {label = 'Search' , icon = 'fa-magnifying-glass', args = {type = 'search'}})
    else
        local jobs = lib.callback.await('zcmg_ckplayer:server:jobs', false)
        local jobs_options = {}

        for _,v in pairs(jobs) do table.insert(jobs_options, {value = v.name, label = v.label}) end

        local form = lib.inputDialog('Search', {
            {type = 'input', label = 'First Name', icon = 'paper-plane'},
            {type = 'input', label = 'Last Name', icon = 'paper-plane'},
            {type = 'input', label = 'Identifier', icon = 'signature'},

            {type = 'select', label = 'Gender', icon = 'venus-mars',
                options = {
                    {value = 'm', label = 'Male'},
                    {value = 'f', label = 'Female'},
                }
            },

            {type = 'select', label = 'Job', icon = 'users', options = jobs_options },
        })

        if not form then return end

        if form[1] == '' and form[2] == '' and form[3] == '' and not form[4] and not form[5] then
            lib.notify({description = 'No player found.', type = 'error'})
            return
        end

        players_list = lib.callback.await('zcmg_ckplayer:server:list', false, 'search', form[1], form[2], form[3], form[4], form[5])

    end

    if next(players_list) == nil then
        lib.notify({description = 'No player found.', type = 'error'})
        return
    end

    for _,v in pairs(players_list) do
        local job = lib.callback.await('zcmg_ckplayer:server:joblabel', false, v.job)
        local sex
        if v.sex == 'm' then sex = 'Male' else sex = 'Female' end
        table.insert(players, {label = v.firstname..' '..v.lastname, values = {'Date of Birth: '..v.dateofbirth, 'Job: '..job, 'Gender: ' ..sex , 'Identifier: '..v.identifier}, args = {identifier = v.identifier, name = v.firstname..' '..v.lastname},  icon = 'fa-user'})
    end

    lib.registerMenu({
        id = 'list_players',
        title = 'Players',
        options = players,
    }, function(selected, scrollIndex, args)
        if args.type == 'search' then
            TriggerEvent('zcmg_ckplayer:client:menu', 'search')
        else
            local alert = lib.alertDialog({
                header = 'CK Player',
                content = 'Do you want to permanently delete the player:    \n '..args.name,
                centered = true,
                cancel = true
            })
            
            if alert == 'confirm' then TriggerServerEvent('zcmg_ckplayer:server:delete_player', args.identifier) end
        end
        
    end)

    lib.showMenu('list_players')
end)