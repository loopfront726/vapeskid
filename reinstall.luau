local cloneref = cloneref or function(ref: any)
    return ref
end

if isfolder('vapeskid') then
    delfolder('vapeskid')
end

cloneref(game:GetService('StarterGui')):SetCore('SendNotification', {
    Title = 'Cat Vape',
    Text = 'Successfully reinstalled Cat Vape, Please rejoin ur game to take effect',
    Duration = 20
})