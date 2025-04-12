fx_version 'cerulean'
games { 'gta5' }

author 'zcmg#5307'
description 'V1.0'

lua54 'yes'

shared_scripts {
	'config.lua',
	'@es_extended/imports.lua'
--     '@ox_lib/init.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua'
}