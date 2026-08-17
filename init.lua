--!nocheck
shared.catdata = {Key = script_key or 'none'}
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end

local downloader = Instance.new('TextLabel')
downloader.Size = UDim2.new(1, 0, 0, 40)
downloader.BackgroundTransparency = 1
downloader.TextStrokeTransparency = 0
downloader.TextSize = 20
downloader.TextColor3 = Color3.new(1, 1, 1)
downloader.Font = Enum.Font.Arial

local function downloadFile(path, func)
	if not isfile(path) then
		downloader.Text = 'Downloading '.. path
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/loopfront726/vapeskid/'..readfile('vapeskid/profiles/commit.txt')..'/'..select(1, path:gsub('vapeskid/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
		downloader.Text = ''
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('init') then continue end
		if file:find('profile') then continue end
		if isfile(file) then
			delfile(file)
		elseif isfolder(file) then
			wipeFolder(file)
		end
	end
end


for _, folder in {'vapeskid', 'vapeskid/games', 'vapeskid/profiles', 'vapeskid/assets', 'vapeskid/libraries', 'vapeskid/guis'} do
	if not isfolder(folder) then
		downloader.Text = 'Downloading '.. folder
		makefolder(folder)
	end
end

if not shared.VapeDeveloper then
	local _, subbed = pcall(function() 
		return game:HttpGet('https://github.com/loopfront726/vapeskid') 
	end)
	local commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'
	if commit == 'main' or (isfile('vapeskid/profiles/commit.txt') and readfile('vapeskid/profiles/commit.txt') or '') ~= commit then
		if commit ~= 'main' and isfile('vapeskid/profiles/commit.txt') then
			shared.updated = readfile('vapeskid/profiles/commit.txt')
		end
		wipeFolder('vapeskid')
		wipeFolder('vapeskid/games')
		wipeFolder('vapeskid/guis')
		wipeFolder('vapeskid/libraries')
	end
	writefile('vapeskid/profiles/commit.txt', commit)
end

return loadstring(downloadFile('vapeskid/main.lua'), 'main')()
