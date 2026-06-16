local allowed_ext = {".png", ".jpg", ".jpeg"}
local blocked_ext = {".php", ".exe", ".sh", ".bat", ".js" , ".svg"}  -- dangerous extensions

local function ends_with(str, ending)
    return str:lower():sub(-#ending) == ending:lower()
end

local function contains_blocked(str)
    str = str:lower()
    for _, ext in ipairs(blocked_ext) do
        if str:find(ext, 1, true) then
            return true
        end
    end
    return false
end

local headers = ngx.req.get_headers()
local content_type = headers["content-type"]
local is_admin = false

local admin_ips = {
        ["188.136.193.194"] = true,
        ["193.186.32.236"] = true,
	["188.75.66.34"] = true
}

local client_ip = ngx.var.remote_addr

local is_admin = admin_ips[client_ip] or false

ngx.log(ngx.ERR, "Client IP: ", client_ip, " | Admin: ", tostring(is_admin))

if content_type and content_type:find("multipart/form-data", 1, true) and not is_admin then
    ngx.req.read_body()
    local body = ngx.req.get_body_data()
    if body then
        for filename in body:gmatch('filename="(.-)"') do
            -- 1. Check allowed extensions
            local allowed = false
            for _, ext in ipairs(allowed_ext) do
                if ends_with(filename, ext) then
                    allowed = true
                    break
                end
            end
            if not allowed then
                ngx.status = 403
                ngx.say("Blocked upload: only PNG, JPG, JPEG allowed")
                ngx.exit(403)
            end

            -- 2. Check for multiple dangerous extensions
            if contains_blocked(filename) then
                ngx.status = 403
                ngx.say("Blocked upload: filename contains forbidden extension")
                ngx.exit(403)
            end
        end
    end
end
ngx.req.discard_body()

